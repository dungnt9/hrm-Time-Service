using MediatR;
using TimeService.Application.Common.Abstractions.Repositories;
using TimeService.Domain.Entities;

namespace TimeService.Application.Features.Attendance.Commands;

public class CheckOutCommandHandler : IRequestHandler<CheckOutCommand, CheckOutResult>
{
    private readonly IUnitOfWork _unitOfWork;

    public CheckOutCommandHandler(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<CheckOutResult> Handle(CheckOutCommand request, CancellationToken cancellationToken)
    {
        var today = DateTime.UtcNow.Date;
        var attendance = await _unitOfWork.Attendances.GetByEmployeeAndDateAsync(request.EmployeeId, today);

        if (attendance == null || !attendance.CheckInTime.HasValue)
        {
            return new CheckOutResult
            {
                Success = false,
                Message = "Must check in before checking out"
            };
        }

        if (attendance.CheckOutTime.HasValue)
        {
            return new CheckOutResult
            {
                Success = false,
                Message = "Already checked out today",
                CheckOutTime = attendance.CheckOutTime
            };
        }

        var now = DateTime.UtcNow;
        attendance.CheckOutTime = now;
        attendance.CheckOutStatus = DetermineCheckOutStatus(now);
        attendance.CheckOutLatitude = request.Latitude;
        attendance.CheckOutLongitude = request.Longitude;
        attendance.Note = request.Note;
        attendance.TotalHours = (now - attendance.CheckInTime.Value).TotalHours;
        attendance.UpdatedAt = now;

        await _unitOfWork.Attendances.UpdateAsync(attendance);
        await _unitOfWork.SaveChangesAsync();

        return new CheckOutResult
        {
            Success = true,
            Message = "Checked out successfully",
            CheckOutTime = now,
            TotalHours = attendance.TotalHours,
            Status = attendance.CheckOutStatus.ToString()
        };
    }

    private AttendanceStatus DetermineCheckOutStatus(DateTime checkOutTime)
    {
        var standardEnd = new TimeSpan(17, 30, 0);
        var checkOutTimeOfDay = checkOutTime.TimeOfDay;

        if (checkOutTimeOfDay < standardEnd.Subtract(TimeSpan.FromMinutes(15)))
            return AttendanceStatus.EarlyLeave;

        if (checkOutTimeOfDay > standardEnd.Add(TimeSpan.FromMinutes(30)))
            return AttendanceStatus.Overtime;

        return AttendanceStatus.OnTime;
    }
}
