use SchoolDW
go

--Lesson View
If (object_id('LessonView') is not null) DROP VIEW LessonView;
go
CREATE VIEW LessonView AS
SELECT Lesson_ID, Topic, Subject_name, FK_Teacher_ID
FROM [School].dbo.Lesson
JOIN [School].[dbo].Subject ON Lesson.FK_Subject_ID = Subject.Subject_ID
go

--SELECT * FROM LessonView;

--Lesson Dimension
Merge Into SchoolDW.dbo.dimLesson as TargetTable
    Using LessonView as SourceTable
     On TargetTable.SK_Lesson_ID = SourceTable.Lesson_ID
      When Not Matched
       Then
        INSERT
        VALUES( SourceTable.Lesson_ID,
                SourceTable.Topic,
                SourceTable.Subject_name, 
                SourceTable.FK_Teacher_ID)
      When Matched
        AND (SourceTable.Topic <> TargetTable.Topic
        OR SourceTable.FK_Teacher_ID <> TargetTable.Teacher_ID
        OR  SourceTable.Subject_name <> TargetTable.Subject_name)
      Then 
        UPDATE
        SET TargetTable.Topic = SourceTable.Topic, 
            TargetTable.Teacher_ID = SourceTable.FK_Teacher_ID,
            TargetTable.Subject_name =  SourceTable.Subject_name
      When Not Matched By Source AND TargetTable.SK_Lesson_ID <> -1
        THEN
           DELETE
;
go

--Select * FROM dimLesson;