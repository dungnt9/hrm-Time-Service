namespace TimeService.Domain.Entities;

public class LeaveBalance
{
    public Guid Id { get; set; }
    public Guid EmployeeId { get; set; }
    public int Year { get; set; }
    public int AnnualTotal { get; set; } = 12;
    public int AnnualUsed { get; set; }
    public int AnnualCarryOver { get; set; }
    public int SickTotal { get; set; } = 10;
    public int SickUsed { get; set; }
    public int UnpaidUsed { get; set; }
    public int MaternityTotal { get; set; } = 180;
    public int MaternityUsed { get; set; }
    public int PaternityTotal { get; set; } = 5;
    public int PaternityUsed { get; set; }
    public int WeddingTotal { get; set; } = 3;
    public int WeddingUsed { get; set; }
    public int BereavementTotal { get; set; } = 3;
    public int BereavementUsed { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
