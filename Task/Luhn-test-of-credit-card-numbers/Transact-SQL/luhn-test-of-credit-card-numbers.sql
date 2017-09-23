CREATE FUNCTION dbo._CreditCardNumCheck( @strCCNum VarChar(40) )
RETURNS VarChar(7)
AS
BEGIN
	DECLARE @string			VarChar(40) = REVERSE(@strCCNum); -- usage: set once, never changed
	DECLARE @strS2Values		VarChar(10) = '0246813579';  -- constant: maps digits to their S2 summed values
	DECLARE @table			TABLE (ID INT, Value INT, S_Value INT); -- ID=digit position. S_Value is used for SUM().
	DECLARE @p			INT = 0; -- loop counter: position in string
	-- Convert the reversed string's digits into rows in a table variable, S_Values to be updated afterwards
	WHILE @p < LEN(@string)
		BEGIN
			SET @p = @p+1;
			INSERT INTO @table (ID,Value,S_Value) VALUES (@p, CONVERT(INT,SUBSTRING(@string,@p,1)), 0);
		END
	-- Update S_Value column : the digit's value to be summed (for even-positioned digits this is mapped via @strS2Values)
	UPDATE @table SET S_Value = CASE WHEN ID % 2 = 1 THEN Value ELSE CONVERT(INT,SUBSTRING(@strS2Values,Value+1,1)) END
	-- If the SUM of S_Values ends in 0 (modulo 10 = 0) then the CC Number is valid
	RETURN CASE WHEN (SELECT SUM(S_Value) FROM @table) % 10 = 0 THEN 'Valid' ELSE 'Invalid' END
END
