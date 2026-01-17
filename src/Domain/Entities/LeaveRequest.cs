namespace TimeService.Domain.Entities;

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
