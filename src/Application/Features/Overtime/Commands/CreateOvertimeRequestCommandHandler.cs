using MediatR;
using TimeService.Application.Common.Abstractions.Repositories;
using TimeService.Domain.Entities;

namespace TimeService.Application.Features.Overtime.Commands;

public class CreateOvertimeRequestCommandHandler : IRequestHandler<CreateOvertimeRequestCommand, CreateOvertimeResult>
{
    private readonly IUnitOfWork _unitOfWork;

    public CreateOvertimeRequestCommandHandler(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task<CreateOvertimeResult> Handle(CreateOvertimeRequestCommand request, CancellationToken cancellationToken)
    {
        var overtimeRequest = new OvertimeRequest
        {
            Id = Guid.NewGuid(),
            EmployeeId = request.EmployeeId,
            Date = request.Date,
            StartTime = request.StartTime,
            EndTime = request.EndTime,
            TotalMinutes = (int)(request.EndTime - request.StartTime).TotalMinutes,
            Reason = request.Reason,
            Status = OvertimeStatus.Pending,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        };

        await _unitOfWork.OvertimeRequests.AddAsync(overtimeRequest);
        await _unitOfWork.SaveChangesAsync();

        return new CreateOvertimeResult
        {
            Success = true,
            Message = "Overtime request created successfully",
            RequestId = overtimeRequest.Id
        };
    }
}
