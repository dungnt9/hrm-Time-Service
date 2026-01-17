using MediatR;
using TimeService.Application.Common.Abstractions.Repositories;
using TimeService.Domain.Entities;

namespace TimeService.Application.Features.Overtime.Commands;

public class ApproveOvertimeRequestCommandHandler : IRequestHandler<ApproveOvertimeRequestCommand, ApproveOvertimeResult>
{
    private readonly IUnitOfWork _unitOfWork;

    public ApproveOvertimeRequestCommandHandler(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<ApproveOvertimeResult> Handle(ApproveOvertimeRequestCommand request, CancellationToken cancellationToken)
    {
        var overtimeRequest = await _unitOfWork.OvertimeRequests.GetByIdAsync(request.RequestId);
        if (overtimeRequest == null)
        {
            return new ApproveOvertimeResult
            {
                Success = false,
                Message = "Overtime request not found"
            };
        }

        if (overtimeRequest.Status != OvertimeStatus.Pending)
        {
            return new ApproveOvertimeResult
            {
                Success = false,
                Message = "Request has already been processed"
            };
        }

        overtimeRequest.Status = OvertimeStatus.Approved;
        overtimeRequest.ApproverId = request.ApproverId;
        overtimeRequest.ApprovedAt = DateTime.UtcNow;
        overtimeRequest.ApproverComment = request.Comment;
        overtimeRequest.UpdatedAt = DateTime.UtcNow;

        await _unitOfWork.OvertimeRequests.UpdateAsync(overtimeRequest);
        await _unitOfWork.SaveChangesAsync();

        return new ApproveOvertimeResult
        {
            Success = true,
            Message = "Overtime request approved"
        };
    }
}
