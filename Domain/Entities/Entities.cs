namespace TimeService.Domain.Entities;

public class Attendance
{
    public Guid Id { get; set; }
    public Guid EmployeeId { get; set; }
    public DateTime Date { get; set; }
    public DateTime? CheckInTime { get; set; }
    public DateTime? CheckOutTime { get; set; }
    public double? TotalHours { get; set; }
    public AttendanceStatus CheckInStatus { get; set; } = AttendanceStatus.OnTime;
    public AttendanceStatus CheckOutStatus { get; set; } = AttendanceStatus.OnTime;
    public int LateMinutes { get; set; }
    public int EarlyLeaveMinutes { get; set; }
    public int OvertimeMinutes { get; set; }
    public string? Note { get; set; }
    public double? CheckInLatitude { get; set; }
    public double? CheckInLongitude { get; set; }
    public string? CheckInAddress { get; set; }
    public double? CheckOutLatitude { get; set; }
    public double? CheckOutLongitude { get; set; }
    public string? CheckOutAddress { get; set; }
    public string? CheckInDeviceInfo { get; set; }
    public string? CheckOutDeviceInfo { get; set; }
    public string? CheckInIpAddress { get; set; }
    public string? CheckOutIpAddress { get; set; }
    public Guid? ShiftId { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }

    public Shift? Shift { get; set; }
}

public class LeaveRequest
{
    public Guid Id { get; set; }
    public Guid EmployeeId { get; set; }
    public LeaveType LeaveType { get; set; }
    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }
    public int TotalDays { get; set; }
    public string? Reason { get; set; }
    public LeaveRequestStatus Status { get; set; } = LeaveRequestStatus.Pending;
    
    // Two-level approval
    public Guid? FirstApproverId { get; set; }
    public ApproverType FirstApproverType { get; set; } = ApproverType.Manager;
    public DateTime? FirstApprovedAt { get; set; }
    public string? FirstApproverComment { get; set; }
    public ApprovalStatus FirstApprovalStatus { get; set; } = ApprovalStatus.Pending;
    
    public Guid? SecondApproverId { get; set; }
    public ApproverType SecondApproverType { get; set; } = ApproverType.HR;
    public DateTime? SecondApprovedAt { get; set; }
    public string? SecondApproverComment { get; set; }
    public ApprovalStatus SecondApprovalStatus { get; set; } = ApprovalStatus.Pending;
    
    public string? RejectionReason { get; set; }
    public string? Attachments { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}

public class LeaveBalance
{
    public Guid Id { get; set; }
    public Guid EmployeeId { get; set; }
    public int Year { get; set; }
    public int AnnualTotal { get; set; } = 12;
    public int AnnualUsed { get; set; }
    public int AnnualCarryOver { get; set; }
    public int SickTotal { get; set; } = 10;
    public int SickUsed { get; set; }
    public int UnpaidUsed { get; set; }
    public int MaternityTotal { get; set; } = 180;
    public int MaternityUsed { get; set; }
    public int PaternityTotal { get; set; } = 5;
    public int PaternityUsed { get; set; }
    public int WeddingTotal { get; set; } = 3;
    public int WeddingUsed { get; set; }
    public int BereavementTotal { get; set; } = 3;
    public int BereavementUsed { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}

public class Shift
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Code { get; set; } = string.Empty;
    public TimeSpan StartTime { get; set; }
    public TimeSpan EndTime { get; set; }
    public int BreakMinutes { get; set; }
    public int LateGraceMinutes { get; set; } = 15;
    public int EarlyLeaveGraceMinutes { get; set; } = 15;
    public bool IsDefault { get; set; }
    public bool IsNightShift { get; set; }
    public Guid? DepartmentId { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }

    public ICollection<EmployeeShift> EmployeeShifts { get; set; } = new List<EmployeeShift>();
}

public class EmployeeShift
{
    public Guid Id { get; set; }
    public Guid EmployeeId { get; set; }
    public Guid ShiftId { get; set; }
    public DateTime EffectiveDate { get; set; }
    public DateTime? EndDate { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTime CreatedAt { get; set; }

    public Shift Shift { get; set; } = null!;
}

public class Holiday
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public DateTime Date { get; set; }
    public int Year { get; set; }
    public bool IsRecurring { get; set; }
    public string? Description { get; set; }
    public DateTime CreatedAt { get; set; }
}

public class OvertimeRequest
{
    public Guid Id { get; set; }
    public Guid EmployeeId { get; set; }
    public DateTime Date { get; set; }
    public TimeSpan StartTime { get; set; }
    public TimeSpan EndTime { get; set; }
    public int TotalMinutes { get; set; }
    public string? Reason { get; set; }
    public OvertimeStatus Status { get; set; } = OvertimeStatus.Pending;
    public Guid? ApproverId { get; set; }
    public DateTime? ApprovedAt { get; set; }
    public string? ApproverComment { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}

public class OutboxMessage
{
    public Guid Id { get; set; }
    public string EventType { get; set; } = string.Empty;
    public string Payload { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
    public DateTime? ProcessedAt { get; set; }
    public int RetryCount { get; set; }
    public string? Error { get; set; }
}

public enum AttendanceStatus
{
    OnTime,
    Late,
    EarlyLeave,
    Overtime,
    Absent,
    Holiday,
    OnLeave
}

public enum LeaveType
{
    Annual,
    Sick,
    Unpaid,
    Maternity,
    Paternity,
    Wedding,
    Bereavement,
    Other
}

public enum LeaveRequestStatus
{
    Pending,
    PartiallyApproved,
    Approved,
    Rejected,
    Cancelled
}

public enum ApproverType
{
    Manager,
    HR,
    Director
}

public enum ApprovalStatus
{
    Pending,
    Approved,
    Rejected,
    Skipped
}

public enum OvertimeStatus
{
    Pending,
    Approved,
    Rejected
}

public class LeavePolicy
{
    public Guid Id { get; set; }
    public Guid? CompanyId { get; set; }
    public string Name { get; set; } = string.Empty;
    public LeaveType LeaveType { get; set; }
    public int DefaultDays { get; set; }
    public int MaxAccrualDays { get; set; }
    public int MaxCarryOverDays { get; set; }
    public bool RequiresApproval { get; set; } = true;
    public int MinDaysNotice { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}

public class ApprovalHistory
{
    public Guid Id { get; set; }
    public Guid LeaveRequestId { get; set; }
    public Guid ApproverId { get; set; }
    public ApproverType Level { get; set; }
    public string Action { get; set; } = string.Empty;
    public string? Comment { get; set; }
    public DateTime ActionAt { get; set; }

    public LeaveRequest LeaveRequest { get; set; } = null!;
}
