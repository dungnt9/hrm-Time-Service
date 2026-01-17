using TimeService.Domain.Entities;

namespace TimeService.Application.Common.Abstractions.Repositories;

public interface ILeaveRequestRepository : IRepository<LeaveRequest>
{
    Task<IEnumerable<LeaveRequest>> GetByEmployeeAsync(Guid employeeId);
    Task<IEnumerable<LeaveRequest>> GetPendingForApproverAsync(Guid approverId);
    Task<IEnumerable<LeaveRequest>> GetByStatusAsync(LeaveRequestStatus status);
}
