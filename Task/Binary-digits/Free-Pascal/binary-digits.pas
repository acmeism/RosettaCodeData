program binaryDigits(input, output, stdErr);
{$mode ISO}

function binaryNumber(const value: nativeUInt): shortString;
const
	one = '1';
var
	representation: shortString;
begin
	representation := binStr(value, bitSizeOf(value));
	// strip leading zeroes, if any; NB: mod has to be ISO compliant
	delete(representation, 1, (pos(one, representation)-1) mod bitSizeOf(value));
	// traditional Pascal fashion:
	// assign result to the (implicitely existent) variable
	// that is named like the function’s name
	binaryNumber := representation;
end;

begin
	writeLn(binaryNumber(5));
	writeLn(binaryNumber(50));
	writeLn(binaryNumber(9000));
end.
