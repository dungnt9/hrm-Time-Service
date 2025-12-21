# Time Service

This service manages attendance, leave requests, leave balances, shifts, and approval workflows for the HRM system.

## Features

- Check-in/check-out attendance tracking
- Leave request workflow (2-level approval)
- Leave balance management
- Shift assignment
- Leave policy configuration
- Approval history tracking
- Outbox pattern for event publishing
- gRPC API for internal communication

## Tech Stack

- .NET 8, ASP.NET Core Web API
- Entity Framework Core
- PostgreSQL
- Redis (cache)
- RabbitMQ (event bus)
- gRPC
- Docker

## Endpoints

- REST: `/api/attendance`, `/api/leaves`, `/api/leavebalances`, `/api/shifts`, `/api/leavepolicies`, `/api/approvalhistory`
- gRPC: see `Protos/time.proto`

## Database

- Connection: `Host=postgres-time;Port=5432;Database=time_db;Username=time_user;Password=time_pass`
- Seed data: `Data/seed-data.sql` (auto-applied on first run)

## Environment Variables

- `ConnectionStrings__DefaultConnection`
- `ConnectionStrings__Redis`
- `RabbitMQ__Host`, `RabbitMQ__Username`, `RabbitMQ__Password`
- `Keycloak__Authority`, `Keycloak__Audience`

## Running Locally

```sh
docker-compose up -d postgres-time redis rabbitmq
# (or run all infra)
dotnet ef database update --project TimeService
ASPNETCORE_ENVIRONMENT=Development dotnet run --project TimeService
```

## Docker

Service is built and run via Docker Compose. See root `docker-compose.yml`.

## Health Check

- `/health` endpoint for readiness/liveness

## Notes

- Requires PostgreSQL, Redis, RabbitMQ, EmployeeService to be healthy before startup
- Approval workflow supports 2 levels (manager, HR)
- Leave policies are company-configurable

---

© 2025 HRM System
