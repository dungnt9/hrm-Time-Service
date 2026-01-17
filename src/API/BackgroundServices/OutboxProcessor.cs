using Microsoft.EntityFrameworkCore;
using TimeService.Data;
using TimeService.Infrastructure;

namespace TimeService.BackgroundServices;

public class OutboxProcessor : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<OutboxProcessor> _logger;

    public OutboxProcessor(IServiceProvider serviceProvider, ILogger<OutboxProcessor> logger)
    {
        _serviceProvider = serviceProvider;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                using var scope = _serviceProvider.CreateScope();
                var context = scope.ServiceProvider.GetRequiredService<TimeDbContext>();
                var eventPublisher = scope.ServiceProvider.GetRequiredService<IEventPublisher>();

                var messages = await context.OutboxMessages
                    .Where(m => m.ProcessedAt == null && m.RetryCount < 3)
                    .OrderBy(m => m.CreatedAt)
                    .Take(10)
                    .ToListAsync(stoppingToken);

                foreach (var message in messages)
                {
                    try
                    {
                        await eventPublisher.PublishAsync(message.EventType, message.Payload);
                        message.ProcessedAt = DateTime.UtcNow;
                        _logger.LogInformation("Processed outbox message {MessageId} with event {EventType}", message.Id, message.EventType);
                    }
                    catch (Exception ex)
                    {
                        message.RetryCount++;
                        message.Error = ex.Message;
                        _logger.LogError(ex, "Failed to process outbox message {MessageId}", message.Id);
                    }
                }

                await context.SaveChangesAsync(stoppingToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in outbox processor");
            }

            await Task.Delay(TimeSpan.FromSeconds(5), stoppingToken);
        }
    }
}
