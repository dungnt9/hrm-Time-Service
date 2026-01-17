using MediatR;

namespace TimeService.Application.Features.Overtime.Commands;

public class RejectOvertimeRequestCommand : IRequest<RejectOvertimeResult>
{
    public Guid RequestId { get; set; }
    public Guid ApproverId { get; set; }
    public string Reason { get; set; } = string.Empty;
}

public class RejectOvertimeResult
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
}
