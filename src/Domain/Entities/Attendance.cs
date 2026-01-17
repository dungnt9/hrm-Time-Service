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
