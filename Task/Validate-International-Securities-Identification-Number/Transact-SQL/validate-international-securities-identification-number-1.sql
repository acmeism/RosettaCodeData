CREATE FUNCTION dbo._ISINCheck( @strISIN VarChar(40) )
RETURNS bit
AS
BEGIN
--*** Test an ISIN code and return 1 if it is valid, 0 if invalid.
DECLARE @bValid	 bit;

SET @bValid = CASE WHEN @strISIN LIKE '[A-Z][A-Z][A-Z,0-9][A-Z,0-9][A-Z,0-9][A-Z,0-9][A-Z,0-9][A-Z,0-9][A-Z,0-9][A-Z,0-9][A-Z,0-9][0-9]' THEN 1 ELSE 0 END
IF @bValid = 1
	BEGIN
		DECLARE @strTest VarChar(40) = '';
		DECLARE @strAdd  VarChar(2);
		DECLARE @p INT = 0;
		WHILE @p < LEN(@strISIN)
			BEGIN
				SET @p = @p+1;
				SET @strAdd = SUBSTRING(@strISIN,@p,1);
				IF @strAdd LIKE '[A-Z]' SET @strAdd = CONVERT(VarChar(2),ASCII(UPPER(@strAdd))-55);
				SET @strTest = @strTest + @strAdd;
			END;

		-- Proceed with Luhn test
		DECLARE @strLuhn VarChar(40) = REVERSE(@strTest); -- usage: set once, never changed
		DECLARE @strS2Values VarChar(10) = '0246813579';  -- constant: maps digits to their S2 summed values
		SET @p = 0; -- reset loop counter
		DECLARE @intValue INT;
		DECLARE @intSum	INT = 0;
		-- loop through the reversed string, get the value (even-positioned digits are mapped) and add it to @intSum
		WHILE @p < LEN(@strLuhn)
			BEGIN
				SET @p = @p+1;
				SET @intValue = CONVERT(INT, SUBSTRING(@strLuhn,@p,1) ) -- value of the digit at position @p in the string
				IF @p % 2 = 0	SET @intValue = CONVERT(INT,SUBSTRING(@strS2Values,@intValue+1,1))
				SET @intSum = @intSum + @intValue
			END
		-- If the of the digits' mapped values ends in 0 (modulo 10 = 0) then the Luhn test succeeds
		SET @bValid = CASE WHEN @intSum % 10 = 0 THEN 1 ELSE 0 END
	END;

RETURN @bValid
END
