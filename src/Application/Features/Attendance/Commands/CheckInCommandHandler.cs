using MediatR;
using TimeService.Application.Common.Abstractions.Repositories;
using TimeService.Domain.Entities;
using AttendanceEntity = TimeService.Domain.Entities.Attendance;

namespace TimeService.Application.Features.Attendance.Commands;

public class CheckInCommandHandler : IRequestHandler<CheckInCommand, CheckInResult>
{
    private readonly IUnitOfWork _unitOfWork;

    public CheckInCommandHandler(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<CheckInResult> Handle(CheckInCommand request, CancellationToken cancellationToken)
    {
        var today = DateTime.UtcNow.Date;
        var existing = await _unitOfWork.Attendances.GetByEmployeeAndDateAsync(request.EmployeeId, today);

        if (existing != null && existing.CheckInTime.HasValue)
        {
            return new CheckInResult
            {
                Success = false,
                Message = "Already checked in today",
                CheckInTime = existing.CheckInTime
            };
        }

        var now = DateTime.UtcNow;
        var attendance = existing ?? new AttendanceEntity
        {
            Id = Guid.NewGuid(),
            EmployeeId = request.EmployeeId,
            Date = today,
            CreatedAt = now
        };

        attendance.CheckInTime = now;
        attendance.CheckInStatus = DetermineCheckInStatus(now);
        attendance.CheckInLatitude = request.Latitude;
        attendance.CheckInLongitude = request.Longitude;
        attendance.CheckInDeviceInfo = request.DeviceInfo;
        attendance.CheckInIpAddress = request.IpAddress;
        attendance.UpdatedAt = now;

        if (existing == null)
            await _unitOfWork.Attendances.AddAsync(attendance);
        else
            await _unitOfWork.Attendances.UpdateAsync(attendance);

        await _unitOfWork.SaveChangesAsync();

        return new CheckInResult
        {
            Success = true,
            Message = "Checked in successfully",
            CheckInTime = now,
            Status = attendance.CheckInStatus.ToString()
        };
    }

    private AttendanceStatus DetermineCheckInStatus(DateTime checkInTime)
    {
        var standardStart = new TimeSpan(8, 30, 0);
        var checkInTimeOfDay = checkInTime.TimeOfDay;

        if (checkInTimeOfDay <= standardStart.Add(TimeSpan.FromMinutes(15)))
            return AttendanceStatus.OnTime;

        return AttendanceStatus.Late;
    }
}
