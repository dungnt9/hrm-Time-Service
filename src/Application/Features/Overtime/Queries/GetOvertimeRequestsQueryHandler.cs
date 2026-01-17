using MediatR;
using TimeService.Application.Common.Abstractions.Repositories;

namespace TimeService.Application.Features.Overtime.Queries;

public class GetOvertimeRequestsQueryHandler : IRequestHandler<GetOvertimeRequestsQuery, IEnumerable<OvertimeRequestDto>>
{
    private readonly IUnitOfWork _unitOfWork;

    public GetOvertimeRequestsQueryHandler(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<IEnumerable<OvertimeRequestDto>> Handle(GetOvertimeRequestsQuery request, CancellationToken cancellationToken)
    {
        var requests = await _unitOfWork.OvertimeRequests.GetByEmployeeAsync(request.EmployeeId);

        if (request.StartDate.HasValue)
            requests = requests.Where(r => r.Date >= request.StartDate.Value);

        if (request.EndDate.HasValue)
            requests = requests.Where(r => r.Date <= request.EndDate.Value);

        return requests.Select(r => new OvertimeRequestDto
        {
            Id = r.Id,
            EmployeeId = r.EmployeeId,
            Date = r.Date,
            StartTime = r.StartTime,
            EndTime = r.EndTime,
            TotalMinutes = r.TotalMinutes,
            Reason = r.Reason,
            Status = r.Status.ToString(),
            ApproverId = r.ApproverId,
            ApprovedAt = r.ApprovedAt,
            ApproverComment = r.ApproverComment,
            CreatedAt = r.CreatedAt
        }).OrderByDescending(r => r.Date);
    }
}
