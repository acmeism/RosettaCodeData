CREATE FUNCTION [dbo].[fn_CheckSEDOL]
( @SEDOL varchar(50) )
RETURNS varchar(7)
AS
BEGIN
	declare	@true bit = 1,
		@false bit = 0,
		@isSEDOL bit,		
		@sedol_weights varchar(6) ='131739',
		@sedol_len int = LEN(@SEDOL),
		@sum int = 0
		
					
	if ((@sedol_len = 6))
	begin
		select @SEDOL = UPPER(@SEDOL)
		Declare	@vowels varchar(5) = 'AEIOU',
			@letters varchar(21) = 'BCDFGHJKLMNPQRSTVWXYZ',
			@i int=1,
			@isStillGood bit = @true,					
			@char char = '',
			@weighting int =0
					
		select @isSEDOL = @false

		while ((@i < 7) and (@isStillGood = @true))
		begin
			select	@char = SUBSTRING(@SEDOL,@i,1),
				@weighting = CONVERT (INT,SUBSTRING(@sedol_weights, @i, 1))
			if (CHARINDEX(@char, @vowels) > 0) -- no vowels please
			begin
				select @isStillGood=@false
			end
			else
			begin
				if (ISNUMERIC(@char) = @true) -- is a number
				begin
					select @sum = @sum + (ASCII(@char) - 48) * @weighting
				end
				else if (CHARINDEX(@char, @letters) = 0) -- test for the rest of the alphabet
				begin
					select @isStillGood=@false
				end
				else
				begin
					select @sum = @sum + (ASCII(@char) - 55) * @weighting
				end
			end
			select @i = @i +1
		end -- of while loop
		if (@isStillGood = @true)
		begin
			declare @checksum int = (10 - (@sum%10))%10
			select @SEDOL = @SEDOL + CONVERT(CHAR,@checksum)
		end
	end
	else
	begin
		select @SEDOL = ''
	end
	-- Return the result of the function
	RETURN @SEDOL
END
