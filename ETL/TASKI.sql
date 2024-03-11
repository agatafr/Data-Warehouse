/*TEST CASE 1
- Load T1 snapshot to the source db/file.
- Run ETL.
- Check if the number of rows in fact tables corresponds to the number of related rows in the sources.
- Run ETL again and check if rows in the fact table were not duplicated (there is still the same number of facts and corresponding source rows).*/

SELECT COUNT(*) as dimEvent FROM dimEvent;
SELECT COUNT(*) as Event FROM EventTemp;
SELECT COUNT(*) as dimGrade FROM dimGrade;
SELECT COUNT(*) as Grade FROM School.dbo.Grades;
SELECT COUNT(*) as dimLesson FROM dimLesson;
SELECT COUNT(*) as Lesson FROM School.dbo.Lesson;
SELECT COUNT(*) as dimStudent FROM dimStudent;
SELECT COUNT(*) as Student FROM School.dbo.Students;

/*TEST CASE 2
- Load T2 snapshot to the source db/file.
- Run ETL.
- Check if the number of rows in fact tables corresponds to the number of related rows in the sources.*/

INSERT INTO school.dbo.Grades (Grade_ID, Mark, Date_of_submission, Type, FK_Subject_ID, FK_Teacher_ID, FK_Student_ID)
VALUES (193550, 1, '2023-05-10', 'Final', 1, 1, 1)
INSERT INTO school.dbo.Students (Student_ID, Name, Surname, Date_of_birth, FK_Class_ID)
VALUES (110001, 'Julita', 'Bussler', '2003-05-03', 1)
INSERT INTO school.dbo.Lesson (Lesson_ID, Topic, FK_Class_ID, FK_Teacher_ID, FK_Subject_ID)
VALUES (200001, 'Introduction', 1, 1, 1)
--Visual ETL load
SELECT COUNT(*) FROM School.dbo.Grades;
SELECT COUNT(*) FROM School.dbo.Students;
SELECT COUNT(*) FROM School.dbo.Lesson; 
SELECT COUNT(*) FROM dimGrade;
SELECT COUNT(*) FROM dimStudent;
SELECT COUNT(*) FROM dimLesson; 

/*TEST CASE 3
- Load T2 snapshot to the source db/file.
- Run ETL.
- Check if the new row is added to the SCD2 dimension.
- Check if the old row is updated (experiation date is added or isCurrent is set to 0).
- Run ETL once again and check if there was no change in the DW.*/

INSERT INTO School.dbo.Students VALUES (110002, 'Tom', 'Riddle', '1970-07-30', 15);
--Visual ETL load
UPDATE School.dbo.Students
SET Surname = 'Smith'
WHERE Student_ID = 110002;
--Visual ETL load
Select * FROM dimStudent
WHERE BK_Student = 110002;

/*TEST CASE 4
- Update the entity in the source. This entity should be the one that is being loaded to the dimension with SCD2.
- Add new fact to the SOURCE that would refer to the updated entity
- run ETL.
- Check if the new fact in DW is referring to the updated dimension row */

Select * FROM dimStudent
WHERE BK_Student = 2;

UPDATE School.dbo.Students
SET Name = 'Tamara', Surname = 'Lisbon'
WHERE Student_ID = 2;

INSERT INTO School.dbo.Attendance (Student_ID, Lesson_ID, Date, Hour, Type, FK_Reason_ID) VALUES (2, 111143, '2000-05-25', '12:05:00', 'Tardy', '9');
--Visual ETL load
Select * FROM Fact_of_attendance WHERE SK_Student_ID = 110007 ORDER BY SK_Event_ID;
Select * FROM School.dbo.Attendance WHERE Student_ID=2;

/*TEST CASE 5
- Process the cube. See if it finishes without any errors.*/

-------------------IN VISUAL STUIDO 2019

/*TEST CASE 6
- Add new fact to the SOURCE that wouldn't refer to any entity from one chosen dimension
- Run ETL.
- Check if 'UNKNOWN' row is being referred by this new fact in the DW.*/

-----------The data was already visible in the tables