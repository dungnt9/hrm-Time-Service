namespace TimeService.Domain.Entities;

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
