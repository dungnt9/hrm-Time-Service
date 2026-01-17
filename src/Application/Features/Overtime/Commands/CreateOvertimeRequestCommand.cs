using MediatR;

namespace TimeService.Application.Features.Overtime.Commands;

public class CreateOvertimeRequestCommand : IRequest<CreateOvertimeResult>
{
    public Guid EmployeeId { get; set; }
    public DateTime Date { get; set; }
    public TimeSpan StartTime { get; set; }
    public TimeSpan EndTime { get; set; }
    public string? Reason { get; set; }
}

public class CreateOvertimeResult
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
    public Guid? RequestId { get; set; }
}
