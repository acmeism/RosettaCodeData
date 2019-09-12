function isNumeric(const potentialNumeric: string): boolean;
var
	potentialInteger: integer;
	potentialReal: real;
	integerError: integer;
	realError: integer;
begin
	integerError := 0;
	realError := 0;
	
	// system.val attempts to convert numerical value representations.
	// It accepts all notations as they are accepted by the language,
	// as well as the '0x' (or '0X') prefix for hexadecimal values.
	val(potentialNumeric, potentialInteger, integerError);
	val(potentialNumeric, potentialReal, realError);
	
	isNumeric := (integerError = 0) or (realError = 0);
end;
