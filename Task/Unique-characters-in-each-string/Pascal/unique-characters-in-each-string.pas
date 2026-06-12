program uniqueCharactersInEachString(output);

type
	{ This “discriminates” the Extended Pascal (ISO 10206) schema }
	{ data type `string` to hold a sequence of up to `16` characters. }
	message = string(16);
	characters = set of char;

{
	\brief determine set of `char` values appear in a `string` once only
	\param sample the `string` to inspect
	\return a `set of char` appearing once in \param sample
}
{ In Extended Pascal `protected` denotes an immutable parameter. }
function uniqueCharacters(protected sample: message): characters;
var
	{ Here, `sample.capacity` refers to `16`. }
	i: 1..sample.capacity;
	{ EP extension: `… value []` initializes variables to empty set value. }
	firstOccurence, nonFirstOccurence: characters value [];
begin
	for i := 1 to length(sample) do
	begin
		{ With sets, `+` denotes the union, `*` denotes the intersection. }
		nonFirstOccurence := nonFirstOccurence + firstOccurence * [sample[i]];
		firstOccurence := firstOccurence + [sample[i]]
	end;
	
	uniqueCharacters := firstOccurence - nonFirstOccurence
end;

{
	\brief calls `uniqueCharacters` for several strings
	\param sample the `array` of strings
	\return characters appearing once in every \param sample member
}
function allUniqueCharacters(
		{ This is a “conformant array parameter” as defined by }
		{ ISO standard 7185 (level 1), and ISO standard 10206. }
		protected sample: array[sampleMinimum..sampleMaximum: integer] of message
	): characters;
var
	{ `type of` is an Extended Pascal extension. }
	i: type of sampleMinimum;
	uniqueInEverySample: characters value [chr(0)..maxChar];
begin
	for i := sampleMinimum to sampleMaximum do
	begin
		uniqueInEverySample := uniqueInEverySample * uniqueCharacters(sample[i])
	end;
	
	allUniqueCharacters := uniqueInEverySample
end;


{ === MAIN ============================================================= }
var
	c: char;
	sample: array[1..3] of message;
	lonelyLetters: characters;
begin
	sample[1] := '1a3c52debeffd';
	sample[2] := '2b6178c97a938stf';
	sample[3] := '3ycxdb1fgxa2yz';
	
	lonelyLetters := allUniqueCharacters(sample);
	
	{ If the compiler defines ascending evaluation order, in Extended Pascal }
	{ it is also possible to write `for c in allUniqueCharacters(sample)`. }
	{ However, the evaluation order (ascending/descending) is not defined by }
	{ the ISO standard, but the compiler vendor. And note, while it’s }
	{ guaranteed that `'A' < 'B'`, it is not guaranteed that `'a' < 'B'`. }
	{ The following might (and actually on modern systems will) still produce }
	{ a non-alphabetical listing. }
	for c := chr(0) to maxChar do
	begin
		if c in lonelyLetters then
		begin
			{ The `:2` is a format specifier defining the width of the output. }
			write(c:2)
		end
	end;
	writeLn
end.
