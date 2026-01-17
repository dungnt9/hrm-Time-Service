# Time Service

gRPC microservice quản lý chấm công, nghỉ phép, tăng ca và ca làm việc cho hệ thống HRM.

## Mục lục

- [Kiến trúc](#kiến-trúc)
- [Công nghệ](#công-nghệ)
- [Nghiệp vụ](#nghiệp-vụ)
- [gRPC API](#grpc-api)
- [CQRS Pattern](#cqrs-pattern)
- [Domain Entities](#domain-entities)
- [Database Schema](#database-schema)
- [Event-Driven Architecture](#event-driven-architecture)
- [Luồng xử lý](#luồng-xử-lý)
- [Cấu hình](#cấu-hình)
- [Chạy ứng dụng](#chạy-ứng-dụng)

---

## Kiến trúc

**Clean Architecture 4-Layer Pattern:**

```
src/
├── API/                        # Layer 1: Presentation
│   ├── BackgroundServices/     # Hangfire jobs, Outbox processor
│   ├── GrpcServices/           # gRPC service implementations
│   ├── Protos/                 # Protocol buffer definitions
│   └── Program.cs              # Entry point & DI configuration
│
├── Application/                # Layer 2: Business Logic
│   ├── Features/               # CQRS Commands & Queries
│   │   ├── Attendance/
│   │   │   └── Commands/       # CheckIn, CheckOut
│   │   ├── Leave/
│   │   │   ├── Commands/       # CreateLeaveRequest, Approve, Reject
│   │   │   └── Queries/        # GetLeaveRequests, GetBalance
│   │   └── Overtime/
│   │       ├── Commands/       # CreateOvertime, Approve, Reject
│   │       └── Queries/        # GetOvertimeRequests
│   └── Common/
│       └── Abstractions/       # Repository interfaces
│
├── Domain/                     # Layer 3: Enterprise Business Rules
│   ├── Entities/               # Attendance, LeaveRequest, OvertimeRequest...
│   └── Enums/                  # AttendanceStatus, LeaveType, OvertimeStatus
│
└── Infrastructure/             # Layer 4: Data Access & External Services
    ├── Data/                   # DbContext, Configurations
    ├── Repositories/           # Repository implementations
    └── Services/               # RabbitMQ, Redis integrations
```

---

## Công nghệ

| Công nghệ | Phiên bản | Mục đích |
|-----------|-----------|----------|
| .NET | 8.0 | Framework |
| ASP.NET Core | 8.0 | Web framework |
| Entity Framework Core | 8.0 | ORM |
| PostgreSQL | 16 | Primary database |
| gRPC | - | Inter-service communication |
| MediatR | 12.x | CQRS pattern implementation |
| Redis | 7 | Caching (attendance status) |
| RabbitMQ | 3.x | Event messaging (Outbox pattern) |
| Hangfire | - | Background job processing |
| Keycloak | 23.0 | JWT Authentication & SSO |
| Serilog | - | Structured logging |

---

## Nghiệp vụ

### 1. Quản lý chấm công (Attendance)

| Chức năng | Mô tả | Quy tắc |
|-----------|-------|---------|
| Check-in | Chấm công vào làm | Ghi nhận GPS, IP, thời gian, thiết bị |
| Check-out | Chấm công ra về | Tính toán giờ làm, OT, về sớm/muộn |
| Trạng thái | Xem trạng thái hôm nay | Cache Redis 5 phút |
| Lịch sử | Xem lịch sử chấm công | Hỗ trợ filter theo ngày |

**Quy tắc tính toán:**
- **Late (Đi muộn)**: Check-in sau giờ bắt đầu ca + grace period (mặc định 15 phút)
- **Early Leave (Về sớm)**: Check-out trước giờ kết thúc ca - grace period
- **Overtime**: Làm việc ngoài giờ ca (cần đăng ký trước)
- **Total Hours**: Tính từ check-in đến check-out, trừ giờ nghỉ

### 2. Quản lý nghỉ phép (Leave Request)

| Loại nghỉ | Số ngày mặc định | Mô tả |
|-----------|------------------|-------|
| Annual | 12 ngày/năm | Nghỉ phép năm |
| Sick | 10 ngày/năm | Nghỉ ốm |
| Unpaid | Không giới hạn | Nghỉ không lương |
| Maternity | 180 ngày | Nghỉ thai sản (nữ) |
| Paternity | 5 ngày | Nghỉ cho cha |
| Wedding | 3 ngày | Nghỉ cưới |
| Bereavement | 3 ngày | Nghỉ tang |

**Quy trình duyệt 2 cấp:**
```
Employee ──> Create Request
                  │
            [Status: Pending]
                  ↓
Manager ──> Approve/Reject (Level 1)
                  │
       [Status: PartiallyApproved / Rejected]
                  ↓
HR Staff ──> Approve/Reject (Level 2)
                  │
          [Status: Approved / Rejected]
                  ↓
         Notify via RabbitMQ → Socket
```

### 3. Quản lý tăng ca (Overtime)

| Chức năng | Mô tả | Quyền |
|-----------|-------|-------|
| Đăng ký OT | Tạo đơn xin tăng ca | `employee` |
| Duyệt OT | Phê duyệt đơn tăng ca | `manager`, `hr_staff` |
| Từ chối OT | Từ chối đơn tăng ca | `manager`, `hr_staff` |

**Trạng thái Overtime:**
- `Pending`: Chờ duyệt
- `Approved`: Đã duyệt
- `Rejected`: Đã từ chối

### 4. Quản lý ca làm việc (Shift)

| Field | Mô tả |
|-------|-------|
| Name | Tên ca (Sáng, Chiều, Đêm...) |
| StartTime | Giờ bắt đầu |
| EndTime | Giờ kết thúc |
| BreakMinutes | Thời gian nghỉ giữa ca |
| LateGraceMinutes | Thời gian ân hạn đi muộn |
| EarlyLeaveGraceMinutes | Thời gian ân hạn về sớm |
| IsNightShift | Ca đêm (tính qua ngày) |

---

## gRPC API

### Service: TimeGrpc

#### Attendance Methods

| Method | Request | Response | Mô tả |
|--------|---------|----------|-------|
| `CheckIn` | `CheckInRequest` | `AttendanceResponse` | Chấm công vào |
| `CheckOut` | `CheckOutRequest` | `AttendanceResponse` | Chấm công ra |
| `GetAttendanceStatus` | `GetAttendanceStatusRequest` | `AttendanceStatusResponse` | Trạng thái hôm nay |
| `GetAttendanceHistory` | `GetAttendanceHistoryRequest` | `AttendanceHistoryResponse` | Lịch sử chấm công |

#### Leave Methods

| Method | Request | Response | Mô tả |
|--------|---------|----------|-------|
| `CreateLeaveRequest` | `CreateLeaveRequestRequest` | `LeaveRequestResponse` | Tạo đơn nghỉ phép |
| `GetLeaveRequests` | `GetLeaveRequestsRequest` | `LeaveRequestsResponse` | Danh sách đơn nghỉ |
| `GetLeaveRequestDetail` | `GetLeaveRequestDetailRequest` | `LeaveRequestResponse` | Chi tiết đơn nghỉ |
| `ApproveLeaveRequest` | `ApproveLeaveRequestRequest` | `LeaveRequestResponse` | Duyệt đơn nghỉ |
| `RejectLeaveRequest` | `RejectLeaveRequestRequest` | `LeaveRequestResponse` | Từ chối đơn nghỉ |
| `GetLeaveBalance` | `GetLeaveBalanceRequest` | `LeaveBalanceResponse` | Số ngày phép còn lại |

#### Overtime Methods

| Method | Request | Response | Mô tả |
|--------|---------|----------|-------|
| `CreateOvertimeRequest` | `CreateOvertimeRequestRequest` | `OvertimeRequestResponse` | Tạo đơn tăng ca |
| `GetOvertimeRequests` | `GetOvertimeRequestsRequest` | `OvertimeRequestsResponse` | Danh sách đơn OT |
| `GetOvertimeRequestDetail` | `GetOvertimeRequestDetailRequest` | `OvertimeRequestResponse` | Chi tiết đơn OT |
| `ApproveOvertimeRequest` | `ApproveOvertimeRequestRequest` | `OvertimeRequestResponse` | Duyệt đơn OT |
| `RejectOvertimeRequest` | `RejectOvertimeRequestRequest` | `OvertimeRequestResponse` | Từ chối đơn OT |

#### Shift Methods

| Method | Request | Response | Mô tả |
|--------|---------|----------|-------|
| `GetShifts` | `GetShiftsRequest` | `ShiftsResponse` | Danh sách ca làm |
| `GetEmployeeShift` | `GetEmployeeShiftRequest` | `ShiftResponse` | Ca làm của nhân viên |

### Request Examples

```protobuf
// Check-in với GPS location
message CheckInRequest {
  string employee_id = 1;
  double latitude = 2;
  double longitude = 3;
  string device_info = 4;
  string ip_address = 5;
  string note = 6;
}

// Tạo đơn nghỉ phép
message CreateLeaveRequestRequest {
  string employee_id = 1;
  string leave_type = 2;      // Annual, Sick, Unpaid...
  string start_date = 3;      // yyyy-MM-dd
  string end_date = 4;
  string reason = 5;
}
```

---

## CQRS Pattern

### Commands

#### Attendance

| Command | Input | Output | Mô tả |
|---------|-------|--------|-------|
| `CheckInCommand` | EmployeeId, Latitude, Longitude, DeviceInfo, IpAddress, Note | `Guid` | Chấm công vào |
| `CheckOutCommand` | EmployeeId, Latitude, Longitude, DeviceInfo, IpAddress, Note | `bool` | Chấm công ra |

#### Leave

| Command | Input | Output | Mô tả |
|---------|-------|--------|-------|
| `CreateLeaveRequestCommand` | EmployeeId, LeaveType, StartDate, EndDate, Reason | `Guid` | Tạo đơn nghỉ phép |
| `ApproveLeaveRequestCommand` | RequestId, ApproverId, Comment | `bool` | Duyệt đơn nghỉ phép |
| `RejectLeaveRequestCommand` | RequestId, ApproverId, Reason | `bool` | Từ chối đơn nghỉ |

#### Overtime

| Command | Input | Output | Mô tả |
|---------|-------|--------|-------|
| `CreateOvertimeRequestCommand` | EmployeeId, Date, StartTime, EndTime, Reason | `Guid` | Tạo đơn tăng ca |
| `ApproveOvertimeRequestCommand` | RequestId, ApproverId, Comment | `bool` | Duyệt đơn tăng ca |
| `RejectOvertimeRequestCommand` | RequestId, ApproverId, Reason | `bool` | Từ chối đơn tăng ca |

### Queries

| Query | Input | Output | Mô tả |
|-------|-------|--------|-------|
| `GetOvertimeRequestsQuery` | EmployeeId, StartDate?, EndDate? | `IEnumerable<OvertimeRequestDto>` | Lấy danh sách đơn OT |

### DTOs

```csharp
public class OvertimeRequestDto
{
    public Guid Id { get; set; }
    public Guid EmployeeId { get; set; }
    public DateTime Date { get; set; }
    public TimeSpan StartTime { get; set; }
    public TimeSpan EndTime { get; set; }
    public int TotalMinutes { get; set; }
    public string? Reason { get; set; }
    public string Status { get; set; }      // Enum as string
    public Guid? ApproverId { get; set; }
    public DateTime? ApprovedAt { get; set; }
    public string? ApproverComment { get; set; }
    public DateTime CreatedAt { get; set; }
}
```

---

## Domain Entities

### Attendance

```csharp
public class Attendance
{
    public Guid Id { get; set; }
    public Guid EmployeeId { get; set; }
    public DateTime Date { get; set; }

    // Check-in
    public DateTime? CheckInTime { get; set; }
    public double? CheckInLatitude { get; set; }
    public double? CheckInLongitude { get; set; }
    public string? CheckInAddress { get; set; }
    public string? CheckInDeviceInfo { get; set; }
    public string? CheckInIpAddress { get; set; }
    public AttendanceStatus CheckInStatus { get; set; }

    // Check-out
    public DateTime? CheckOutTime { get; set; }
    public double? CheckOutLatitude { get; set; }
    public double? CheckOutLongitude { get; set; }
    public AttendanceStatus CheckOutStatus { get; set; }

    // Calculations
    public double? TotalHours { get; set; }
    public int LateMinutes { get; set; }
    public int EarlyLeaveMinutes { get; set; }
    public int OvertimeMinutes { get; set; }

    // Relations
    public Guid? ShiftId { get; set; }
    public Shift? Shift { get; set; }
}
```

### LeaveRequest (2-Level Approval)

```csharp
public class LeaveRequest
{
    public Guid Id { get; set; }
    public Guid EmployeeId { get; set; }
    public LeaveType LeaveType { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public int TotalDays { get; set; }
    public string? Reason { get; set; }
    public LeaveRequestStatus Status { get; set; }

    // Level 1: Manager Approval
    public Guid? FirstApproverId { get; set; }
    public ApproverType FirstApproverType { get; set; }
    public DateTime? FirstApprovedAt { get; set; }
    public string? FirstApproverComment { get; set; }
    public ApprovalStatus FirstApprovalStatus { get; set; }

    // Level 2: HR Approval
    public Guid? SecondApproverId { get; set; }
    public ApproverType SecondApproverType { get; set; }
    public DateTime? SecondApprovedAt { get; set; }
    public string? SecondApproverComment { get; set; }
    public ApprovalStatus SecondApprovalStatus { get; set; }
}
```

### Các Entity khác

| Entity | Mô tả |
|--------|-------|
| `OvertimeRequest` | Đơn xin tăng ca |
| `LeaveBalance` | Số ngày phép còn lại theo năm |
| `LeavePolicy` | Chính sách nghỉ phép công ty |
| `Shift` | Định nghĩa ca làm việc |
| `EmployeeShift` | Phân ca cho nhân viên |
| `Holiday` | Ngày nghỉ lễ |
| `ApprovalHistory` | Lịch sử duyệt đơn |
| `OutboxMessage` | Message queue cho Outbox pattern |

---

## Database Schema

### ERD Diagram

```
┌──────────────┐     ┌─────────────────┐     ┌──────────────────┐
│    Shifts    │────>│  EmployeeShifts │<────│    Employees     │
└──────────────┘     └─────────────────┘     │   (External)     │
       │                                      └──────────────────┘
       │                                              │
       ▼                                              │
┌──────────────┐                                      │
│  Attendances │<─────────────────────────────────────┤
└──────────────┘                                      │
                                                      │
┌────────────────┐    ┌──────────────────────┐        │
│ LeaveBalances  │<───│    LeaveRequests     │<───────┤
└────────────────┘    └──────────────────────┘        │
                              │                       │
                              ▼                       │
                      ┌──────────────────┐            │
                      │ ApprovalHistory  │            │
                      └──────────────────┘            │
                                                      │
┌──────────────────┐                                  │
│ OvertimeRequests │<─────────────────────────────────┘
└──────────────────┘

┌──────────────────┐
│  OutboxMessages  │  (Event sourcing)
└──────────────────┘
```

### Bảng chính

| Bảng | Columns chính | Indexes |
|------|---------------|---------|
| `attendances` | id, employee_id, date, check_in_time, check_out_time, shift_id | COMPOSITE(employee_id, date) |
| `leave_requests` | id, employee_id, leave_type, start_date, end_date, status | INDEX(employee_id), INDEX(status) |
| `leave_balances` | id, employee_id, year, annual_used, sick_used... | UNIQUE(employee_id, year) |
| `overtime_requests` | id, employee_id, date, start_time, end_time, status | INDEX(employee_id) |
| `shifts` | id, name, code, start_time, end_time, is_active | |
| `employee_shifts` | id, employee_id, shift_id, effective_date | INDEX(employee_id) |
| `outbox_messages` | id, event_type, payload, created_at, processed_at | INDEX(processed_at) |

### Connection String

```
Host=postgres-time;Port=5432;Database=time_db;Username=time_user;Password=time_pass
```

---

## Event-Driven Architecture

### Outbox Pattern

Service sử dụng **Outbox Pattern** để đảm bảo reliable event publishing:

```
┌─────────────┐    ┌───────────────┐    ┌──────────────┐    ┌────────────┐
│  Command    │───>│  Save Entity  │───>│ Save Outbox  │───>│  Commit    │
│  Handler    │    │  + Outbox Msg │    │   Message    │    │Transaction │
└─────────────┘    └───────────────┘    └──────────────┘    └────────────┘
                                                                  │
                   ┌───────────────┐    ┌──────────────┐          │
                   │   RabbitMQ    │<───│   Outbox     │<─────────┘
                   │   (Publish)   │    │  Processor   │   (Background Job)
                   └───────────────┘    └──────────────┘
```

### Events Published

| Event | Trigger | Payload |
|-------|---------|---------|
| `attendance_checked_in` | Check-in thành công | employeeId, checkInTime, status |
| `attendance_checked_out` | Check-out thành công | employeeId, checkOutTime, totalHours |
| `leave_request_created` | Tạo đơn nghỉ phép | requestId, employeeId, leaveType, dates |
| `leave_request_approved` | Duyệt đơn nghỉ | requestId, approvedBy, level |
| `leave_request_rejected` | Từ chối đơn nghỉ | requestId, rejectedBy, reason |
| `overtime_request_created` | Tạo đơn tăng ca | requestId, employeeId, date, hours |
| `overtime_request_approved` | Duyệt tăng ca | requestId, approvedBy |

### Message Format

```json
{
  "event": "leave_request_approved",
  "payload": {
    "requestId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "employeeId": "EMP001",
    "leaveType": "Annual",
    "startDate": "2025-01-20",
    "endDate": "2025-01-22",
    "approvedBy": "manager-user-id",
    "approvedAt": "2025-01-17T10:00:00Z"
  },
  "userIds": ["employee-keycloak-id"],
  "employeeIds": ["EMP001"]
}
```

### RabbitMQ Exchange

```
Exchange: hrm.events (Topic)
Routing Key: leave_request_approved, leave_request_rejected, etc.
Consumer: Notification Service → notification.queue
```

---

## Luồng xử lý

### Check-in Flow

```
┌──────────┐     ┌───────────────┐     ┌─────────────────┐
│ Frontend │────>│  API Gateway  │────>│   Time Service  │
│(GPS data)│     │    (REST)     │     │     (gRPC)      │
└──────────┘     └───────────────┘     └─────────────────┘
                                              │
                        ┌─────────────────────┼─────────────────────┐
                        │                     │                     │
                        ▼                     ▼                     ▼
               ┌─────────────┐      ┌─────────────────┐    ┌────────────┐
               │  Get Shift  │      │Create Attendance│    │Save Outbox │
               │  (Redis?)   │      │  + Calculate    │    │  Message   │
               └─────────────┘      │  Late Minutes   │    └────────────┘
                                    └─────────────────┘            │
                                                                   ▼
                                                          ┌────────────────┐
                                                          │ Outbox Process │
                                                          │  → RabbitMQ    │
                                                          └────────────────┘
                                                                   │
                                                                   ▼
                                                          ┌────────────────┐
                                                          │ Socket Service │
                                                          │  → Notify UI   │
                                                          └────────────────┘
```

### Leave Approval Flow (2-Level)

```
┌────────────┐          ┌──────────────────────────────────────────────────────┐
│  Employee  │          │                    Time Service                       │
└────────────┘          └──────────────────────────────────────────────────────┘
      │                         │
      │  Create Request         │
      │────────────────────────>│
      │                         │ ─┬─ Save LeaveRequest (status: Pending)
      │                         │  └─ Publish: leave_request_created
      │                         │
      │                         │  (Manager receives notification)
      │                         │
┌─────────────┐                 │
│  Manager    │                 │
└─────────────┘                 │
      │                         │
      │  Approve (Level 1)      │
      │────────────────────────>│
      │                         │ ─┬─ Update FirstApprovalStatus = Approved
      │                         │  └─ Set Status = PartiallyApproved
      │                         │
      │                         │  (HR receives notification)
      │                         │
┌─────────────┐                 │
│  HR Staff   │                 │
└─────────────┘                 │
      │                         │
      │  Approve (Level 2)      │
      │────────────────────────>│
      │                         │ ─┬─ Update SecondApprovalStatus = Approved
      │                         │  ├─ Set Status = Approved
      │                         │  └─ Publish: leave_request_approved
      │                         │
                                │  (Employee receives final notification)
```

### Integration Flow

```
┌──────────────┐         ┌───────────────────┐
│   Frontend   │◄───────>│    API Gateway    │
│  (Next.js)   │  REST   │  (REST/GraphQL)   │
└──────────────┘         └───────────────────┘
       ▲                          │
       │ WebSocket               gRPC
       │                          │
       │                          ▼
┌──────────────┐         ┌─────────────────┐         ┌─────────────────┐
│Socket Service│◄────────│  Time Service   │────────>│Employee Service │
│  (Notify)    │ RabbitMQ│  (PostgreSQL)   │  gRPC   │  (Validate Mgr) │
└──────────────┘         └─────────────────┘         └─────────────────┘
                                │
                    ┌───────────┼───────────┐
                    │           │           │
                    ▼           ▼           ▼
               ┌────────┐  ┌────────┐  ┌──────────┐
               │ Redis  │  │Postgres│  │ Keycloak │
               │(Cache) │  │(time_db)│ │  (JWT)   │
               └────────┘  └────────┘  └──────────┘
```

---

## Cấu hình

### Environment Variables

| Variable | Mô tả | Giá trị mặc định |
|----------|-------|------------------|
| `ASPNETCORE_ENVIRONMENT` | Môi trường | Development |
| `ASPNETCORE_URLS` | URLs lắng nghe | http://+:8080;http://+:8081 |
| `ConnectionStrings__DefaultConnection` | PostgreSQL connection | - |
| `ConnectionStrings__Redis` | Redis connection | redis:6379 |
| `RabbitMQ__Host` | RabbitMQ host | rabbitmq |
| `RabbitMQ__Port` | RabbitMQ port | 5672 |
| `RabbitMQ__Username` | RabbitMQ user | hrm_user |
| `RabbitMQ__Password` | RabbitMQ password | hrm_pass |
| `RabbitMQ__Exchange` | RabbitMQ exchange | hrm.events |
| `GrpcServices__EmployeeService` | Employee Service URL | http://employee-service:8081 |
| `Keycloak__Authority` | Keycloak realm URL | http://keycloak:8080/realms/hrm |
| `Keycloak__Audience` | API audience | hrm-api |

### appsettings.json

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5433;Database=time_db;Username=time_user;Password=time_pass",
    "Redis": "localhost:6379"
  },
  "RabbitMQ": {
    "Host": "localhost",
    "Port": 5672,
    "Username": "hrm_user",
    "Password": "hrm_pass",
    "Exchange": "hrm.events"
  },
  "GrpcServices": {
    "EmployeeService": "http://localhost:5002"
  },
  "Keycloak": {
    "Authority": "http://localhost:8080/realms/hrm",
    "Audience": "hrm-api",
    "ClientId": "hrm-api",
    "ClientSecret": "hrm-api-secret",
    "RequireHttps": false
  }
}
```

### Keycloak Roles

| Role | Permissions |
|------|-------------|
| `employee` | Check-in/out, tạo đơn nghỉ phép/tăng ca |
| `manager` | Duyệt đơn team (Level 1) |
| `hr_staff` | Duyệt đơn final (Level 2), xem tất cả đơn |
| `system_admin` | Full access |

---

## Chạy ứng dụng

### Với Docker Compose (Khuyến nghị)

```bash
# Từ thư mục hrm-deployment
cd hrm-deployment

# Chạy toàn bộ hệ thống
docker compose up -d

# Hoặc chỉ chạy Time Service + dependencies
docker compose up -d postgres-time redis rabbitmq employee-service keycloak time-service
```

### Local Development

```bash
# 1. Start dependencies
cd hrm-deployment
docker compose up -d postgres-time redis rabbitmq employee-service keycloak

# 2. Run migrations (nếu có)
cd ../hrm-Time-Service
dotnet ef database update --project src/Infrastructure --startup-project src/API

# 3. Run service
dotnet run --project src/API
```

### Docker Build

```bash
# Build image
docker build -t hrm-time-service .

# Run container
docker run -p 5003:8080 -p 5004:8081 \
  -e ConnectionStrings__DefaultConnection="Host=host.docker.internal;Port=5433;Database=time_db;Username=time_user;Password=time_pass" \
  -e ConnectionStrings__Redis="host.docker.internal:6379" \
  -e RabbitMQ__Host="host.docker.internal" \
  hrm-time-service
```

### Ports

| Port | Protocol | Mô tả |
|------|----------|-------|
| 8080 (external: 5003) | HTTP | Health check, Hangfire dashboard |
| 8081 (external: 5004) | gRPC | gRPC endpoints |

### Health Check

```bash
# HTTP health check
curl http://localhost:5003/health

# gRPC health check
grpcurl -plaintext localhost:5004 grpc.health.v1.Health/Check
```

### Hangfire Dashboard

```
http://localhost:5003/hangfire
```

Background jobs:
- **OutboxProcessor**: Xử lý outbox messages → RabbitMQ
- **DailyAttendanceSummary**: Tổng hợp chấm công hàng ngày

---

## Troubleshooting

### Lỗi kết nối Database

```bash
# Kiểm tra container PostgreSQL
docker logs hrm-postgres-time

# Kiểm tra kết nối
docker exec -it hrm-postgres-time psql -U time_user -d time_db -c "\dt"
```

### Lỗi RabbitMQ

```bash
# Kiểm tra RabbitMQ
docker logs hrm-rabbitmq

# Kiểm tra queue
curl -u hrm_user:hrm_pass http://localhost:15672/api/queues
```

### Lỗi Redis

```bash
# Kiểm tra Redis
docker exec -it hrm-redis redis-cli ping
```

### Lỗi Employee Service connection

```bash
# Test gRPC connection
grpcurl -plaintext localhost:5002 employee.EmployeeGrpc/GetEmployee
```

---

© 2025 HRM System - Clean Architecture
