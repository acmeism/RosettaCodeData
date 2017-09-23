DECLARE @i INT = 1024;
WHILE @i >0
BEGIN
    PRINT @i;
    SET @i = @i / 2;
END;
