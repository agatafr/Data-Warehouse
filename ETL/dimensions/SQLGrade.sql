use SchoolDW
go

--Grade View
If (object_id('GradeView') is not null) DROP VIEW GradeView;
go
CREATE VIEW GradeView AS
SELECT Grade_ID, Date_of_submission, Type
FROM [School].dbo.Grades
go

--SELECT * FROM GradeView;

--Grade Dimension
Merge Into SchoolDW.dbo.dimGrade as TargetTable
	Using GradeView as SourceTable
	 On TargetTable.SK_Grade_ID = SourceTable.Grade_ID
	  When Not Matched
	   Then
		INSERT
		Values ( SourceTable.Grade_ID,
			    SourceTable.Date_of_submission,
				SourceTable.Type )
	  When Matched
		AND (SourceTable.Date_of_submission <> TargetTable.Date_of_submission
		OR SourceTable.Type <> TargetTable.Type)
	  Then 
		UPDATE
		SET TargetTable.Date_of_submission = SourceTable.Date_of_submission, 
			TargetTable.Type = SourceTable.Type
	  When Not Matched By Source AND TargetTable.SK_Grade_ID <> -1
		THEN
			DELETE
;
go

--Select * FROM dimGrade;