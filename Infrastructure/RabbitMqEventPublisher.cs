using RabbitMQ.Client;
using System.Text;
using System.Text.Json;

namespace TimeService.Infrastructure;

public interface IEventPublisher
{
    Task PublishAsync(string eventType, object payload);
}

public class RabbitMqEventPublisher : IEventPublisher
{
    private readonly IConnection _connection;
    private readonly ILogger<RabbitMqEventPublisher> _logger;

    public RabbitMqEventPublisher(IConnection connection, ILogger<RabbitMqEventPublisher> logger)
    {
        _connection = connection;
        _logger = logger;
    }

    public async Task PublishAsync(string eventType, object payload)
    {
        using var channel = _connection.CreateModel();
        
        channel.ExchangeDeclare("hrm.events", ExchangeType.Topic, durable: true);
        
        var message = JsonSerializer.Serialize(new
        {
            EventType = eventType,
            Payload = payload,
            Timestamp = DateTime.UtcNow
        });
        
        var body = Encoding.UTF8.GetBytes(message);
        
        var properties = channel.CreateBasicProperties();
        properties.Persistent = true;
        properties.ContentType = "application/json";
        
        channel.BasicPublish(
            exchange: "hrm.events",
            routingKey: eventType,
            basicProperties: properties,
            body: body);

        _logger.LogInformation("Published event {EventType}", eventType);
        
        await Task.CompletedTask;
    }
}
