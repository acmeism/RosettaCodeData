DECLARE @i INT = 0;
DECLARE @str VarChar(40) = '';
WHILE @i<10
  BEGIN
    SET @i = @i + 1;
    SET @str = @str + CONVERT(varchar(2),@i);
    IF @i % 5 = 0
      BEGIN
        PRINT @str;
        SET @str =''
        CONTINUE;
      END
    SET @str = @str +', ';
  END;
