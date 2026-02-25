-- =============================================
-- Time Service - Seed Data
-- =============================================

-- Shifts
INSERT INTO "Shifts" ("Id", "Name", "Code", "StartTime", "EndTime", "BreakMinutes", "LateGraceMinutes", "EarlyLeaveGraceMinutes", "IsDefault", "IsNightShift", "DepartmentId", "IsActive", "CreatedAt", "UpdatedAt")
VALUES 
('55555555-5555-5555-5555-555555555551', 'Morning Shift', 'MORN', '08:00:00', '17:00:00', 60, 15, 15, true, false, NULL, true, NOW(), NOW()),
('55555555-5555-5555-5555-555555555552', 'Standard Shift', 'STD', '09:00:00', '18:00:00', 60, 15, 15, false, false, NULL, true, NOW(), NOW()),
('55555555-5555-5555-5555-555555555553', 'Night Shift', 'NIGHT', '22:00:00', '06:00:00', 45, 10, 10, false, true, NULL, true, NOW(), NOW()),
('55555555-5555-5555-5555-555555555554', 'Flexible Shift', 'FLEX', '10:00:00', '19:00:00', 60, 30, 30, false, false, '22222222-2222-2222-2222-222222222222', true, NOW(), NOW());

-- Employee Shifts
INSERT INTO "EmployeeShifts" ("Id", "EmployeeId", "ShiftId", "EffectiveDate", "EndDate", "IsActive", "CreatedAt")
VALUES 
-- Backend Team - Standard Shift
('88888888-8888-8888-8888-888888888881', '44444444-4444-4444-4444-444444444447', '55555555-5555-5555-5555-555555555552', '2023-01-01', NULL, true, NOW()),
('88888888-8888-8888-8888-888888888882', '44444444-4444-4444-4444-444444444448', '55555555-5555-5555-5555-555555555552', '2023-01-01', NULL, true, NOW()),
('88888888-8888-8888-8888-888888888883', '44444444-4444-4444-4444-444444444453', '55555555-5555-5555-5555-555555555552', '2023-01-01', NULL, true, NOW()),
('88888888-8888-8888-8888-888888888884', '44444444-4444-4444-4444-444444444454', '55555555-5555-5555-5555-555555555552', '2023-01-01', NULL, true, NOW()),
('88888888-8888-8888-8888-888888888885', '44444444-4444-4444-4444-444444444455', '55555555-5555-5555-5555-555555555552', '2023-01-01', NULL, true, NOW()),
-- Engineering - Flexible Shift
('88888888-8888-8888-8888-888888888886', '44444444-4444-4444-4444-444444444449', '55555555-5555-5555-5555-555555555554', '2023-01-01', NULL, true, NOW()),
('88888888-8888-8888-8888-888888888887', '44444444-4444-4444-4444-444444444456', '55555555-5555-5555-5555-555555555554', '2023-01-01', NULL, true, NOW()),
-- HR - Morning Shift
('88888888-8888-8888-8888-888888888888', '44444444-4444-4444-4444-444444444445', '55555555-5555-5555-5555-555555555551', '2023-01-01', NULL, true, NOW()),
('88888888-8888-8888-8888-888888888889', '44444444-4444-4444-4444-444444444451', '55555555-5555-5555-5555-555555555551', '2023-01-01', NULL, true, NOW()),
('88888888-8888-8888-8888-88888888888a', '44444444-4444-4444-4444-444444444452', '55555555-5555-5555-5555-555555555551', '2023-01-01', NULL, true, NOW());

-- Holidays for 2024 and 2025
INSERT INTO "Holidays" ("Id", "Name", "Date", "Year", "IsRecurring", "Description", "CreatedAt")
VALUES 
-- 2024
('99999999-9999-9999-9999-999999999901', 'New Year', '2024-01-01', 2024, true, 'New Year Holiday', NOW()),
('99999999-9999-9999-9999-999999999902', 'Tet Holiday', '2024-02-08', 2024, false, 'Lunar New Year Eve', NOW()),
('99999999-9999-9999-9999-999999999903', 'Tet Holiday', '2024-02-09', 2024, false, 'Lunar New Year Day 1', NOW()),
('99999999-9999-9999-9999-999999999904', 'Tet Holiday', '2024-02-10', 2024, false, 'Lunar New Year Day 2', NOW()),
('99999999-9999-9999-9999-999999999905', 'Tet Holiday', '2024-02-11', 2024, false, 'Lunar New Year Day 3', NOW()),
('99999999-9999-9999-9999-999999999906', 'Tet Holiday', '2024-02-12', 2024, false, 'Lunar New Year Day 4', NOW()),
('99999999-9999-9999-9999-999999999907', 'Hung Kings Day', '2024-04-18', 2024, false, 'Hung Kings Commemoration Day', NOW()),
('99999999-9999-9999-9999-999999999908', 'Liberation Day', '2024-04-30', 2024, true, 'Reunification Day', NOW()),
('99999999-9999-9999-9999-999999999909', 'Labor Day', '2024-05-01', 2024, true, 'International Labor Day', NOW()),
('99999999-9999-9999-9999-999999999910', 'National Day', '2024-09-02', 2024, true, 'Vietnam National Day', NOW()),
-- 2025
('99999999-9999-9999-9999-999999999911', 'New Year', '2025-01-01', 2025, true, 'New Year Holiday', NOW()),
('99999999-9999-9999-9999-999999999912', 'Tet Holiday', '2025-01-28', 2025, false, 'Lunar New Year Eve', NOW()),
('99999999-9999-9999-9999-999999999913', 'Tet Holiday', '2025-01-29', 2025, false, 'Lunar New Year Day 1', NOW()),
('99999999-9999-9999-9999-999999999914', 'Tet Holiday', '2025-01-30', 2025, false, 'Lunar New Year Day 2', NOW()),
('99999999-9999-9999-9999-999999999915', 'Tet Holiday', '2025-01-31', 2025, false, 'Lunar New Year Day 3', NOW()),
('99999999-9999-9999-9999-999999999916', 'Tet Holiday', '2025-02-01', 2025, false, 'Lunar New Year Day 4', NOW()),
('99999999-9999-9999-9999-999999999917', 'Hung Kings Day', '2025-04-07', 2025, false, 'Hung Kings Commemoration Day', NOW()),
('99999999-9999-9999-9999-999999999918', 'Liberation Day', '2025-04-30', 2025, true, 'Reunification Day', NOW()),
('99999999-9999-9999-9999-999999999919', 'Labor Day', '2025-05-01', 2025, true, 'International Labor Day', NOW()),
('99999999-9999-9999-9999-999999999920', 'National Day', '2025-09-02', 2025, true, 'Vietnam National Day', NOW());

-- Leave Balances for all employees (2024 and 2025)
INSERT INTO "LeaveBalances" ("Id", "EmployeeId", "Year", "AnnualTotal", "AnnualUsed", "AnnualCarryOver", "SickTotal", "SickUsed", "UnpaidUsed", "MaternityTotal", "MaternityUsed", "PaternityTotal", "PaternityUsed", "WeddingTotal", "WeddingUsed", "BereavementTotal", "BereavementUsed", "CreatedAt", "UpdatedAt")
VALUES 
-- 2024 balances
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa101', '44444444-4444-4444-4444-444444444444', 2024, 15, 8, 3, 10, 2, 0, 0, 0, 5, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa102', '44444444-4444-4444-4444-444444444445', 2024, 18, 10, 6, 10, 3, 0, 180, 0, 0, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa103', '44444444-4444-4444-4444-444444444446', 2024, 20, 12, 8, 10, 1, 0, 0, 0, 5, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa104', '44444444-4444-4444-4444-444444444447', 2024, 15, 7, 3, 10, 2, 1, 0, 0, 5, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa105', '44444444-4444-4444-4444-444444444448', 2024, 14, 9, 2, 10, 4, 2, 0, 0, 5, 5, 3, 3, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa106', '44444444-4444-4444-4444-444444444449', 2024, 15, 6, 3, 10, 1, 0, 180, 0, 0, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa107', '44444444-4444-4444-4444-444444444450', 2024, 15, 8, 3, 10, 2, 0, 180, 60, 0, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa108', '44444444-4444-4444-4444-444444444451', 2024, 12, 5, 0, 10, 1, 0, 180, 0, 0, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa109', '44444444-4444-4444-4444-444444444452', 2024, 12, 4, 0, 10, 0, 0, 0, 0, 5, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa110', '44444444-4444-4444-4444-444444444453', 2024, 12, 6, 0, 10, 3, 0, 0, 0, 5, 0, 3, 0, 3, 0, NOW(), NOW()),

-- 2025 balances
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa201', '44444444-4444-4444-4444-444444444444', 2025, 15, 2, 4, 10, 0, 0, 0, 0, 5, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa202', '44444444-4444-4444-4444-444444444445', 2025, 18, 3, 5, 10, 1, 0, 180, 0, 0, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa203', '44444444-4444-4444-4444-444444444446', 2025, 20, 4, 5, 10, 0, 0, 0, 0, 5, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa204', '44444444-4444-4444-4444-444444444447', 2025, 15, 1, 5, 10, 0, 0, 0, 0, 5, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa205', '44444444-4444-4444-4444-444444444448', 2025, 14, 2, 3, 10, 1, 0, 0, 0, 5, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa206', '44444444-4444-4444-4444-444444444449', 2025, 15, 0, 6, 10, 0, 0, 180, 0, 0, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa207', '44444444-4444-4444-4444-444444444450', 2025, 15, 1, 4, 10, 0, 0, 180, 0, 0, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa208', '44444444-4444-4444-4444-444444444451', 2025, 12, 0, 4, 10, 0, 0, 180, 0, 0, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa209', '44444444-4444-4444-4444-444444444452', 2025, 12, 1, 5, 10, 0, 0, 0, 0, 5, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa210', '44444444-4444-4444-4444-444444444453', 2025, 12, 0, 3, 10, 0, 0, 0, 0, 5, 0, 3, 0, 3, 0, NOW(), NOW());

-- Attendance records for last 30 days (sample for some employees)
-- Generate attendance for December 2025
INSERT INTO "Attendances" ("Id", "EmployeeId", "Date", "CheckInTime", "CheckOutTime", "TotalHours", "CheckInStatus", "CheckOutStatus", "LateMinutes", "EarlyLeaveMinutes", "OvertimeMinutes", "Note", "CheckInLatitude", "CheckInLongitude", "CheckInAddress", "CheckOutLatitude", "CheckOutLongitude", "CheckOutAddress", "ShiftId", "CreatedAt", "UpdatedAt")
VALUES 
-- Employee 44444444-4444-4444-4444-444444444448 (Nam Vo) - December 2025
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbb001', '44444444-4444-4444-4444-444444444448', '2025-12-01', '2025-12-01 08:55:00', '2025-12-01 18:05:00', 9.17, 'OnTime', 'OnTime', 0, 0, 5, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbb002', '44444444-4444-4444-4444-444444444448', '2025-12-02', '2025-12-02 09:10:00', '2025-12-02 18:00:00', 8.83, 'Late', 'OnTime', 10, 0, 0, 'Traffic jam', 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbb003', '44444444-4444-4444-4444-444444444448', '2025-12-03', '2025-12-03 08:58:00', '2025-12-03 17:45:00', 8.78, 'OnTime', 'EarlyLeave', 0, 15, 0, 'Doctor appointment', 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbb004', '44444444-4444-4444-4444-444444444448', '2025-12-04', '2025-12-04 09:00:00', '2025-12-04 20:00:00', 11.00, 'OnTime', 'Overtime', 0, 0, 120, 'Project deadline', 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbb005', '44444444-4444-4444-4444-444444444448', '2025-12-05', '2025-12-05 09:02:00', '2025-12-05 18:00:00', 8.97, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbb008', '44444444-4444-4444-4444-444444444448', '2025-12-08', '2025-12-08 08:45:00', '2025-12-08 18:10:00', 9.42, 'OnTime', 'OnTime', 0, 0, 10, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbb009', '44444444-4444-4444-4444-444444444448', '2025-12-09', '2025-12-09 09:30:00', '2025-12-09 18:00:00', 8.50, 'Late', 'OnTime', 30, 0, 0, 'Personal reason', 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbb010', '44444444-4444-4444-4444-444444444448', '2025-12-10', '2025-12-10 08:50:00', '2025-12-10 18:00:00', 9.17, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbb011', '44444444-4444-4444-4444-444444444448', '2025-12-11', '2025-12-11 09:00:00', '2025-12-11 18:05:00', 9.08, 'OnTime', 'OnTime', 0, 0, 5, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbb012', '44444444-4444-4444-4444-444444444448', '2025-12-12', '2025-12-12 08:55:00', '2025-12-12 18:00:00', 9.08, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbb015', '44444444-4444-4444-4444-444444444448', '2025-12-15', '2025-12-15 09:05:00', '2025-12-15 18:30:00', 9.42, 'OnTime', 'OnTime', 0, 0, 30, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbb016', '44444444-4444-4444-4444-444444444448', '2025-12-16', '2025-12-16 09:00:00', '2025-12-16 18:00:00', 9.00, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbb017', '44444444-4444-4444-4444-444444444448', '2025-12-17', '2025-12-17 08:50:00', NULL, NULL, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', NULL, NULL, NULL, '55555555-5555-5555-5555-555555555552', NOW(), NOW()),

-- Employee 44444444-4444-4444-4444-444444444447 (Hung Tran - Team Lead) - December 2025
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbb101', '44444444-4444-4444-4444-444444444447', '2025-12-01', '2025-12-01 08:45:00', '2025-12-01 19:00:00', 10.25, 'OnTime', 'Overtime', 0, 0, 60, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbb102', '44444444-4444-4444-4444-444444444447', '2025-12-02', '2025-12-02 08:50:00', '2025-12-02 18:30:00', 9.67, 'OnTime', 'OnTime', 0, 0, 30, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbb103', '44444444-4444-4444-4444-444444444447', '2025-12-03', '2025-12-03 08:55:00', '2025-12-03 18:00:00', 9.08, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbb104', '44444444-4444-4444-4444-444444444447', '2025-12-04', '2025-12-04 08:40:00', '2025-12-04 20:30:00', 11.83, 'OnTime', 'Overtime', 0, 0, 150, 'Release deployment', 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbb105', '44444444-4444-4444-4444-444444444447', '2025-12-05', '2025-12-05 09:00:00', '2025-12-05 18:00:00', 9.00, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW());

-- Leave Requests (with various statuses)
INSERT INTO "LeaveRequests" ("Id", "EmployeeId", "LeaveType", "StartDate", "EndDate", "TotalDays", "Reason", "Status", "FirstApproverId", "FirstApproverType", "FirstApprovedAt", "FirstApproverComment", "FirstApprovalStatus", "SecondApproverId", "SecondApproverType", "SecondApprovedAt", "SecondApproverComment", "SecondApprovalStatus", "RejectionReason", "Attachments", "CreatedAt", "UpdatedAt")
VALUES 
-- Approved requests
('cccccccc-cccc-cccc-cccc-ccccccccc001', '44444444-4444-4444-4444-444444444448', 'Annual', '2025-12-24', '2025-12-26', 3, 'Christmas vacation with family', 'Approved', '44444444-4444-4444-4444-444444444447', 'Manager', '2025-12-10 10:00:00', 'Approved, enjoy your vacation!', 'Approved', '44444444-4444-4444-4444-444444444445', 'HR', '2025-12-10 14:00:00', 'Approved', 'Approved', NULL, NULL, '2025-12-05 09:00:00', NOW()),

('cccccccc-cccc-cccc-cccc-ccccccccc002', '44444444-4444-4444-4444-444444444453', 'Sick', '2025-11-20', '2025-11-21', 2, 'Flu symptoms', 'Approved', '44444444-4444-4444-4444-444444444447', 'Manager', '2025-11-20 08:30:00', 'Get well soon', 'Approved', '44444444-4444-4444-4444-444444444445', 'HR', '2025-11-20 09:00:00', 'Approved', 'Approved', NULL, 'medical_cert.pdf', '2025-11-20 08:00:00', NOW()),

-- Pending requests
('cccccccc-cccc-cccc-cccc-ccccccccc003', '44444444-4444-4444-4444-444444444454', 'Annual', '2025-12-30', '2026-01-02', 4, 'New Year holiday', 'Pending', '44444444-4444-4444-4444-444444444447', 'Manager', NULL, NULL, 'Pending', '44444444-4444-4444-4444-444444444445', 'HR', NULL, NULL, 'Pending', NULL, NULL, '2025-12-15 10:00:00', NOW()),

('cccccccc-cccc-cccc-cccc-ccccccccc004', '44444444-4444-4444-4444-444444444455', 'Annual', '2025-12-20', '2025-12-22', 3, 'Personal matters', 'PartiallyApproved', '44444444-4444-4444-4444-444444444447', 'Manager', '2025-12-16 11:00:00', 'Approved from manager side', 'Approved', '44444444-4444-4444-4444-444444444445', 'HR', NULL, NULL, 'Pending', NULL, NULL, '2025-12-14 14:00:00', NOW()),

-- Rejected request
('cccccccc-cccc-cccc-cccc-ccccccccc005', '44444444-4444-4444-4444-444444444456', 'Annual', '2025-12-01', '2025-12-05', 5, 'Trip abroad', 'Rejected', '44444444-4444-4444-4444-444444444449', 'Manager', '2025-11-25 09:00:00', 'Cannot approve due to project deadline', 'Rejected', '44444444-4444-4444-4444-444444444445', 'HR', NULL, NULL, 'Skipped', 'Critical project period, please reschedule', NULL, '2025-11-20 08:00:00', NOW()),

-- More diverse requests
('cccccccc-cccc-cccc-cccc-ccccccccc006', '44444444-4444-4444-4444-444444444450', 'Maternity', '2025-10-01', '2026-03-29', 180, 'Maternity leave', 'Approved', '44444444-4444-4444-4444-444444444446', 'Manager', '2025-09-15 10:00:00', 'Congratulations!', 'Approved', '44444444-4444-4444-4444-444444444445', 'HR', '2025-09-15 11:00:00', 'Approved per policy', 'Approved', NULL, 'medical_documents.pdf', '2025-09-10 09:00:00', NOW()),

('cccccccc-cccc-cccc-cccc-ccccccccc007', '44444444-4444-4444-4444-444444444448', 'Paternity', '2025-08-15', '2025-08-19', 5, 'Wife gave birth', 'Approved', '44444444-4444-4444-4444-444444444447', 'Manager', '2025-08-14 16:00:00', 'Congratulations! Take care', 'Approved', '44444444-4444-4444-4444-444444444445', 'HR', '2025-08-14 17:00:00', 'Approved', 'Approved', NULL, 'birth_certificate.pdf', '2025-08-14 15:00:00', NOW()),

('cccccccc-cccc-cccc-cccc-ccccccccc008', '44444444-4444-4444-4444-444444444448', 'Wedding', '2025-06-20', '2025-06-22', 3, 'My wedding', 'Approved', '44444444-4444-4444-4444-444444444447', 'Manager', '2025-06-01 09:00:00', 'Congratulations on your wedding!', 'Approved', '44444444-4444-4444-4444-444444444445', 'HR', '2025-06-01 10:00:00', 'Best wishes!', 'Approved', NULL, NULL, '2025-05-25 08:00:00', NOW()),

('cccccccc-cccc-cccc-cccc-ccccccccc009', '44444444-4444-4444-4444-444444444451', 'Annual', '2025-12-23', '2025-12-24', 2, 'Year end holiday', 'Pending', '44444444-4444-4444-4444-444444444445', 'HR', NULL, NULL, 'Pending', NULL, 'HR', NULL, NULL, 'Pending', NULL, NULL, '2025-12-16 08:00:00', NOW()),

('cccccccc-cccc-cccc-cccc-cccccccccc10', '44444444-4444-4444-4444-444444444452', 'Unpaid', '2025-12-27', '2025-12-31', 5, 'Extended holiday - personal travel', 'Pending', '44444444-4444-4444-4444-444444444445', 'HR', NULL, NULL, 'Pending', NULL, 'HR', NULL, NULL, 'Pending', NULL, NULL, '2025-12-16 09:30:00', NOW());

-- Overtime Requests
INSERT INTO "OvertimeRequests" ("Id", "EmployeeId", "Date", "StartTime", "EndTime", "TotalMinutes", "Reason", "Status", "ApproverId", "ApprovedAt", "ApproverComment", "CreatedAt", "UpdatedAt")
VALUES 
('dddddddd-dddd-dddd-dddd-ddddddddd001', '44444444-4444-4444-4444-444444444448', '2025-12-04', '18:00:00', '20:00:00', 120, 'Project deadline - feature completion', 'Approved', '44444444-4444-4444-4444-444444444447', '2025-12-04 10:00:00', 'Approved for deadline', NOW(), NOW()),
('dddddddd-dddd-dddd-dddd-ddddddddd002', '44444444-4444-4444-4444-444444444447', '2025-12-04', '18:00:00', '20:30:00', 150, 'Release deployment monitoring', 'Approved', '44444444-4444-4444-4444-444444444446', '2025-12-04 09:00:00', 'Critical release, approved', NOW(), NOW()),
('dddddddd-dddd-dddd-dddd-ddddddddd003', '44444444-4444-4444-4444-444444444453', '2025-12-18', '18:00:00', '21:00:00', 180, 'Bug fixes for production', 'Pending', '44444444-4444-4444-4444-444444444447', NULL, NULL, NOW(), NOW()),
('dddddddd-dddd-dddd-dddd-ddddddddd004', '44444444-4444-4444-4444-444444444456', '2025-12-15', '18:00:00', '19:30:00', 90, 'UI improvements', 'Rejected', '44444444-4444-4444-4444-444444444449', '2025-12-15 17:00:00', 'Not urgent enough, can wait until Monday', NOW(), NOW());

-- =============================================
-- 2026 Seed Data
-- =============================================

-- Employee Shifts for additional employees (manager, admin, employee on maternity return)
INSERT INTO "EmployeeShifts" ("Id", "EmployeeId", "ShiftId", "EffectiveDate", "EndDate", "IsActive", "CreatedAt")
VALUES
('88888888-8888-8888-8888-88888888888b', '44444444-4444-4444-4444-444444444446', '55555555-5555-5555-5555-555555555552', '2023-01-01', NULL, true, NOW()),
('88888888-8888-8888-8888-88888888888c', '44444444-4444-4444-4444-444444444444', '55555555-5555-5555-5555-555555555551', '2023-01-01', NULL, true, NOW()),
('88888888-8888-8888-8888-88888888888d', '44444444-4444-4444-4444-444444444450', '55555555-5555-5555-5555-555555555552', '2023-01-01', NULL, true, NOW());

-- Holidays for 2026 (Year of the Snake, Tet = Jan 29)
INSERT INTO "Holidays" ("Id", "Name", "Date", "Year", "IsRecurring", "Description", "CreatedAt")
VALUES
('99999999-9999-9999-9999-999999999921', 'New Year', '2026-01-01', 2026, true, 'New Year Holiday', NOW()),
('99999999-9999-9999-9999-999999999922', 'Tet Holiday', '2026-01-28', 2026, false, 'Lunar New Year Eve - Year of Snake', NOW()),
('99999999-9999-9999-9999-999999999923', 'Tet Holiday', '2026-01-29', 2026, false, 'Lunar New Year Day 1 - Year of Snake', NOW()),
('99999999-9999-9999-9999-999999999924', 'Tet Holiday', '2026-01-30', 2026, false, 'Lunar New Year Day 2', NOW()),
('99999999-9999-9999-9999-999999999925', 'Tet Holiday', '2026-01-31', 2026, false, 'Lunar New Year Day 3', NOW()),
('99999999-9999-9999-9999-999999999926', 'Tet Holiday', '2026-02-01', 2026, false, 'Lunar New Year Day 4', NOW()),
('99999999-9999-9999-9999-999999999927', 'Hung Kings Day', '2026-04-06', 2026, false, 'Hung Kings Commemoration Day', NOW()),
('99999999-9999-9999-9999-999999999928', 'Liberation Day', '2026-04-30', 2026, true, 'Reunification Day', NOW()),
('99999999-9999-9999-9999-999999999929', 'Labor Day', '2026-05-01', 2026, true, 'International Labor Day', NOW()),
('99999999-9999-9999-9999-99999999992a', 'National Day', '2026-09-02', 2026, true, 'Vietnam National Day', NOW());

-- Leave Balances for 2026 (carry-over from 2025 + fresh annual allocation)
INSERT INTO "LeaveBalances" ("Id", "EmployeeId", "Year", "AnnualTotal", "AnnualUsed", "AnnualCarryOver", "SickTotal", "SickUsed", "UnpaidUsed", "MaternityTotal", "MaternityUsed", "PaternityTotal", "PaternityUsed", "WeddingTotal", "WeddingUsed", "BereavementTotal", "BereavementUsed", "CreatedAt", "UpdatedAt")
VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa301', '44444444-4444-4444-4444-444444444444', 2026, 15, 0, 5, 10, 0, 0, 0, 0, 5, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa302', '44444444-4444-4444-4444-444444444445', 2026, 18, 1, 5, 10, 0, 0, 180, 0, 0, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa303', '44444444-4444-4444-4444-444444444446', 2026, 20, 0, 5, 10, 0, 0, 0, 0, 5, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa304', '44444444-4444-4444-4444-444444444447', 2026, 15, 0, 5, 10, 0, 0, 0, 0, 5, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa305', '44444444-4444-4444-4444-444444444448', 2026, 14, 0, 3, 10, 0, 0, 0, 0, 5, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa306', '44444444-4444-4444-4444-444444444449', 2026, 15, 0, 6, 10, 0, 0, 180, 0, 0, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa307', '44444444-4444-4444-4444-444444444450', 2026, 15, 0, 4, 10, 0, 0, 180, 0, 0, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa308', '44444444-4444-4444-4444-444444444451', 2026, 12, 0, 4, 10, 0, 0, 180, 0, 0, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa309', '44444444-4444-4444-4444-444444444452', 2026, 12, 0, 5, 10, 0, 0, 0, 0, 5, 0, 3, 0, 3, 0, NOW(), NOW()),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaa30a', '44444444-4444-4444-4444-444444444453', 2026, 12, 0, 3, 10, 0, 0, 0, 0, 5, 0, 3, 0, 3, 0, NOW(), NOW());

-- Attendance records for February 2026
-- Working days: Feb 2-6, 9-13, 16-20, 23-24 (17 days)
INSERT INTO "Attendances" ("Id", "EmployeeId", "Date", "CheckInTime", "CheckOutTime", "TotalHours", "CheckInStatus", "CheckOutStatus", "LateMinutes", "EarlyLeaveMinutes", "OvertimeMinutes", "Note", "CheckInLatitude", "CheckInLongitude", "CheckInAddress", "CheckOutLatitude", "CheckOutLongitude", "CheckOutAddress", "ShiftId", "CreatedAt", "UpdatedAt")
VALUES
-- Employee 448 (Nam Vo - employee_user, Standard 09:00-18:00)
('b2264480-0000-0000-0000-448000000001', '44444444-4444-4444-4444-444444444448', '2026-02-02', '2026-02-02 08:58:00', '2026-02-02 18:05:00', 9.12, 'OnTime', 'OnTime', 0, 0, 5, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264480-0000-0000-0000-448000000002', '44444444-4444-4444-4444-444444444448', '2026-02-03', '2026-02-03 09:18:00', '2026-02-03 18:00:00', 8.70, 'Late', 'OnTime', 18, 0, 0, 'Traffic jam', 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264480-0000-0000-0000-448000000003', '44444444-4444-4444-4444-444444444448', '2026-02-04', '2026-02-04 09:02:00', '2026-02-04 18:00:00', 8.97, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264480-0000-0000-0000-448000000004', '44444444-4444-4444-4444-444444444448', '2026-02-05', '2026-02-05 08:55:00', '2026-02-05 19:30:00', 10.58, 'OnTime', 'Overtime', 0, 0, 90, 'Sprint planning', 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264480-0000-0000-0000-448000000005', '44444444-4444-4444-4444-444444444448', '2026-02-06', '2026-02-06 09:05:00', '2026-02-06 18:00:00', 8.92, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264480-0000-0000-0000-448000000006', '44444444-4444-4444-4444-444444444448', '2026-02-09', '2026-02-09 09:00:00', '2026-02-09 18:00:00', 9.00, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264480-0000-0000-0000-448000000007', '44444444-4444-4444-4444-444444444448', '2026-02-10', '2026-02-10 09:22:00', '2026-02-10 18:00:00', 8.63, 'Late', 'OnTime', 22, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264480-0000-0000-0000-448000000008', '44444444-4444-4444-4444-444444444448', '2026-02-11', '2026-02-11 08:57:00', '2026-02-11 18:05:00', 9.13, 'OnTime', 'OnTime', 0, 0, 5, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264480-0000-0000-0000-448000000009', '44444444-4444-4444-4444-444444444448', '2026-02-12', '2026-02-12 09:00:00', '2026-02-12 18:00:00', 9.00, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264480-0000-0000-0000-44800000000a', '44444444-4444-4444-4444-444444444448', '2026-02-13', '2026-02-13 09:00:00', '2026-02-13 20:00:00', 11.00, 'OnTime', 'Overtime', 0, 0, 120, 'Feature completion before review', 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264480-0000-0000-0000-44800000000b', '44444444-4444-4444-4444-444444444448', '2026-02-16', '2026-02-16 09:03:00', '2026-02-16 18:00:00', 8.95, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264480-0000-0000-0000-44800000000c', '44444444-4444-4444-4444-444444444448', '2026-02-17', '2026-02-17 08:55:00', '2026-02-17 17:30:00', 8.58, 'OnTime', 'EarlyLeave', 0, 30, 0, 'Doctor appointment', 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264480-0000-0000-0000-44800000000d', '44444444-4444-4444-4444-444444444448', '2026-02-18', '2026-02-18 09:00:00', '2026-02-18 18:00:00', 9.00, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264480-0000-0000-0000-44800000000e', '44444444-4444-4444-4444-444444444448', '2026-02-19', '2026-02-19 09:01:00', '2026-02-19 18:05:00', 9.07, 'OnTime', 'OnTime', 0, 0, 5, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264480-0000-0000-0000-44800000000f', '44444444-4444-4444-4444-444444444448', '2026-02-20', '2026-02-20 09:00:00', '2026-02-20 18:30:00', 9.50, 'OnTime', 'OnTime', 0, 0, 30, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264480-0000-0000-0000-448000000010', '44444444-4444-4444-4444-444444444448', '2026-02-23', '2026-02-23 08:58:00', '2026-02-23 18:00:00', 9.03, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264480-0000-0000-0000-448000000011', '44444444-4444-4444-4444-444444444448', '2026-02-24', '2026-02-24 09:02:00', NULL, NULL, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', NULL, NULL, NULL, '55555555-5555-5555-5555-555555555552', NOW(), NOW()),

-- Employee 446 (Tuan Le - manager_user, Standard 09:00-18:00)
('b2264460-0000-0000-0000-446000000001', '44444444-4444-4444-4444-444444444446', '2026-02-02', '2026-02-02 08:50:00', '2026-02-02 19:00:00', 10.17, 'OnTime', 'Overtime', 0, 0, 60, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264460-0000-0000-0000-446000000002', '44444444-4444-4444-4444-444444444446', '2026-02-03', '2026-02-03 09:00:00', '2026-02-03 18:30:00', 9.50, 'OnTime', 'OnTime', 0, 0, 30, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264460-0000-0000-0000-446000000003', '44444444-4444-4444-4444-444444444446', '2026-02-04', '2026-02-04 08:55:00', '2026-02-04 18:00:00', 9.08, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264460-0000-0000-0000-446000000004', '44444444-4444-4444-4444-444444444446', '2026-02-05', '2026-02-05 08:45:00', '2026-02-05 20:00:00', 11.25, 'OnTime', 'Overtime', 0, 0, 120, 'Sprint review preparation', 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264460-0000-0000-0000-446000000005', '44444444-4444-4444-4444-444444444446', '2026-02-06', '2026-02-06 09:00:00', '2026-02-06 18:00:00', 9.00, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264460-0000-0000-0000-446000000006', '44444444-4444-4444-4444-444444444446', '2026-02-09', '2026-02-09 08:50:00', '2026-02-09 18:45:00', 9.92, 'OnTime', 'OnTime', 0, 0, 45, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264460-0000-0000-0000-446000000007', '44444444-4444-4444-4444-444444444446', '2026-02-10', '2026-02-10 09:05:00', '2026-02-10 18:30:00', 9.42, 'OnTime', 'OnTime', 0, 0, 30, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264460-0000-0000-0000-446000000008', '44444444-4444-4444-4444-444444444446', '2026-02-11', '2026-02-11 09:00:00', '2026-02-11 18:00:00', 9.00, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264460-0000-0000-0000-446000000009', '44444444-4444-4444-4444-444444444446', '2026-02-12', '2026-02-12 08:55:00', '2026-02-12 19:30:00', 10.58, 'OnTime', 'Overtime', 0, 0, 90, 'Month-end reporting', 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264460-0000-0000-0000-44600000000a', '44444444-4444-4444-4444-444444444446', '2026-02-13', '2026-02-13 09:00:00', '2026-02-13 18:00:00', 9.00, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264460-0000-0000-0000-44600000000b', '44444444-4444-4444-4444-444444444446', '2026-02-16', '2026-02-16 08:50:00', '2026-02-16 19:00:00', 10.17, 'OnTime', 'Overtime', 0, 0, 60, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264460-0000-0000-0000-44600000000c', '44444444-4444-4444-4444-444444444446', '2026-02-17', '2026-02-17 09:00:00', '2026-02-17 18:00:00', 9.00, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264460-0000-0000-0000-44600000000d', '44444444-4444-4444-4444-444444444446', '2026-02-18', '2026-02-18 08:55:00', '2026-02-18 18:00:00', 9.08, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264460-0000-0000-0000-44600000000e', '44444444-4444-4444-4444-444444444446', '2026-02-19', '2026-02-19 09:00:00', '2026-02-19 19:00:00', 10.00, 'OnTime', 'Overtime', 0, 0, 60, 'Team performance reviews', 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264460-0000-0000-0000-44600000000f', '44444444-4444-4444-4444-444444444446', '2026-02-20', '2026-02-20 09:00:00', '2026-02-20 18:00:00', 9.00, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264460-0000-0000-0000-446000000010', '44444444-4444-4444-4444-444444444446', '2026-02-23', '2026-02-23 08:50:00', '2026-02-23 18:30:00', 9.67, 'OnTime', 'OnTime', 0, 0, 30, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555552', NOW(), NOW()),
('b2264460-0000-0000-0000-446000000011', '44444444-4444-4444-4444-444444444446', '2026-02-24', '2026-02-24 09:00:00', NULL, NULL, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', NULL, NULL, NULL, '55555555-5555-5555-5555-555555555552', NOW(), NOW()),

-- Employee 445 (Lan Pham - hr_user, Morning 08:00-17:00)
('b2264450-0000-0000-0000-445000000001', '44444444-4444-4444-4444-444444444445', '2026-02-02', '2026-02-02 07:58:00', '2026-02-02 17:05:00', 9.12, 'OnTime', 'OnTime', 0, 0, 5, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555551', NOW(), NOW()),
('b2264450-0000-0000-0000-445000000002', '44444444-4444-4444-4444-444444444445', '2026-02-03', '2026-02-03 08:05:00', '2026-02-03 17:00:00', 8.92, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555551', NOW(), NOW()),
('b2264450-0000-0000-0000-445000000003', '44444444-4444-4444-4444-444444444445', '2026-02-04', '2026-02-04 08:00:00', '2026-02-04 17:00:00', 9.00, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555551', NOW(), NOW()),
('b2264450-0000-0000-0000-445000000004', '44444444-4444-4444-4444-444444444445', '2026-02-05', '2026-02-05 08:02:00', '2026-02-05 17:00:00', 8.97, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555551', NOW(), NOW()),
('b2264450-0000-0000-0000-445000000005', '44444444-4444-4444-4444-444444444445', '2026-02-06', '2026-02-06 08:22:00', '2026-02-06 17:00:00', 8.63, 'Late', 'OnTime', 22, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555551', NOW(), NOW()),
('b2264450-0000-0000-0000-445000000006', '44444444-4444-4444-4444-444444444445', '2026-02-09', '2026-02-09 07:55:00', '2026-02-09 17:05:00', 9.17, 'OnTime', 'OnTime', 0, 0, 5, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555551', NOW(), NOW()),
('b2264450-0000-0000-0000-445000000007', '44444444-4444-4444-4444-444444444445', '2026-02-10', '2026-02-10 08:00:00', '2026-02-10 17:00:00', 9.00, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555551', NOW(), NOW()),
('b2264450-0000-0000-0000-445000000008', '44444444-4444-4444-4444-444444444445', '2026-02-11', '2026-02-11 08:03:00', '2026-02-11 17:00:00', 8.95, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555551', NOW(), NOW()),
('b2264450-0000-0000-0000-445000000009', '44444444-4444-4444-4444-444444444445', '2026-02-12', '2026-02-12 08:00:00', '2026-02-12 16:30:00', 8.50, 'OnTime', 'EarlyLeave', 0, 30, 0, 'Child pickup', 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555551', NOW(), NOW()),
('b2264450-0000-0000-0000-44500000000a', '44444444-4444-4444-4444-444444444445', '2026-02-13', '2026-02-13 07:58:00', '2026-02-13 17:05:00', 9.12, 'OnTime', 'OnTime', 0, 0, 5, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555551', NOW(), NOW()),
('b2264450-0000-0000-0000-44500000000b', '44444444-4444-4444-4444-444444444445', '2026-02-16', '2026-02-16 08:01:00', '2026-02-16 17:00:00', 8.98, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555551', NOW(), NOW()),
('b2264450-0000-0000-0000-44500000000c', '44444444-4444-4444-4444-444444444445', '2026-02-17', '2026-02-17 08:00:00', '2026-02-17 17:00:00', 9.00, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555551', NOW(), NOW()),
('b2264450-0000-0000-0000-44500000000d', '44444444-4444-4444-4444-444444444445', '2026-02-18', '2026-02-18 08:05:00', '2026-02-18 17:00:00', 8.92, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555551', NOW(), NOW()),
('b2264450-0000-0000-0000-44500000000e', '44444444-4444-4444-4444-444444444445', '2026-02-19', '2026-02-19 07:57:00', '2026-02-19 17:00:00', 9.05, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555551', NOW(), NOW()),
('b2264450-0000-0000-0000-44500000000f', '44444444-4444-4444-4444-444444444445', '2026-02-20', '2026-02-20 08:00:00', '2026-02-20 17:00:00', 9.00, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555551', NOW(), NOW()),
('b2264450-0000-0000-0000-445000000010', '44444444-4444-4444-4444-444444444445', '2026-02-23', '2026-02-23 08:02:00', '2026-02-23 17:00:00', 8.97, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', 10.762622, 106.660172, 'TechCorp Office, District 1', '55555555-5555-5555-5555-555555555551', NOW(), NOW()),
('b2264450-0000-0000-0000-445000000011', '44444444-4444-4444-4444-444444444445', '2026-02-24', '2026-02-24 08:00:00', NULL, NULL, 'OnTime', 'OnTime', 0, 0, 0, NULL, 10.762622, 106.660172, 'TechCorp Office, District 1', NULL, NULL, NULL, '55555555-5555-5555-5555-555555555551', NOW(), NOW());

-- Leave Requests for 2026 (pending approvals for manager dashboard)
INSERT INTO "LeaveRequests" ("Id", "EmployeeId", "LeaveType", "StartDate", "EndDate", "TotalDays", "Reason", "Status", "FirstApproverId", "FirstApproverType", "FirstApprovedAt", "FirstApproverComment", "FirstApprovalStatus", "SecondApproverId", "SecondApproverType", "SecondApprovedAt", "SecondApproverComment", "SecondApprovalStatus", "RejectionReason", "Attachments", "CreatedAt", "UpdatedAt")
VALUES
-- Pending: emp 448 wants 1 day off Feb 27 (needs approval from manager 446)
('c2026001-0000-0000-0000-000000000001', '44444444-4444-4444-4444-444444444448', 'Annual', '2026-02-27', '2026-02-27', 1, 'Personal appointment', 'Pending', '44444444-4444-4444-4444-444444444446', 'Manager', NULL, NULL, 'Pending', '44444444-4444-4444-4444-444444444445', 'HR', NULL, NULL, 'Pending', NULL, NULL, '2026-02-24 08:00:00', NOW()),
-- Pending: emp 447 (team lead) wants 5 days in March (needs approval from manager 446)
('c2026001-0000-0000-0000-000000000002', '44444444-4444-4444-4444-444444444447', 'Annual', '2026-03-09', '2026-03-13', 5, 'Long-planned family vacation', 'Pending', '44444444-4444-4444-4444-444444444446', 'Manager', NULL, NULL, 'Pending', '44444444-4444-4444-4444-444444444445', 'HR', NULL, NULL, 'Pending', NULL, NULL, '2026-02-20 10:00:00', NOW()),
-- Pending: emp 455 wants 5 days in March (needs approval from manager 446)
('c2026001-0000-0000-0000-000000000003', '44444444-4444-4444-4444-444444444455', 'Annual', '2026-03-02', '2026-03-06', 5, 'Family trip to Da Nang', 'Pending', '44444444-4444-4444-4444-444444444446', 'Manager', NULL, NULL, 'Pending', '44444444-4444-4444-4444-444444444445', 'HR', NULL, NULL, 'Pending', NULL, NULL, '2026-02-23 14:00:00', NOW()),
-- Pending: emp 453 wants sick leave (needs approval from manager 447, who reports to 446)
('c2026001-0000-0000-0000-000000000004', '44444444-4444-4444-4444-444444444453', 'Sick', '2026-02-25', '2026-02-26', 2, 'Feeling unwell, need rest', 'Pending', '44444444-4444-4444-4444-444444444447', 'Manager', NULL, NULL, 'Pending', '44444444-4444-4444-4444-444444444445', 'HR', NULL, NULL, 'Pending', NULL, 'medical_note.pdf', '2026-02-24 07:30:00', NOW()),
-- Approved: emp 448 annual leave already approved (for history context)
('c2026001-0000-0000-0000-000000000005', '44444444-4444-4444-4444-444444444448', 'Annual', '2026-01-15', '2026-01-17', 3, 'Post-Tet break', 'Approved', '44444444-4444-4444-4444-444444444446', 'Manager', '2026-01-10 10:00:00', 'Approved, enjoy!', 'Approved', '44444444-4444-4444-4444-444444444445', 'HR', '2026-01-10 14:00:00', 'Approved', 'Approved', NULL, NULL, '2026-01-08 09:00:00', NOW());

-- Overtime Requests for 2026 (pending approvals for manager dashboard)
INSERT INTO "OvertimeRequests" ("Id", "EmployeeId", "Date", "StartTime", "EndTime", "TotalMinutes", "Reason", "Status", "ApproverId", "ApprovedAt", "ApproverComment", "CreatedAt", "UpdatedAt")
VALUES
-- Pending: emp 448 requesting OT tomorrow (ApproverId = manager 446)
('d2026001-0000-0000-0000-000000000001', '44444444-4444-4444-4444-444444444448', '2026-02-25', '18:00:00', '20:00:00', 120, 'Urgent feature release preparation', 'Pending', '44444444-4444-4444-4444-444444444446', NULL, NULL, '2026-02-24 17:00:00', NOW()),
-- Pending: emp 453 requesting OT this week
('d2026001-0000-0000-0000-000000000002', '44444444-4444-4444-4444-444444444453', '2026-02-26', '18:00:00', '21:00:00', 180, 'Critical bug hotfix before production deploy', 'Pending', '44444444-4444-4444-4444-444444444446', NULL, NULL, '2026-02-24 16:30:00', NOW()),
-- Pending: emp 455 requesting OT
('d2026001-0000-0000-0000-000000000003', '44444444-4444-4444-4444-444444444455', '2026-02-25', '18:00:00', '19:30:00', 90, 'UI regression testing before release', 'Pending', '44444444-4444-4444-4444-444444444446', NULL, NULL, '2026-02-24 15:00:00', NOW()),
-- Approved: emp 448 OT already approved this month (for history)
('d2026001-0000-0000-0000-000000000004', '44444444-4444-4444-4444-444444444448', '2026-02-05', '18:00:00', '19:30:00', 90, 'Sprint planning overflow', 'Approved', '44444444-4444-4444-4444-444444444446', '2026-02-05 17:30:00', 'Approved for sprint work', '2026-02-05 16:00:00', NOW()),
('d2026001-0000-0000-0000-000000000005', '44444444-4444-4444-4444-444444444448', '2026-02-13', '18:00:00', '20:00:00', 120, 'Feature completion before sprint review', 'Approved', '44444444-4444-4444-4444-444444444446', '2026-02-13 10:00:00', 'Critical deadline, approved', '2026-02-13 09:00:00', NOW()),
-- Approved: emp 446 (manager) OT approved by admin (444)
('d2026001-0000-0000-0000-000000000006', '44444444-4444-4444-4444-444444444446', '2026-02-05', '18:00:00', '20:00:00', 120, 'Sprint review preparation and metrics', 'Approved', '44444444-4444-4444-4444-444444444444', '2026-02-05 17:30:00', 'Approved', '2026-02-05 17:00:00', NOW());
