Use SchoolDW
go
If (object_id('FactView') is not null) DROP VIEW FactView;
go
CREATE VIEW FactView AS
SELECT
	Date.Date_ID,
	Time.Time_ID,
	dimGrade.SK_Grade_ID,
	SK_Event_ID = -1,
	dimStudent.SK_Student_ID,
	dimAttendance.SK_Attendance_ID,
	dimLesson.SK_Lesson_ID,
	Minutes_of_tardiness = Time.Minute
FROM School.dbo.Attendance AS T1
JOIN dimStudent ON BK_Student = Student_ID --Student ale to SCD2 wiê BK
JOIN Date ON Date.Date = T1.Date -- Date
JOIN dimLesson ON SK_Lesson_ID = T1.Lesson_ID --Lesson
JOIN School.dbo.Reasons AS T2 ON Reasons_ID = T1.FK_Reason_ID --merge ¿eby za³adowaæ Attendance Junk
JOIN dimAttendance ON Attendance_Type = T1.Type AND Reason_name = T2.Reasons_name
JOIN School.dbo.Students AS T3 ON T3.Student_ID = T1.Student_ID -- merge ¿eby za³adowaæ Grade
JOIN School.dbo.Grades AS T4 ON T4.FK_Student_ID = T3.Student_ID
JOIN dimGrade ON SK_Grade_ID = T4.Grade_ID
JOIN Time ON Time.TimeCol = T1.Hour -- Time

;
go
--SELECT * FROM FactView;

If (object_id('NewView') is not null) DROP VIEW NewView;
go
CREATE VIEW NewView AS
SELECT
	N1 = Date.Date_ID,
	N2 = -1,
	N3 = -1,
	N4 = dimEvent.SK_Event_ID,
	N5 = S.SK_Student_ID,
	N6 = SK_Attendance_ID,
	N7 = -1
FROM EventTemp AS E
JOIN Date ON Date.Date = E.Date
JOIN dimEvent ON SK_Event_ID = E.Event_ID
JOIN School.dbo.Reasons AS R ON R.Reasons_ID = E.Reason_ID
JOIN dimAttendance AS A ON A.Attendance_Type='Absent' AND A.Reason_name = R.Reasons_name
JOIN dimStudent AS S ON S.BK_Student = E.STudents_ID
go
--SELECT * FROM NewView;

Merge Into SchoolDW.dbo.Fact_of_attendance as TargetTable
	Using FactView as SourceTable
	 On TargetTable.Date_ID = SourceTable.Date_ID AND TargetTable.Time_ID = SourceTable.Time_ID 
	 AND TargetTable.SK_Grade_ID = SourceTable.SK_Grade_ID AND TargetTable.SK_Event_ID = SourceTable.SK_Event_ID 
	 AND TargetTable.SK_Student_ID = SourceTable.SK_Student_ID AND TargetTable.SK_Attendance_ID = SourceTable.SK_Attendance_ID
	 AND TargetTable.SK_Lesson_ID = SourceTable.SK_Lesson_ID
	  When Not Matched
	   Then
		INSERT
		Values ( SourceTable.Date_ID,
			    SourceTable.Time_ID,
				SourceTable.SK_Grade_ID,
				SourceTable.SK_Event_ID,
				SourceTable.SK_Student_ID,
				SourceTable.SK_Attendance_ID,
				SourceTable.SK_Lesson_ID,
				SourceTable.Minutes_of_tardiness)
	  When Matched
		AND (SourceTable.Minutes_of_tardiness <> TargetTable.Minutes_of_tardiness)
	  Then 
		UPDATE
		SET TargetTable.Minutes_of_tardiness = SourceTable.Minutes_of_tardiness 
;
go

Merge Into SchoolDW.dbo.Fact_of_attendance as TargetTable
	Using NewView as SourceTable
	 On TargetTable.Date_ID = SourceTable.N1 AND TargetTable.Time_ID = SourceTable.N2 
	 AND TargetTable.SK_Grade_ID = SourceTable.N3 AND TargetTable.SK_Event_ID = SourceTable.N4 
	 AND TargetTable.SK_Student_ID = SourceTable.N5 AND TargetTable.SK_Attendance_ID = SourceTable.N6
	 AND TargetTable.SK_Lesson_ID = SourceTable.N7
	  When Not Matched
	   Then
		INSERT
		Values (SourceTable.N1,
			    SourceTable.N2,
				SourceTable.N3,
				SourceTable.N4,
				SourceTable.N5,
				SourceTable.N6,
				SourceTable.N7,
				NULL)
;
go

--SELECT * FROM Fact_of_attendance ORDER BY SK_Event_ID;
--SELECT COUNT(*) FROM Fact_of_attendance;
--SELECT COUNT(*) FROM FactView;