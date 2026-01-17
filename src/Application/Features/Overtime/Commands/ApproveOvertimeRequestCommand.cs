using MediatR;

namespace TimeService.Application.Features.Overtime.Commands;

public class ApproveOvertimeRequestCommand : IRequest<ApproveOvertimeResult>
{
    public Guid RequestId { get; set; }
    public Guid ApproverId { get; set; }
    public string? Comment { get; set; }
}

public class ApproveOvertimeResult
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
}
