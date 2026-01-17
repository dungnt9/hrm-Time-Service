using MediatR;

namespace TimeService.Application.Features.Overtime.Queries;

public class GetOvertimeRequestsQuery : IRequest<IEnumerable<OvertimeRequestDto>>
{
    public Guid EmployeeId { get; set; }
    public DateTime? StartDate { get; set; }
    public DateTime? EndDate { get; set; }
}

public class OvertimeRequestDto
{
    public Guid Id { get; set; }
    public Guid EmployeeId { get; set; }
    public DateTime Date { get; set; }
    public TimeSpan StartTime { get; set; }
    public TimeSpan EndTime { get; set; }
    public int TotalMinutes { get; set; }
    public string? Reason { get; set; }
    public string Status { get; set; } = string.Empty;
    public Guid? ApproverId { get; set; }
    public DateTime? ApprovedAt { get; set; }
    public string? ApproverComment { get; set; }
    public DateTime CreatedAt { get; set; }
}
