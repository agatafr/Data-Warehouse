USE SchoolDW
GO

INSERT INTO dbo.dimAttendance (Attendance_Type, Reason_name)
SELECT t, r
FROM (
    VALUES 
        ('Present'),
        ('Tardy'),
        ('Absent')
) AS Attendance_Type(t)
CROSS JOIN (
    VALUES 
        ('Unknown'),
        ('Unexcused'),
        ('Illness'),
        ('Medical/Dental appointments'),
        ('Sporting events'),
        ('Drivers license test.'),
        ('Serious family emergency'),
        ('Special requests from parents'),
        ('Family vacation'),
        ('Religious instruction')
) AS Reason_name(r)
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.dimAttendance
    WHERE Attendance_Type = t AND Reason_name = r
);