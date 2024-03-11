USE SchoolDW
GO

--Event temporary table for bulk loading
If (object_id('dbo.EventTemp') is not null) DROP TABLE dbo.EventTemp;
CREATE TABLE dbo.EventTemp( Students_ID int,
    Class_ID int, 
    Event_ID int,
    Date date,
    Country varchar(20),
    Region varchar(20),
	Location varchar(20),
	Type varchar(20),
	Reason_ID int);
go

BULK INSERT dbo.EventTemp
    FROM 'C:\Users\agata\Desktop\STUDIA\SEMESTR 4\Data Warehouse\ETL\dimensions\AttendanceExcel.csv'
    WITH
    (
    FIRSTROW = 2,
	DATAFILETYPE = 'char',
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
    )

--SELECT * FROM dbo.EventTemp;

--Event View
If (object_id('EventView') is not null) Drop View EventView;
go
CREATE VIEW EventView
AS
SELECT 
	Event_ID, Type, Location, Country, Region, Date
FROM dbo.EventTemp
;
go

--SELECT * FROM EventView;

--EVent Dimension
Merge Into SchoolDW.dbo.dimEvent as TargetTable
	Using EventView as SourceTable
	 On TargetTable.SK_Event_ID = SourceTable.Event_ID
	  When Not Matched
	   Then
		INSERT
		Values ( SourceTable.Event_ID,
				SourceTable.Type,
				SourceTable.Location,
				SourceTable.Country,
				SourceTable.Region,
				SourceTable.Date)
	  When Matched
		AND (SourceTable.Type <> TargetTable.Event_Type
		OR SourceTable.Location <> TargetTable.Location
		OR SourceTable.Country <> TargetTable.Country
		OR SourceTable.Region <> TargetTable.Region
		OR SourceTable.Date <> TargetTable.Date)
	  Then 
		UPDATE
		SET TargetTable.Event_Type = SourceTable.Type, 
			TargetTable.Location = SourceTable.Location,
			TargetTable.Country = SourceTable.Country,
			TargetTable.Region = SourceTable.Region,
			TargetTable.Date = SourceTable.Date
	  When Not Matched By Source AND TargetTable.SK_Event_ID <> -1
		THEN
			DELETE
;
go

--Select * FROM dimEvent;