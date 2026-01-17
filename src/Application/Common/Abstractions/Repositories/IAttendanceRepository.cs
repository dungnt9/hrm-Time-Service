using TimeService.Domain.Entities;

namespace TimeService.Application.Common.Abstractions.Repositories;

public interface IAttendanceRepository : IRepository<Attendance>
{
    Task<Attendance?> GetByEmployeeAndDateAsync(Guid employeeId, DateTime date);
    Task<IEnumerable<Attendance>> GetByEmployeeAsync(Guid employeeId, DateTime startDate, DateTime endDate);
    Task<IEnumerable<Attendance>> GetByDateAsync(DateTime date);
}
