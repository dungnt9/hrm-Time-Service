using Microsoft.EntityFrameworkCore;
using TimeService.Domain.Entities;

namespace TimeService.Data;

public class TimeDbContext : DbContext
{
    public TimeDbContext(DbContextOptions<TimeDbContext> options) : base(options)
    {
    }

    public DbSet<Attendance> Attendances => Set<Attendance>();
    public DbSet<LeaveRequest> LeaveRequests => Set<LeaveRequest>();
    public DbSet<LeaveBalance> LeaveBalances => Set<LeaveBalance>();
    public DbSet<Shift> Shifts => Set<Shift>();
    public DbSet<EmployeeShift> EmployeeShifts => Set<EmployeeShift>();
    public DbSet<OutboxMessage> OutboxMessages => Set<OutboxMessage>();
    public DbSet<LeavePolicy> LeavePolicies => Set<LeavePolicy>();
    public DbSet<ApprovalHistory> ApprovalHistories => Set<ApprovalHistory>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Attendance
        modelBuilder.Entity<Attendance>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => new { e.EmployeeId, e.Date }).IsUnique();
            entity.Property(e => e.CheckInStatus).HasConversion<string>();
            entity.Property(e => e.CheckOutStatus).HasConversion<string>();
        });

        // LeaveRequest
        modelBuilder.Entity<LeaveRequest>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.EmployeeId);
            entity.HasIndex(e => e.FirstApproverId);
            entity.HasIndex(e => e.SecondApproverId);
            entity.HasIndex(e => e.Status);
            entity.Property(e => e.LeaveType).HasConversion<string>();
            entity.Property(e => e.Status).HasConversion<string>();
            entity.Property(e => e.FirstApproverType).HasConversion<string>();
            entity.Property(e => e.FirstApprovalStatus).HasConversion<string>();
            entity.Property(e => e.SecondApproverType).HasConversion<string>();
            entity.Property(e => e.SecondApprovalStatus).HasConversion<string>();
        });

        // LeaveBalance
        modelBuilder.Entity<LeaveBalance>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => new { e.EmployeeId, e.Year }).IsUnique();
        });

        // Shift
        modelBuilder.Entity<Shift>(entity =>
        {
            entity.HasKey(e => e.Id);
        });

        // EmployeeShift
        modelBuilder.Entity<EmployeeShift>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.EmployeeId);
            entity.HasOne(e => e.Shift)
                .WithMany()
                .HasForeignKey(e => e.ShiftId);
        });

        // OutboxMessage
        modelBuilder.Entity<OutboxMessage>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.ProcessedAt);
        });

        // LeavePolicy
        modelBuilder.Entity<LeavePolicy>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Name).IsRequired().HasMaxLength(100);
            entity.Property(e => e.LeaveType).HasConversion<string>();
            entity.HasIndex(e => new { e.CompanyId, e.LeaveType });
        });

        // ApprovalHistory
        modelBuilder.Entity<ApprovalHistory>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Action).IsRequired().HasMaxLength(50);
            entity.Property(e => e.Level).HasConversion<string>();
            entity.HasIndex(e => e.LeaveRequestId);
            entity.HasOne(e => e.LeaveRequest)
                .WithMany()
                .HasForeignKey(e => e.LeaveRequestId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // Seed data
        SeedData(modelBuilder);
    }

    private void SeedData(ModelBuilder modelBuilder)
    {
        var defaultShiftId = Guid.Parse("55555555-5555-5555-5555-555555555555");
        
        modelBuilder.Entity<Shift>().HasData(new Shift
        {
            Id = defaultShiftId,
            Name = "Standard Shift",
            StartTime = new TimeSpan(9, 0, 0),
            EndTime = new TimeSpan(18, 0, 0),
            BreakMinutes = 60,
            IsDefault = true,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        });

        // Seed leave balances for existing employees
        var adminId = Guid.Parse("44444444-4444-4444-4444-444444444444");
        var hrId = Guid.Parse("44444444-4444-4444-4444-444444444445");
        var managerId = Guid.Parse("44444444-4444-4444-4444-444444444446");
        var empId = Guid.Parse("44444444-4444-4444-4444-444444444447");
        var currentYear = DateTime.UtcNow.Year;

        modelBuilder.Entity<LeaveBalance>().HasData(
            new LeaveBalance { Id = Guid.NewGuid(), EmployeeId = adminId, Year = currentYear, AnnualTotal = 12, SickTotal = 10, CreatedAt = DateTime.UtcNow, UpdatedAt = DateTime.UtcNow },
            new LeaveBalance { Id = Guid.NewGuid(), EmployeeId = hrId, Year = currentYear, AnnualTotal = 12, SickTotal = 10, CreatedAt = DateTime.UtcNow, UpdatedAt = DateTime.UtcNow },
            new LeaveBalance { Id = Guid.NewGuid(), EmployeeId = managerId, Year = currentYear, AnnualTotal = 12, SickTotal = 10, CreatedAt = DateTime.UtcNow, UpdatedAt = DateTime.UtcNow },
            new LeaveBalance { Id = Guid.NewGuid(), EmployeeId = empId, Year = currentYear, AnnualTotal = 12, SickTotal = 10, CreatedAt = DateTime.UtcNow, UpdatedAt = DateTime.UtcNow }
        );
    }
}
