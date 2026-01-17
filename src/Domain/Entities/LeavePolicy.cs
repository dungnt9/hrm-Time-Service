namespace TimeService.Domain.Entities;

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
