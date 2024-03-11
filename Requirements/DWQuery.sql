CREATE TABLE dimLesson(
    SK_Lesson_ID int PRIMARY KEY,
    Topic varchar(40),
    Subject_name varchar(40) NOT NULL,
    Teacher_ID int NOT NULL
);

CREATE TABLE dimStudent(
    SK_Student_ID INTEGER IDENTITY(1,1) PRIMARY KEY,
	BK_Student int,
    Name varchar(20),
    Surname varchar(20),
    Class varchar(2) NOT NULL,
	IfCurrent bit
);

CREATE TABLE Time(
    Time_ID int PRIMARY KEY,
    Hour int NOT NULL,
    Minute int
);

CREATE TABLE Date(
    Date_ID int PRIMARY KEY,
	Date date,
    Year int,
    Month int NOT NULL,
    Day int NOT NULL
);

CREATE TABLE dimGrade(
    SK_Grade_ID int PRIMARY KEY,
    Date_of_submission date,
    Type varchar(10),
    );

CREATE TABLE dimAttendance(
    SK_Attendance_ID INTEGER IDENTITY(1,1) PRIMARY KEY,
    Attendance_Type varchar(10) NOT NULL,
    Reason_name varchar(40) NOT NULL
    );

CREATE TABLE dimEvent(
    SK_Event_ID int PRIMARY KEY,
    Event_Type varchar(20) NOT NULL, 
    Location varchar(20) NOT NULL,
    Country varchar(20),
    Region varchar(20),
    Date date
    );

CREATE TABLE Fact_of_attendance(
    Date_ID int REFERENCES Date ON UPDATE CASCADE NOT NULL,
    Time_ID int REFERENCES Time ON UPDATE CASCADE NOT NULL,
    SK_Grade_ID int REFERENCES dimGrade ON UPDATE CASCADE NOT NULL,
    SK_Event_ID int REFERENCES dimEvent ON UPDATE CASCADE NOT NULL,
    SK_Student_ID int REFERENCES dimStudent ON UPDATE CASCADE NOT NULL,
    SK_Attendance_ID int REFERENCES dimAttendance ON UPDATE CASCADE NOT NULL,
    SK_Lesson_ID int REFERENCES dimLesson ON UPDATE CASCADE NOT NULL,
    Minutes_of_tardiness int,
    PRIMARY KEY (Date_ID, Time_ID, SK_Grade_ID, SK_Event_ID, SK_Student_ID, SK_Attendance_ID, SK_Lesson_ID)
);

drop table Fact_of_attendance;
drop table dimStudent;
drop table Date;
drop table dimGrade;
drop table dimAttendance;
drop table dimLesson;
drop table dimEvent;
drop table time;


ALTER TABLE School.dbo.Attendance
DROP COLUMN Attendance_ID

/*UPDATE School.dbo.Attendance
SET FK_Reason_ID = -1
WHERE Type = 'Present';

INSERT INTO School.dbo.Reasons (Reasons_ID, Reasons_name)
VALUES (-1, 'Unknown')*/

