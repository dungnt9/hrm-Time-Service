using TimeService.Domain.Entities;

namespace TimeService.Application.Common.Abstractions.Repositories;

public interface IOvertimeRequestRepository : IRepository<OvertimeRequest>
{
    Task<IEnumerable<OvertimeRequest>> GetByEmployeeAsync(Guid employeeId);
    Task<IEnumerable<OvertimeRequest>> GetPendingForApproverAsync(Guid approverId);
    Task<IEnumerable<OvertimeRequest>> GetByStatusAsync(OvertimeStatus status);
}
