using MediatR;

namespace TimeService.Application.Features.Attendance.Commands;

public class CheckInCommand : IRequest<CheckInResult>
{
    public Guid EmployeeId { get; set; }
    public double? Latitude { get; set; }
    public double? Longitude { get; set; }
    public string? DeviceInfo { get; set; }
    public string? IpAddress { get; set; }
}

public class CheckInResult
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
    public DateTime? CheckInTime { get; set; }
    public string? Status { get; set; }
}
