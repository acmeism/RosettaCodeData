program countHowManyVowelsAndConsonantsOccurInAString(input, output);

var
	vowel, consonant: set of char;
	vowelCount, consonantCount: integer;

begin
	{ initialize variables  - - - - - - - - - - - - - - - - - - }
	vowel := ['A', 'E', 'I', 'O', 'U', 'a', 'e', 'i', 'o', 'u'];
	consonant := ['B', 'C', 'D', 'F', 'G', 'H', 'J', 'K', 'L',
		'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'X', 'Y',
		'Z', 'b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm',
		'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'y', 'z'];
	
	vowelCount := 0;
	consonantCount := 0;
	
	{ process - - - - - - - - - - - - - - - - - - - - - - - - - }
	while not EOF do
	begin
		{ input^ refers to the buffer variable's value }
		vowelCount     := vowelCount     + ord(input^ in vowel);
		consonantCount := consonantCount + ord(input^ in consonant);
		get(input)
	end;
	
	{ result  - - - - - - - - - - - - - - - - - - - - - - - - - }
	writeLn(vowelCount,     ' vowels');
	writeLn(consonantCount, ' consonants')
end.
