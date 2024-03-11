USE SchoolDW;
GO

-- Fill DimDates Lookup Table
-- Step a: Declare variables use in processing
DECLARE @StartDate date; 
DECLARE @EndDate date;
DECLARE @DateID int = 1;

-- Step b:  Fill the variable with values for the range of years needed
SELECT @StartDate = '1899-12-31', @EndDate = '2023-05-11';

-- Step c:  Use a while loop to add dates to the table
DECLARE @DateInProcess datetime = @StartDate;

WHILE @DateInProcess <= @EndDate
BEGIN
    -- Add a row into the date dimension table for this date
    IF NOT EXISTS (
        SELECT 1
        FROM [dbo].[Date]
        WHERE [Date] = @DateInProcess
    )
    BEGIN
        INSERT INTO [dbo].[Date] 
        ( [Date_ID]
        , [Date]
        , [Year]
        , [Month]
        , [Day]
        )
        VALUES ( 
          @DateID --[Date_ID]
          , @DateInProcess -- [Date]
          , CAST(YEAR(@DateInProcess) AS varchar(4)) -- [Year]
          , CAST(MONTH(@DateInProcess) AS int) -- [MonthNo]
          , CAST(DATEPART(day, @DateInProcess) AS int) -- [DayOfMonthNo]
        );  
        -- Add a day and loop again
        SET @DateID = @DateID +1;
    END
    SET @DateInProcess = DateAdd(d, 1, @DateInProcess);
END
GO