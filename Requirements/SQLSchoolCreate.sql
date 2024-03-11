CREATE TABLE Class(
	Class_ID int PRIMARY KEY,
	Name varchar(2) NOT NULL,
	Profile varchar(30) CHECK(Profile NOT LIKE '%[0-9@#$$&_!]%'),
	Starting_year int CHECK((Starting_year BETWEEN 1970 AND YEAR(GETDATE()))) NOT NULL,
	CONSTRAINT check_name
		CHECK (Name LIKE '[1-4][A-Z]'),
	CONSTRAINT unique_name_on_year
        UNIQUE (Name, Starting_year)
	);
	
CREATE TABLE Reasons(
	Reasons_ID int PRIMARY KEY,
	Reasons_name varchar(40) CHECK(Reasons_name NOT LIKE '%[0-9@#$$&_!]%') NOT NULL
	);

CREATE TABLE Teachers(
	Teacher_ID int PRIMARY KEY,
	Name varchar(20) CHECK(Name NOT LIKE '%[0-9@#$$&_!]%') NOT NULL,
	Surname varchar(20) CHECK(Surname NOT LIKE '%[0-9@#$$&_!]%') NOT NULL,
	Date_of_birth date CHECK (Date_of_birth BETWEEN CAST(DATEADD(year, -75, GETDATE()) as date) AND CAST(DATEADD(year, -22, GETDATE()) as date)),
	);	

CREATE TABLE Subject(
	Subject_ID int PRIMARY KEY,
	Subject_name varchar(40) CHECK(Subject_name NOT LIKE '%[0-9@#$$&_!]%') NOT NULL,
	);

CREATE TABLE Lesson(
	Lesson_ID int PRIMARY KEY,
	Topic varchar(40) CHECK(Topic NOT LIKE '%[0-9@#$$&_!]%'),
	FK_Class_ID int REFERENCES Class ON UPDATE CASCADE NOT NULL,
	FK_Teacher_ID int REFERENCES Teachers  ON UPDATE CASCADE NOT NULL,
	FK_Subject_ID int REFERENCES Subject  ON UPDATE CASCADE NOT NULL,
	);

CREATE TABLE Students(
	Student_ID int PRIMARY KEY,
	Name varchar(20) CHECK(Name NOT LIKE '%[0-9@#$$&_!]%') NOT NULL,
	Surname varchar(20) CHECK(Surname NOT LIKE '%[0-9@#$$&_!]%') NOT NULL,
	Date_of_birth date CHECK (Date_of_birth BETWEEN CAST(DATEADD(year, -150, GETDATE()) as date) AND CAST(DATEADD(year, -15, GETDATE()) as date)) NOT NULL,
	FK_Class_ID int REFERENCES Class ON UPDATE CASCADE NOT NULL
	);

CREATE TABLE Attendance(
	Student_ID int REFERENCES Students,
	Lesson_ID int REFERENCES Lesson,
	Date date CHECK((YEAR(Date) BETWEEN 1900 AND YEAR(GETDATE()))),
	Hour time CHECK((DATEPART(HOUR, Hour) BETWEEN 7 AND 19)),
	Type varchar(10) CHECK(Type in('Present','Absent','Tardy'))NOT NULL,
	FK_Reason_ID int REFERENCES Reasons ON UPDATE CASCADE,
	PRIMARY KEY (Student_ID, Lesson_ID, Date, Hour),
	CONSTRAINT check_date
		CHECK (MONTH(Date) NOT IN (7, 8)),
	CONSTRAINT check_weekend
		CHECK (DATENAME(WEEKDAY, Date) NOT IN ('Saturday', 'Sunday')),
	CONSTRAINT check_absent_reason
		CHECK ((Type != 'Absent') OR (Type = 'Absent' AND FK_Reason_ID IS NOT NULL))
	);

CREATE TABLE Grades(
	Grade_ID int PRIMARY KEY,
	Mark int CHECK (Mark BETWEEN 1 AND 6),
	Date_of_submission date CHECK((YEAR(Date_of_submission) BETWEEN 1900 AND YEAR(GETDATE()))),
	Type varchar(10) CHECK(Type in('Semestral','Final')),
	FK_Subject_ID int REFERENCES Subject ON UPDATE CASCADE NOT NULL,
	FK_Teacher_ID int REFERENCES Teachers ON UPDATE CASCADE NOT NULL,
	FK_Student_ID int REFERENCES Students ON UPDATE CASCADE NOT NULL,
	CONSTRAINT check_date_of_submission
		CHECK (MONTH(Date_of_submission) NOT IN (7, 8)),
	);	

DROP TABLE Grades;
DROP TABLE Attendance;
DROP TABLE Students;
DROP TABLE Lesson;
DROP TABLE Class;
DROP TABLE Subject;
DROP TABLE Teachers;
DROP TABLE Reasons;


SELECT COUNT(*) AS All_Classes FROM Class ;
SELECT COUNT(*) AS All_Reasons FROM Reasons;
SELECT COUNT(*) AS All_Teachers FROM Teachers;
SELECT COUNT(*) AS All_Subjects FROM Subject;
SELECT COUNT(*) AS All_Attendances FROM Attendance;
SELECT COUNT(*) AS All_Lessons FROM Lesson;
SELECT COUNT(*) AS All_Students FROM Students;
SELECT COUNT(*) AS All_Grades FROM Grades;

SELECT * FROM Teachers;
SELECT * FROM Students WHERE Student_ID >= 109998;
SELECT * FROM Attendance WHERE Student_ID >= 109998;

SELECT * FROM Attendance WHERE Type = 'Tardy';