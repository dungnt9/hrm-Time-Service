using MediatR;

namespace TimeService.Application.Features.Attendance.Commands;

public class CheckOutCommand : IRequest<CheckOutResult>
{
    public Guid EmployeeId { get; set; }
    public double? Latitude { get; set; }
    public double? Longitude { get; set; }
    public string? Note { get; set; }
}

public class CheckOutResult
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
    public DateTime? CheckOutTime { get; set; }
    public double? TotalHours { get; set; }
    public string? Status { get; set; }
}
