using MediatR;
using TimeService.Application.Common.Abstractions.Repositories;
using TimeService.Domain.Entities;

namespace TimeService.Application.Features.Overtime.Commands;

public class RejectOvertimeRequestCommandHandler : IRequestHandler<RejectOvertimeRequestCommand, RejectOvertimeResult>
{
    private readonly IUnitOfWork _unitOfWork;

    public RejectOvertimeRequestCommandHandler(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<RejectOvertimeResult> Handle(RejectOvertimeRequestCommand request, CancellationToken cancellationToken)
    {
        var overtimeRequest = await _unitOfWork.OvertimeRequests.GetByIdAsync(request.RequestId);
        if (overtimeRequest == null)
        {
            return new RejectOvertimeResult
            {
                Success = false,
                Message = "Overtime request not found"
            };
        }

        if (overtimeRequest.Status != OvertimeStatus.Pending)
        {
            return new RejectOvertimeResult
            {
                Success = false,
                Message = "Request has already been processed"
            };
        }

        overtimeRequest.Status = OvertimeStatus.Rejected;
        overtimeRequest.ApproverId = request.ApproverId;
        overtimeRequest.ApprovedAt = DateTime.UtcNow;
        overtimeRequest.ApproverComment = request.Reason;
        overtimeRequest.UpdatedAt = DateTime.UtcNow;

        await _unitOfWork.OvertimeRequests.UpdateAsync(overtimeRequest);
        await _unitOfWork.SaveChangesAsync();

        return new RejectOvertimeResult
        {
            Success = true,
            Message = "Overtime request rejected"
        };
    }
}
