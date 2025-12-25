# Time Service

This service manages attendance, leave requests, leave balances, shifts, overtime requests, and approval workflows for the HRM system.

## Features

### Attendance Management
- **Check-in/Check-out** tracking with GPS location
- **Attendance status** queries (present, late, early leave)
- **Attendance history** with summaries (date range, pagination)
- **Team attendance** aggregation
- **Shift assignment** per employee

### Leave Management
- **Leave requests** with 2-level approval workflow (Manager → HR)
- **Leave types** - Annual, Sick, Unpaid, Maternity, Paternity, Wedding, Bereavement, Other
- **Leave balance** tracking per year and employee
- **Leave policies** - Company-configurable (days, carryover, etc.)
- **Approval history** tracking

### Overtime Management
- **Overtime requests** creation and approval workflow
- **Overtime tracking** with time validation
- **Approval chain** (Manager/HR)

### Technical Features
- **Redis caching** for performance optimization
- **RabbitMQ event bus** for async event publishing (outbox pattern)
- **Hangfire job scheduling** for background jobs
- **gRPC API** for internal service-to-service communication
- **Structured logging** with Serilog
- **Health checks** for readiness/liveness probes

## Tech Stack

- .NET 8, ASP.NET Core Web API
- Entity Framework Core (ORM)
- PostgreSQL (relational database)
- Redis (caching layer)
- RabbitMQ (event/message bus)
- gRPC (internal communication)
- Hangfire (background job processing)
- Serilog (structured logging)
- Docker

## gRPC API Endpoints

### Attendance Service
- `CheckIn(CheckInRequest)` → `CheckInResponse` - Record check-in
- `CheckOut(CheckOutRequest)` → `CheckOutResponse` - Record check-out
- `GetAttendanceStatus(GetAttendanceStatusRequest)` → `AttendanceStatusResponse` - Current status
- `GetAttendanceHistory(GetAttendanceHistoryRequest)` → `AttendanceHistoryResponse` - History with pagination

### Leave Service
- `CreateLeaveRequest(CreateLeaveRequestRequest)` → `LeaveRequestResponse` - Create new leave
- `GetLeaveRequests(GetLeaveRequestsRequest)` → `LeaveRequestsResponse` - List leaves
- `GetLeaveRequestDetail(GetLeaveRequestDetailRequest)` → `LeaveRequestResponse` - Get details
- `ApproveLeaveRequest(ApproveLeaveRequestRequest)` → `LeaveRequestResponse` - Approve (Manager/HR)
- `RejectLeaveRequest(RejectLeaveRequestRequest)` → `LeaveRequestResponse` - Reject (Manager/HR)
- `GetLeaveBalance(GetLeaveBalanceRequest)` → `LeaveBalanceResponse` - Balance details

### Overtime Service
- `CreateOvertimeRequest(CreateOvertimeRequestRequest)` → `OvertimeRequestResponse` - Create overtime
- `GetOvertimeRequests(GetOvertimeRequestsRequest)` → `OvertimeRequestsResponse` - List overtime
- `GetOvertimeRequestDetail(GetOvertimeRequestDetailRequest)` → `OvertimeRequestResponse` - Get details
- `ApproveOvertimeRequest(ApproveOvertimeRequestRequest)` → `OvertimeRequestResponse` - Approve
- `RejectOvertimeRequest(RejectOvertimeRequestRequest)` → `OvertimeRequestResponse` - Reject

### Shift Service
- `GetShifts(GetShiftsRequest)` → `ShiftsResponse` - List shifts
- `GetEmployeeShift(GetEmployeeShiftRequest)` → `ShiftResponse` - Get employee's shift

## Database Schema

### Core Tables
- **Attendance** - Daily check-in/out records
  - Columns: Id, EmployeeId, Date, CheckInTime, CheckOutTime, TotalHours, Status, LateMinutes, EarlyLeaveMinutes, OvertimeMinutes, ShiftId, Location

- **LeaveRequest** - Leave applications with approval
  - Columns: Id, EmployeeId, LeaveType, StartDate, EndDate, TotalDays, Reason, Status, FirstApproverId, SecondApproverId, RejectionReason

- **LeaveBalance** - Annual/sick leave balances per employee
  - Columns: Id, EmployeeId, Year, AnnualTotal, AnnualUsed, SickTotal, SickUsed, MaternityUsed, PaternityUsed, etc.

- **Shift** - Work shift definitions
  - Columns: Id, Name, Code, StartTime, EndTime, BreakMinutes, DepartmentId, IsDefault, IsNightShift

- **EmployeeShift** - Shift assignment per employee
  - Columns: Id, EmployeeId, ShiftId, EffectiveDate, EndDate, IsActive

- **OvertimeRequest** - Overtime requests
  - Columns: Id, EmployeeId, Date, StartTime, EndTime, TotalMinutes, Reason, Status, ApproverId, ApprovedAt

- **LeavePolicy** - Configurable leave policies
  - Columns: Id, CompanyId, LeaveType, DefaultDays, MaxAccrual, MaxCarryOver, RequiresApproval

- **ApprovalHistory** - Audit trail for approvals
  - Columns: Id, LeaveRequestId, ApproverId, Level, Action, Comment, ActionAt

- **OutboxMessage** - Event outbox for reliable publishing
  - Columns: Id, EventType, Payload, CreatedAt, ProcessedAt, RetryCount

### Supporting Enums
- **LeaveType** - Annual, Sick, Unpaid, Maternity, Paternity, Wedding, Bereavement, Other
- **LeaveRequestStatus** - Pending, PartiallyApproved, Approved, Rejected, Cancelled
- **ApproverType** - Manager, HR, Director
- **ApprovalStatus** - Pending, Approved, Rejected, Skipped
- **AttendanceStatus** - OnTime, Late, EarlyLeave, Overtime, Absent, Holiday, OnLeave

## Database Connection

- **Host**: postgres-time (Docker) / localhost (local)
- **Port**: 5432
- **Database**: time_db
- **Username**: time_user
- **Password**: time_pass
- **Seed data**: `Data/seed-data.sql` (auto-applied on first run)

## Environment Variables

- `ConnectionStrings__DefaultConnection` - PostgreSQL connection string
- `ConnectionStrings__Redis` - Redis connection string (default: redis:6379)
- `RabbitMQ__Host` - RabbitMQ host (default: rabbitmq)
- `RabbitMQ__Username` - RabbitMQ username (default: hrm_user)
- `RabbitMQ__Password` - RabbitMQ password (default: hrm_pass)
- `Keycloak__Authority` - Keycloak endpoint (default: http://keycloak:8080/realms/hrm)
- `Keycloak__Audience` - Keycloak audience (default: hrm-api)
- `ASPNETCORE_ENVIRONMENT` - Development/Production

## Running Locally

```sh
# Start dependencies only
docker-compose up -d postgres-time redis rabbitmq

# Or start everything
docker-compose up -d

# Run migrations
dotnet ef database update --project TimeService

# Run the service
ASPNETCORE_ENVIRONMENT=Development dotnet run --project TimeService
```

## Docker

Service is built and run via Docker Compose. See root `docker-compose.yml`.

Port mapping:
- Container: 8080 (HTTP), 8081 (gRPC)
- Host: 5003 (HTTP), 5004 (gRPC)

## Health Check

- `GET /health` - Service readiness/liveness probe
- Returns 200 OK if database, Redis, and RabbitMQ are healthy

## Features in Detail

### 1. Attendance Tracking
- Check-in captures: time, location (GPS), device info, IP address
- Check-out calculates: total hours, late minutes, early leave, overtime
- Supports grace period configurations per shift
- Real-time status queries
- Historical records with date range filtering

### 2. Leave Workflow
- Employee creates request with reason and date range
- Manager approves/rejects (Level 1)
- HR makes final decision (Level 2)
- Support for partial approval (some days approved)
- Auto-deduction from leave balance
- Configurable minimum notice period per policy

### 3. Leave Balance
- Annual accrual per policy
- Sick leave separate from annual
- Maternity/Paternity/Wedding/Bereavement special leaves
- Carryover calculation (max days per policy)
- Per-company policies
- Year-based tracking

### 4. Overtime Management
- Request submission with time details
- Manager/HR approval workflow
- Status tracking: Pending, Approved, Rejected
- Aggregation with attendance system

### 5. Performance Optimization
- Redis caching for frequently accessed data (shifts, policies)
- Pagination on all list endpoints
- Async/await throughout
- Connection pooling

### 6. Event-Driven Architecture
- Outbox pattern for reliable event publishing
- Events published to RabbitMQ:
  - `attendance.checked_in`
  - `attendance.checked_out`
  - `leave.requested`
  - `leave.approved`
  - `leave.rejected`
  - `overtime.requested`
  - `overtime.approved`
- Consumed by Notification Service

## Approval Workflow

### Leave Request Approval (2-Level)

```
Employee submits leave request
    ↓
Manager reviews & approves/rejects (Level 1)
    ↓ (if approved)
HR reviews & approves/rejects (Level 2)
    ↓ (if approved)
Leave balance deducted
    ↓
Notification sent to employee
```

## Notes

- Requires PostgreSQL, Redis, RabbitMQ to be healthy
- Approval workflow is configurable per leave policy
- Leave policies are company-specific
- Attendance data immutable once recorded
- Shift changes effective next day minimum
- All timestamps in UTC
- Leave years can be customized per company

## Integration Points

- **Employee Service** - Employee data validation via gRPC
- **Notification Service** - Sends approval notifications via RabbitMQ
- **API Gateway** - Consumed by (converts gRPC to REST)

---

© 2025 HRM System
