use SchoolDW
go

--Student View
If (object_id('StudentView') is not null) DROP VIEW StudentView;
go
CREATE VIEW StudentView AS
SELECT Student_ID, Students.Name, Surname, Class.Name AS Class
FROM [School].dbo.Students
JOIN [School].[dbo].Class ON Class.Class_ID = Students.FK_Class_ID
go

--Student Dimension
Merge Into SchoolDW.dbo.dimStudent as TargetTable
	Using StudentView as SourceTable
	 On TargetTable.BK_Student = SourceTable.Student_ID
	  When Not Matched
	   Then
		INSERT
		Values (SourceTable.Student_ID,
			    SourceTable.Name,
				SourceTable.Surname,
				SourceTable.Class,
				1)
	  When Matched
		AND (SourceTable.Name <> TargetTable.Name
		OR SourceTable.Surname <> TargetTable.Surname
		OR SourceTable.Class <> TargetTable.Class)
	  Then 
		UPDATE
		SET TargetTable.IfCurrent = 0
	  When Not Matched By Source AND TargetTable.SK_Student_ID <> -1
	  THEN
		UPDATE
		SET TargetTable.IfCurrent = 0
;
go

INSERT INTO dimStudent
SELECT Student_ID, Name, Surname, Class, 1 FROM StudentView
EXCEPT
SELECT BK_Student, Name, Surname, Class, 1 FROM dimStudent

