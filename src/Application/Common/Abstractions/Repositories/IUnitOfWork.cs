namespace TimeService.Application.Common.Abstractions.Repositories;

public interface IUnitOfWork
{
    IAttendanceRepository Attendances { get; }
    ILeaveRequestRepository LeaveRequests { get; }
    IOvertimeRequestRepository OvertimeRequests { get; }
    Task<int> SaveChangesAsync();
}
