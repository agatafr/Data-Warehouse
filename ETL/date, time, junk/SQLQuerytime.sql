DECLARE @hour INT = 0
DECLARE @minute INT = 0
DECLARE @TimeID INT = 1;

WHILE @hour < 24
BEGIN
  WHILE @minute < 60
  BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.Time
        WHERE Hour = @hour AND Minute = @minute
    )
    BEGIN
        INSERT INTO dbo.Time(Time_ID, Hour, Minute) 
        VALUES (@TimeID, @hour, @minute);
        SET @TimeID = @TimeID +1;
    END
    SET @minute = @minute + 1;
  END
  SET @hour = @hour + 1;
  SET @minute = 0;
END