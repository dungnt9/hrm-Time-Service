using Grpc.Core;
using Microsoft.EntityFrameworkCore;
using StackExchange.Redis;
using System.Text.Json;
using TimeService.Data;
using TimeService.Domain.Entities;
using TimeService.Infrastructure;
using TimeService.Protos;

namespace TimeService.GrpcServices;

public class TimeGrpcServiceImpl : TimeGrpc.TimeGrpcBase
{
    private readonly TimeDbContext _context;
    private readonly IConnectionMultiplexer _redis;
    private readonly IEventPublisher _eventPublisher;
    private readonly EmployeeGrpc.EmployeeGrpcClient _employeeClient;
    private readonly ILogger<TimeGrpcServiceImpl> _logger;

    public TimeGrpcServiceImpl(
        TimeDbContext context,
        IConnectionMultiplexer redis,
        IEventPublisher eventPublisher,
        EmployeeGrpc.EmployeeGrpcClient employeeClient,
        ILogger<TimeGrpcServiceImpl> logger)
    {
        _context = context;
        _redis = redis;
        _eventPublisher = eventPublisher;
        _employeeClient = employeeClient;
        _logger = logger;
    }

    public override async Task<CheckInResponse> CheckIn(CheckInRequest request, ServerCallContext context)
    {
        if (!Guid.TryParse(request.EmployeeId, out var employeeId))
        {
            return new CheckInResponse { Message = "Invalid employee ID" };
        }

        var today = DateTime.UtcNow.Date;
        var existingAttendance = await _context.Attendances
            .FirstOrDefaultAsync(a => a.EmployeeId == employeeId && a.Date == today);

        if (existingAttendance?.CheckInTime != null)
        {
            return new CheckInResponse
            {
                Id = existingAttendance.Id.ToString(),
                EmployeeId = employeeId.ToString(),
                CheckInTime = existingAttendance.CheckInTime.Value.ToString("O"),
                Status = existingAttendance.CheckInStatus.ToString().ToLower(),
                LateMinutes = existingAttendance.LateMinutes,
                Message = "Already checked in today"
            };
        }

        var now = DateTime.UtcNow;
        var shift = await GetEmployeeShiftInternal(employeeId, today);
        var shiftStart = today.Add(shift?.StartTime ?? new TimeSpan(9, 0, 0));

        var lateMinutes = 0;
        var status = AttendanceStatus.OnTime;
        if (now > shiftStart)
        {
            lateMinutes = (int)(now - shiftStart).TotalMinutes;
            status = AttendanceStatus.Late;
        }

        var attendance = existingAttendance ?? new Attendance
        {
            Id = Guid.NewGuid(),
            EmployeeId = employeeId,
            Date = today,
            CreatedAt = now
        };

        attendance.CheckInTime = now;
        attendance.CheckInStatus = status;
        attendance.LateMinutes = lateMinutes;
        attendance.CheckInLatitude = request.Latitude;
        attendance.CheckInLongitude = request.Longitude;
        attendance.Note = request.Note;
        attendance.UpdatedAt = now;

        if (existingAttendance == null)
        {
            _context.Attendances.Add(attendance);
        }

        await _context.SaveChangesAsync();

        // Cache attendance status
        var db = _redis.GetDatabase();
        await db.StringSetAsync($"attendance:{employeeId}:{today:yyyy-MM-dd}", 
            JsonSerializer.Serialize(new { IsCheckedIn = true, CheckInTime = now }), 
            TimeSpan.FromHours(24));

        return new CheckInResponse
        {
            Id = attendance.Id.ToString(),
            EmployeeId = employeeId.ToString(),
            CheckInTime = now.ToString("O"),
            Status = status.ToString().ToLower(),
            LateMinutes = lateMinutes,
            Message = lateMinutes > 0 ? $"Checked in {lateMinutes} minutes late" : "Checked in successfully"
        };
    }

    public override async Task<CheckOutResponse> CheckOut(CheckOutRequest request, ServerCallContext context)
    {
        if (!Guid.TryParse(request.EmployeeId, out var employeeId))
        {
            return new CheckOutResponse { Message = "Invalid employee ID" };
        }

        var today = DateTime.UtcNow.Date;
        var attendance = await _context.Attendances
            .FirstOrDefaultAsync(a => a.EmployeeId == employeeId && a.Date == today);

        if (attendance == null || attendance.CheckInTime == null)
        {
            return new CheckOutResponse { Message = "Not checked in today" };
        }

        if (attendance.CheckOutTime != null)
        {
            return new CheckOutResponse
            {
                Id = attendance.Id.ToString(),
                EmployeeId = employeeId.ToString(),
                CheckInTime = attendance.CheckInTime.Value.ToString("O"),
                CheckOutTime = attendance.CheckOutTime.Value.ToString("O"),
                TotalHours = attendance.TotalHours ?? 0,
                Status = attendance.CheckOutStatus.ToString().ToLower(),
                Message = "Already checked out today"
            };
        }

        var now = DateTime.UtcNow;
        var shift = await GetEmployeeShiftInternal(employeeId, today);
        var shiftEnd = today.Add(shift?.EndTime ?? new TimeSpan(18, 0, 0));

        var earlyLeaveMinutes = 0;
        var overtimeMinutes = 0;
        var status = AttendanceStatus.OnTime;

        if (now < shiftEnd)
        {
            earlyLeaveMinutes = (int)(shiftEnd - now).TotalMinutes;
            status = AttendanceStatus.EarlyLeave;
        }
        else if (now > shiftEnd)
        {
            overtimeMinutes = (int)(now - shiftEnd).TotalMinutes;
            status = AttendanceStatus.Overtime;
        }

        var totalHours = (now - attendance.CheckInTime.Value).TotalHours;
        var breakMinutes = shift?.BreakMinutes ?? 60;
        totalHours -= breakMinutes / 60.0;

        attendance.CheckOutTime = now;
        attendance.CheckOutStatus = status;
        attendance.TotalHours = Math.Max(0, totalHours);
        attendance.EarlyLeaveMinutes = earlyLeaveMinutes;
        attendance.OvertimeMinutes = overtimeMinutes;
        attendance.CheckOutLatitude = request.Latitude;
        attendance.CheckOutLongitude = request.Longitude;
        if (!string.IsNullOrEmpty(request.Note))
        {
            attendance.Note = string.IsNullOrEmpty(attendance.Note) ? request.Note : $"{attendance.Note}; {request.Note}";
        }
        attendance.UpdatedAt = now;

        await _context.SaveChangesAsync();

        // Update cache
        var db = _redis.GetDatabase();
        await db.StringSetAsync($"attendance:{employeeId}:{today:yyyy-MM-dd}",
            JsonSerializer.Serialize(new { IsCheckedIn = true, IsCheckedOut = true, CheckInTime = attendance.CheckInTime, CheckOutTime = now }),
            TimeSpan.FromHours(24));

        return new CheckOutResponse
        {
            Id = attendance.Id.ToString(),
            EmployeeId = employeeId.ToString(),
            CheckInTime = attendance.CheckInTime.Value.ToString("O"),
            CheckOutTime = now.ToString("O"),
            TotalHours = totalHours,
            Status = status.ToString().ToLower(),
            EarlyLeaveMinutes = earlyLeaveMinutes,
            OvertimeMinutes = overtimeMinutes,
            Message = earlyLeaveMinutes > 0 ? $"Left {earlyLeaveMinutes} minutes early" : 
                     overtimeMinutes > 0 ? $"Overtime: {overtimeMinutes} minutes" : "Checked out successfully"
        };
    }

    public override async Task<AttendanceHistoryResponse> GetAttendanceHistory(GetAttendanceHistoryRequest request, ServerCallContext context)
    {
        if (!Guid.TryParse(request.EmployeeId, out var employeeId))
        {
            return new AttendanceHistoryResponse();
        }

        var query = _context.Attendances
            .Where(a => a.EmployeeId == employeeId)
            .AsQueryable();

        if (!string.IsNullOrEmpty(request.StartDate) && DateTime.TryParse(request.StartDate, out var startDate))
        {
            query = query.Where(a => a.Date >= startDate.Date);
        }

        if (!string.IsNullOrEmpty(request.EndDate) && DateTime.TryParse(request.EndDate, out var endDate))
        {
            query = query.Where(a => a.Date <= endDate.Date);
        }

        var totalCount = await query.CountAsync();
        var page = request.Page > 0 ? request.Page : 1;
        var pageSize = request.PageSize > 0 ? request.PageSize : 10;

        var records = await query
            .OrderByDescending(a => a.Date)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        var allRecords = await query.ToListAsync();
        var summary = new AttendanceSummary
        {
            TotalDays = allRecords.Count,
            PresentDays = allRecords.Count(r => r.CheckInTime != null),
            AbsentDays = 0,
            LateCount = allRecords.Count(r => r.CheckInStatus == AttendanceStatus.Late),
            EarlyLeaveCount = allRecords.Count(r => r.CheckOutStatus == AttendanceStatus.EarlyLeave),
            TotalHours = allRecords.Sum(r => r.TotalHours ?? 0),
            AverageHoursPerDay = allRecords.Count > 0 ? allRecords.Average(r => r.TotalHours ?? 0) : 0
        };

        var response = new AttendanceHistoryResponse
        {
            TotalCount = totalCount,
            Page = page,
            PageSize = pageSize,
            Summary = summary
        };

        response.Records.AddRange(records.Select(r => new AttendanceRecord
        {
            Id = r.Id.ToString(),
            EmployeeId = r.EmployeeId.ToString(),
            Date = r.Date.ToString("yyyy-MM-dd"),
            CheckInTime = r.CheckInTime?.ToString("O") ?? "",
            CheckOutTime = r.CheckOutTime?.ToString("O") ?? "",
            TotalHours = r.TotalHours ?? 0,
            CheckInStatus = r.CheckInStatus.ToString().ToLower(),
            CheckOutStatus = r.CheckOutStatus.ToString().ToLower(),
            LateMinutes = r.LateMinutes,
            EarlyLeaveMinutes = r.EarlyLeaveMinutes,
            OvertimeMinutes = r.OvertimeMinutes,
            Note = r.Note ?? ""
        }));

        return response;
    }

    public override async Task<AttendanceStatusResponse> GetAttendanceStatus(GetAttendanceStatusRequest request, ServerCallContext context)
    {
        if (!Guid.TryParse(request.EmployeeId, out var employeeId))
        {
            return new AttendanceStatusResponse();
        }

        var date = string.IsNullOrEmpty(request.Date) ? DateTime.UtcNow.Date : DateTime.Parse(request.Date).Date;

        // Try cache first
        var db = _redis.GetDatabase();
        var cached = await db.StringGetAsync($"attendance:{employeeId}:{date:yyyy-MM-dd}");
        if (cached.HasValue)
        {
            var cachedData = JsonSerializer.Deserialize<Dictionary<string, object>>(cached.ToString());
            if (cachedData != null)
            {
                return new AttendanceStatusResponse
                {
                    IsCheckedIn = cachedData.ContainsKey("IsCheckedIn") && (bool)cachedData["IsCheckedIn"],
                    IsCheckedOut = cachedData.ContainsKey("IsCheckedOut") && (bool)cachedData["IsCheckedOut"],
                    CheckInTime = cachedData.ContainsKey("CheckInTime") ? cachedData["CheckInTime"]?.ToString() ?? "" : "",
                    CheckOutTime = cachedData.ContainsKey("CheckOutTime") ? cachedData["CheckOutTime"]?.ToString() ?? "" : ""
                };
            }
        }

        var attendance = await _context.Attendances
            .FirstOrDefaultAsync(a => a.EmployeeId == employeeId && a.Date == date);

        var response = new AttendanceStatusResponse
        {
            IsCheckedIn = attendance?.CheckInTime != null,
            IsCheckedOut = attendance?.CheckOutTime != null,
            CheckInTime = attendance?.CheckInTime?.ToString("O") ?? "",
            CheckOutTime = attendance?.CheckOutTime?.ToString("O") ?? ""
        };

        if (attendance?.CheckInTime != null && attendance.CheckOutTime == null)
        {
            response.CurrentHours = (DateTime.UtcNow - attendance.CheckInTime.Value).TotalHours;
        }
        else if (attendance?.TotalHours != null)
        {
            response.CurrentHours = attendance.TotalHours.Value;
        }

        return response;
    }

    public override async Task<LeaveRequestResponse> CreateLeaveRequest(CreateLeaveRequestRequest request, ServerCallContext context)
    {
        if (!Guid.TryParse(request.EmployeeId, out var employeeId) ||
            !Guid.TryParse(request.ApproverId, out var approverId))
        {
            return new LeaveRequestResponse();
        }

        if (!DateTime.TryParse(request.StartDate, out var startDate) ||
            !DateTime.TryParse(request.EndDate, out var endDate))
        {
            return new LeaveRequestResponse();
        }

        if (!Enum.TryParse<LeaveType>(request.LeaveType, true, out var leaveType))
        {
            leaveType = LeaveType.Annual;
        }

        if (!Enum.TryParse<ApproverType>(request.ApproverType, true, out var approverType))
        {
            approverType = ApproverType.Manager;
        }

        var totalDays = (int)(endDate.Date - startDate.Date).TotalDays + 1;

        var leaveRequest = new LeaveRequest
        {
            Id = Guid.NewGuid(),
            EmployeeId = employeeId,
            LeaveType = leaveType,
            StartDate = startDate.Date,
            EndDate = endDate.Date,
            TotalDays = totalDays,
            Reason = request.Reason,
            Status = LeaveRequestStatus.Pending,
            FirstApproverId = approverId,
            FirstApproverType = approverType,
            FirstApprovalStatus = ApprovalStatus.Pending,
            SecondApprovalStatus = ApprovalStatus.Pending,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        };

        _context.LeaveRequests.Add(leaveRequest);

        // Add outbox message for event
        var outboxMessage = new OutboxMessage
        {
            Id = Guid.NewGuid(),
            EventType = "leave_request_created",
            Payload = JsonSerializer.Serialize(new
            {
                LeaveRequestId = leaveRequest.Id,
                EmployeeId = employeeId,
                ApproverId = approverId,
                LeaveType = leaveType.ToString(),
                StartDate = startDate,
                EndDate = endDate,
                TotalDays = totalDays
            }),
            CreatedAt = DateTime.UtcNow
        };
        _context.OutboxMessages.Add(outboxMessage);

        await _context.SaveChangesAsync();

        // Get employee info for response
        var employeeName = "";
        var approverName = "";
        try
        {
            var employee = await _employeeClient.GetEmployeeAsync(new GetEmployeeRequest { EmployeeId = employeeId.ToString() });
            employeeName = $"{employee.FirstName} {employee.LastName}";
            var approver = await _employeeClient.GetEmployeeAsync(new GetEmployeeRequest { EmployeeId = approverId.ToString() });
            approverName = $"{approver.FirstName} {approver.LastName}";
        }
        catch { }

        return new LeaveRequestResponse
        {
            Id = leaveRequest.Id.ToString(),
            EmployeeId = employeeId.ToString(),
            EmployeeName = employeeName,
            LeaveType = leaveType.ToString().ToLower(),
            StartDate = startDate.ToString("yyyy-MM-dd"),
            EndDate = endDate.ToString("yyyy-MM-dd"),
            TotalDays = totalDays,
            Reason = request.Reason,
            Status = "pending",
            ApproverId = approverId.ToString(),
            ApproverName = approverName,
            ApproverType = approverType.ToString().ToLower(),
            CreatedAt = leaveRequest.CreatedAt.ToString("O"),
            UpdatedAt = leaveRequest.UpdatedAt.ToString("O")
        };
    }

    public override async Task<LeaveRequestsResponse> GetLeaveRequests(GetLeaveRequestsRequest request, ServerCallContext context)
    {
        var query = _context.LeaveRequests.AsQueryable();

        if (!string.IsNullOrEmpty(request.EmployeeId) && Guid.TryParse(request.EmployeeId, out var employeeId))
        {
            query = query.Where(r => r.EmployeeId == employeeId);
        }

        if (!string.IsNullOrEmpty(request.ApproverId) && Guid.TryParse(request.ApproverId, out var approverId))
        {
            query = query.Where(r => r.FirstApproverId == approverId || r.SecondApproverId == approverId);
        }

        if (!string.IsNullOrEmpty(request.Status) && Enum.TryParse<LeaveRequestStatus>(request.Status, true, out var status))
        {
            query = query.Where(r => r.Status == status);
        }

        if (!string.IsNullOrEmpty(request.LeaveType) && Enum.TryParse<LeaveType>(request.LeaveType, true, out var leaveType))
        {
            query = query.Where(r => r.LeaveType == leaveType);
        }

        var totalCount = await query.CountAsync();
        var page = request.Page > 0 ? request.Page : 1;
        var pageSize = request.PageSize > 0 ? request.PageSize : 10;

        var requests = await query
            .OrderByDescending(r => r.CreatedAt)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        var response = new LeaveRequestsResponse
        {
            TotalCount = totalCount,
            Page = page,
            PageSize = pageSize
        };

        foreach (var r in requests)
        {
            response.Requests.Add(await MapToResponse(r));
        }

        return response;
    }

    public override async Task<LeaveRequestResponse> GetLeaveRequestDetail(GetLeaveRequestDetailRequest request, ServerCallContext context)
    {
        if (!Guid.TryParse(request.LeaveRequestId, out var leaveRequestId))
        {
            return new LeaveRequestResponse();
        }

        var leaveRequest = await _context.LeaveRequests.FindAsync(leaveRequestId);
        if (leaveRequest == null)
        {
            return new LeaveRequestResponse();
        }

        return await MapToResponse(leaveRequest);
    }

    public override async Task<LeaveRequestResponse> ApproveLeaveRequest(ApproveLeaveRequestRequest request, ServerCallContext context)
    {
        if (!Guid.TryParse(request.LeaveRequestId, out var leaveRequestId) ||
            !Guid.TryParse(request.ApproverId, out var approverId))
        {
            return new LeaveRequestResponse();
        }

        var leaveRequest = await _context.LeaveRequests.FindAsync(leaveRequestId);
        if (leaveRequest == null)
        {
            return new LeaveRequestResponse();
        }

        // Two-level approval logic
        if (leaveRequest.FirstApprovalStatus == ApprovalStatus.Pending)
        {
            leaveRequest.FirstApprovalStatus = ApprovalStatus.Approved;
            leaveRequest.FirstApprovedAt = DateTime.UtcNow;
            leaveRequest.Status = LeaveRequestStatus.PartiallyApproved;
        }
        else if (leaveRequest.SecondApprovalStatus == ApprovalStatus.Pending)
        {
            leaveRequest.SecondApprovalStatus = ApprovalStatus.Approved;
            leaveRequest.SecondApprovedAt = DateTime.UtcNow;
            leaveRequest.Status = LeaveRequestStatus.Approved;
        }
        leaveRequest.UpdatedAt = DateTime.UtcNow;

        // Update leave balance
        var balance = await _context.LeaveBalances
            .FirstOrDefaultAsync(b => b.EmployeeId == leaveRequest.EmployeeId && b.Year == leaveRequest.StartDate.Year);

        if (balance != null)
        {
            switch (leaveRequest.LeaveType)
            {
                case LeaveType.Annual:
                    balance.AnnualUsed += leaveRequest.TotalDays;
                    break;
                case LeaveType.Sick:
                    balance.SickUsed += leaveRequest.TotalDays;
                    break;
                case LeaveType.Unpaid:
                    balance.UnpaidUsed += leaveRequest.TotalDays;
                    break;
            }
            balance.UpdatedAt = DateTime.UtcNow;
        }

        // Add outbox message
        var outboxMessage = new OutboxMessage
        {
            Id = Guid.NewGuid(),
            EventType = "leave_request_approved",
            Payload = JsonSerializer.Serialize(new
            {
                LeaveRequestId = leaveRequest.Id,
                EmployeeId = leaveRequest.EmployeeId,
                ApproverId = approverId,
                ApprovedAt = DateTime.UtcNow
            }),
            CreatedAt = DateTime.UtcNow
        };
        _context.OutboxMessages.Add(outboxMessage);

        await _context.SaveChangesAsync();

        return await MapToResponse(leaveRequest);
    }

    public override async Task<LeaveRequestResponse> RejectLeaveRequest(RejectLeaveRequestRequest request, ServerCallContext context)
    {
        if (!Guid.TryParse(request.LeaveRequestId, out var leaveRequestId) ||
            !Guid.TryParse(request.ApproverId, out var approverId))
        {
            return new LeaveRequestResponse();
        }

        var leaveRequest = await _context.LeaveRequests.FindAsync(leaveRequestId);
        if (leaveRequest == null)
        {
            return new LeaveRequestResponse();
        }

        leaveRequest.Status = LeaveRequestStatus.Rejected;
        leaveRequest.RejectionReason = request.Reason;
        leaveRequest.UpdatedAt = DateTime.UtcNow;

        // Add outbox message
        var outboxMessage = new OutboxMessage
        {
            Id = Guid.NewGuid(),
            EventType = "leave_request_rejected",
            Payload = JsonSerializer.Serialize(new
            {
                LeaveRequestId = leaveRequest.Id,
                EmployeeId = leaveRequest.EmployeeId,
                ApproverId = approverId,
                Reason = request.Reason
            }),
            CreatedAt = DateTime.UtcNow
        };
        _context.OutboxMessages.Add(outboxMessage);

        await _context.SaveChangesAsync();

        return await MapToResponse(leaveRequest);
    }

    public override async Task<LeaveBalanceResponse> GetLeaveBalance(GetLeaveBalanceRequest request, ServerCallContext context)
    {
        if (!Guid.TryParse(request.EmployeeId, out var employeeId))
        {
            return new LeaveBalanceResponse();
        }

        var year = request.Year > 0 ? request.Year : DateTime.UtcNow.Year;

        var balance = await _context.LeaveBalances
            .FirstOrDefaultAsync(b => b.EmployeeId == employeeId && b.Year == year);

        if (balance == null)
        {
            // Create default balance
            balance = new LeaveBalance
            {
                Id = Guid.NewGuid(),
                EmployeeId = employeeId,
                Year = year,
                AnnualTotal = 12,
                SickTotal = 10,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };
            _context.LeaveBalances.Add(balance);
            await _context.SaveChangesAsync();
        }

        return new LeaveBalanceResponse
        {
            EmployeeId = employeeId.ToString(),
            Year = year,
            AnnualTotal = balance.AnnualTotal,
            AnnualUsed = balance.AnnualUsed,
            AnnualRemaining = balance.AnnualTotal - balance.AnnualUsed,
            SickTotal = balance.SickTotal,
            SickUsed = balance.SickUsed,
            SickRemaining = balance.SickTotal - balance.SickUsed,
            UnpaidUsed = balance.UnpaidUsed
        };
    }

    public override async Task<ShiftsResponse> GetShifts(GetShiftsRequest request, ServerCallContext context)
    {
        var query = _context.Shifts.AsQueryable();

        if (!string.IsNullOrEmpty(request.DepartmentId) && Guid.TryParse(request.DepartmentId, out var deptId))
        {
            query = query.Where(s => s.DepartmentId == deptId || s.DepartmentId == null);
        }

        var shifts = await query.ToListAsync();

        var response = new ShiftsResponse();
        response.Shifts.AddRange(shifts.Select(s => new Protos.Shift
        {
            Id = s.Id.ToString(),
            Name = s.Name,
            StartTime = s.StartTime.ToString(@"hh\:mm"),
            EndTime = s.EndTime.ToString(@"hh\:mm"),
            BreakMinutes = s.BreakMinutes,
            IsDefault = s.IsDefault
        }));

        return response;
    }

    public override async Task<ShiftResponse> GetEmployeeShift(GetEmployeeShiftRequest request, ServerCallContext context)
    {
        if (!Guid.TryParse(request.EmployeeId, out var employeeId))
        {
            return new ShiftResponse();
        }

        var date = string.IsNullOrEmpty(request.Date) ? DateTime.UtcNow.Date : DateTime.Parse(request.Date).Date;

        var shift = await GetEmployeeShiftInternal(employeeId, date);

        if (shift == null)
        {
            return new ShiftResponse();
        }

        return new ShiftResponse
        {
            Shift = new Protos.Shift
            {
                Id = shift.Id.ToString(),
                Name = shift.Name,
                StartTime = shift.StartTime.ToString(@"hh\:mm"),
                EndTime = shift.EndTime.ToString(@"hh\:mm"),
                BreakMinutes = shift.BreakMinutes,
                IsDefault = shift.IsDefault
            }
        };
    }

    private async Task<Domain.Entities.Shift?> GetEmployeeShiftInternal(Guid employeeId, DateTime date)
    {
        var employeeShift = await _context.EmployeeShifts
            .Include(es => es.Shift)
            .FirstOrDefaultAsync(es => es.EmployeeId == employeeId && 
                                       es.EffectiveDate <= date && 
                                       (es.EndDate == null || es.EndDate >= date));

        if (employeeShift != null)
        {
            return employeeShift.Shift;
        }

        return await _context.Shifts.FirstOrDefaultAsync(s => s.IsDefault);
    }

    private async Task<LeaveRequestResponse> MapToResponse(LeaveRequest r)
    {
        var employeeName = "";
        var approverName = "";
        try
        {
            var employee = await _employeeClient.GetEmployeeAsync(new GetEmployeeRequest { EmployeeId = r.EmployeeId.ToString() });
            employeeName = $"{employee.FirstName} {employee.LastName}";
            if (r.FirstApproverId.HasValue)
            {
                var approver = await _employeeClient.GetEmployeeAsync(new GetEmployeeRequest { EmployeeId = r.FirstApproverId.Value.ToString() });
                approverName = $"{approver.FirstName} {approver.LastName}";
            }
        }
        catch { }

        return new LeaveRequestResponse
        {
            Id = r.Id.ToString(),
            EmployeeId = r.EmployeeId.ToString(),
            EmployeeName = employeeName,
            LeaveType = r.LeaveType.ToString().ToLower(),
            StartDate = r.StartDate.ToString("yyyy-MM-dd"),
            EndDate = r.EndDate.ToString("yyyy-MM-dd"),
            TotalDays = r.TotalDays,
            Reason = r.Reason ?? "",
            Status = r.Status.ToString().ToLower(),
            ApproverId = r.FirstApproverId?.ToString() ?? "",
            ApproverName = approverName,
            ApproverType = r.FirstApproverType.ToString().ToLower(),
            ApprovedAt = r.FirstApprovedAt?.ToString("O") ?? "",
            RejectionReason = r.RejectionReason ?? "",
            CreatedAt = r.CreatedAt.ToString("O"),
            UpdatedAt = r.UpdatedAt.ToString("O")
        };
    }
}
