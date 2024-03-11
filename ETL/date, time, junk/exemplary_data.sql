INSERT INTO dimLesson (SK_Lesson_ID, Topic, Subject_name, Teacher_ID) 
VALUES
(-1, '-1', '-1', -1);

INSERT INTO dimStudent (SK_Student_ID, Name, Surname, Class)
VALUES
(-1, '-1', '-1', '-1');
INSERT INTO Date (Date_ID, Date, Year, Month, Day)
VALUES
(-1, NULL, -1, -1, -1);
INSERT INTO dimGrade (SK_Grade_ID, Date_of_submission, Type)
VALUES
(-1, NULL, '-1');
INSERT INTO dimAttendance (SK_Attendance_ID, Attendance_Type, Reason_name, BK_Lesson_ID, BK_Student_ID, BK_Date, BK_Hour, IfCurrent)
VALUES
(-1, '-1', '-1', -1, -1, NULL, NULL, -1);
INSERT INTO dimEvent (SK_Event_ID, Event_Type, Location, Country, Region, Date)
VALUES
(-1, '-1', '-1', '-1', '-1', NULL);
INSERT INTO Time (Time_ID, Hour, Minute)
VALUES
(-1, -1, -1);

SELECT * FROM dimLesson;
SELECT * FROM dimStudent;
SELECT * FROM dimGrade;
SELECT * FROM dimAttendance;
SELECT * FROM dimEvent;




