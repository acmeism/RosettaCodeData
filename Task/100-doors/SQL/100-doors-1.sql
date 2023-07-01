DECLARE	@sqr int,
		@i int,
		@door int;
		
SELECT @sqr =1,
	@i = 3,
	@door = 1;	
				
WHILE(@door <=100)
BEGIN
	IF(@door = @sqr)
	BEGIN
		PRINT 'Door ' + RTRIM(CAST(@door as char)) + ' is open.';
		SET @sqr= @sqr+@i;
		SET @i=@i+2;
	END
	ELSE
	BEGIN
		PRINT 'Door ' + RTRIM(CONVERT(char,@door)) + ' is closed.';
	END
SET @door = @door + 1
END
	
