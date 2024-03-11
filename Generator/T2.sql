INSERT INTO Students (Student_ID, Name, Surname, Date_of_birth, FK_Class_ID) VALUES (110001, 'Jasmine', 'Cook', '2007-03-01', '2292')
INSERT INTO Students (Student_ID, Name, Surname, Date_of_birth, FK_Class_ID) VALUES (110002, 'Luke', 'Lee', '2006-01-13', '1697')
INSERT INTO Students (Student_ID, Name, Surname, Date_of_birth, FK_Class_ID) VALUES (110003, 'Maya', 'Allen', '2006-03-02', '3055')
INSERT INTO Students (Student_ID, Name, Surname, Date_of_birth, FK_Class_ID) VALUES (110004, 'Aria', 'Austin', '2006-02-07', '3321')
INSERT INTO Students (Student_ID, Name, Surname, Date_of_birth, FK_Class_ID) VALUES (110005, 'Abigail', 'Ramirez', '2006-01-20', '3055')

INSERT INTO Attendance (Student_ID, Lesson_ID, Date, Hour, Type, FK_Reason_ID) VALUES (110001, '7355', '2023-03-22', '2023-03-22 12:00:00', 'Absent', '4')
INSERT INTO Attendance (Student_ID, Lesson_ID, Date, Hour, Type, FK_Reason_ID) VALUES (110002, '199144', '2023-03-22', '2023-03-22 11:00:00', 'Present', NULL)
INSERT INTO Attendance (Student_ID, Lesson_ID, Date, Hour, Type, FK_Reason_ID) VALUES (110003, '125599', '2023-03-22', '2023-03-22 14:00:00', 'Present', NULL)
INSERT INTO Attendance (Student_ID, Lesson_ID, Date, Hour, Type, FK_Reason_ID) VALUES (110004, '118700', '2023-03-22', '2023-03-22 13:00:00', 'Present', NULL)
INSERT INTO Attendance (Student_ID, Lesson_ID, Date, Hour, Type, FK_Reason_ID) VALUES (110005, '156191', '2023-03-22', '2023-03-22 15:00:00', 'Tardy', NULL)
INSERT INTO Attendance (Student_ID, Lesson_ID, Date, Hour, Type, FK_Reason_ID) VALUES (110001, '92688', '2023-03-22', '2023-03-22 16:00:00', 'Present', NULL)
INSERT INTO Attendance (Student_ID, Lesson_ID, Date, Hour, Type, FK_Reason_ID) VALUES (110002, '10582', '2023-03-23', '2023-03-23 13:00:00', 'Present', NULL)
INSERT INTO Attendance (Student_ID, Lesson_ID, Date, Hour, Type, FK_Reason_ID) VALUES (110003, '182713', '2023-03-22', '2023-03-22 10:00:00', 'Tardy', NULL)
INSERT INTO Attendance (Student_ID, Lesson_ID, Date, Hour, Type, FK_Reason_ID) VALUES (110003, '172880', '2023-03-23', '2023-03-23 09:00:00', 'Present', NULL)
INSERT INTO Attendance (Student_ID, Lesson_ID, Date, Hour, Type, FK_Reason_ID) VALUES (110004, '26313', '2023-03-22', '2023-03-22 13:00:00', 'Present', NULL)
INSERT INTO Attendance (Student_ID, Lesson_ID, Date, Hour, Type, FK_Reason_ID) VALUES (110005, '96662', '2023-03-23', '2023-03-23 10:00:00', 'Absent', '2')

UPDATE Students
SET FK_Class_ID = 234
WHERE Student_ID = 1;

UPDATE Teachers
SET Surname = 'Miller'
WHERE Teacher_ID = 3;

UPDATE Attendance
SET Type = 'Present'
WHERE Student_ID=110000 AND Lesson_ID= 111064

