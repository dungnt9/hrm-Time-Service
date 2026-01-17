namespace TimeService.Domain.Entities;

public enum LeaveRequestStatus
{
    Pending,
    PartiallyApproved,
    Approved,
    Rejected,
    Cancelled
}
