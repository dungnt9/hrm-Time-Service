namespace TimeService.Domain.Entities;

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
