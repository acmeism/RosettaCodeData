program ISBNChecksum(output);

const
	codeIndexMaximum = 17;
	ISBNIndexMinimum = 1;
	ISBNIndexMaximum = 13;
	ISBNIndexRange = ISBNIndexMaximum - ISBNIndexMinimum + 1;

type
	code = string(codeIndexMaximum);
	codeIndex = 1..codeIndexMaximum value 1;
	decimalDigit = '0'..'9';
	decimalValue = 0..9;
	ISBNIndex = ISBNIndexMinimum..ISBNIndexMaximum;
	ISBN = array[ISBNIndex] of decimalDigit;

{ returns the integer value represented by a character }
function numericValue(protected c: decimalDigit): decimalValue;
begin
	{ in Pascal result variable bears the same name as the function }
	numericValue := ord(c) - ord('0')
end;

{ determines whether an ISBN is technically valid (checksum correct) }
function isValidISBN(protected n: ISBN): Boolean;
var
	sum: 0..225 value 0;
	i: ISBNIndex;
begin
	{ NB: in Pascal for-loop-limits are _inclusive_ }
	for i := ISBNIndexMinimum to ISBNIndexMaximum do
	begin
		{ alternating scale factor 3^0, 3^1 based on Boolean }
		sum := sum + numericValue(n[i]) * 3 pow ord(not odd(i))
	end;
	
	isValidISBN := sum mod 10 = 0
end;

{ transform '978-0-387-97649-5' into '9780387976495' }
function digits(n: code): code;
var
	sourceIndex, destinationIndex: codeIndex;
begin
	for sourceIndex := 1 to length(n) do
	begin
		if n[sourceIndex] in ['0'..'9'] then
		begin
			n[destinationIndex] := n[sourceIndex];
			destinationIndex := destinationIndex + 1
		end
	end;
	
	{ to alter a string’s length you need overwrite it completely }
	digits := subStr(n, 1, destinationIndex - 1)
end;

{ data type coercion }
function asISBN(protected n: code): ISBN;
var
	result: ISBN;
begin
	unpack(n[1..length(n)], result, 1);
	asISBN := result
end;

{ tells whether a string value contains a proper ISBN representation }
function isValidISBNString(protected hyphenatedForm: code): Boolean;
var
	digitOnlyForm: code;
begin
	digitOnlyForm := digits(hyphenatedForm);
	{ The Extended Pascal `and_then` Boolean operator allows us }
	{ to first check the length before invoking `isValidISBN`. }
	isValidISBNString := (length(digitOnlyForm) = ISBNIndexRange)
		and_then isValidISBN(asISBN(digitOnlyForm))
end;

{ === MAIN ============================================================= }
begin
	writeLn(isValidISBNString('978-1734314502'));
	writeLn(isValidISBNString('978-1734314509'));
	writeLn(isValidISBNString('978-1788399081'));
	writeLn(isValidISBNString('978-1788399083'))
end.
