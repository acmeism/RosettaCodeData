// The FPC (FreePascal compiler) discards the program header
// (except in ISO-compliant “compiler modes”).
program showAsciiTable(output);

const
	columnsTotal = 6;

type
	// The hash indicates a char-data type.
	asciiCharacter = #32..#127;
	asciiCharacters = set of asciiCharacter;

var
	character: asciiCharacter;
	characters: asciiCharacters;
	column, line: integer;
begin
	// characters needs to be initialized,
	// because the next `include` below
	// will _read_ the value `characters`.
	// Reading _unintialized_ values, however,
	// is considered bad practice in Pascal.
	characters := [];
	// `div` denotes integer division in Pascal,
	// that means the result will be an _integer_-value.
	line := (ord(high(asciiCharacter)) - ord(low(asciiCharacter)))
		div columnsTotal + 1;
	// Note: In Pascal for-loop limits are _inclusive_.
	for column := 0 to columnsTotal do
	begin
		// This is equivalent to
		//   characters := characters + […];
		// i.e. the union of two sets.
		include(characters, chr(ord(low(asciiCharacter)) + column * line));
	end;
	
	for line := line downto 1 do
	begin
		// the for..in..do statement is an Extended Pascal extension
		for character in characters do
		begin
			// `:6` specifies minimum width of argument
			// [only works for write/writeLn/writeStr]
			write(ord(character):6, ' : ', character);
		end;
		// emit proper newline character on `output`
		writeLn;
		
		// `characters` is evaluated prior entering the loop,
		// not every time an iteration finished.
		for character in characters do
		begin
			// These statements are equivalent to
			//   characters := characters + [character];
			//   characters := characters - [succ(character)];
			// respectively, but shorter to write,
			// i.e. less susceptible to spelling mistakes.
			exclude(characters, character);
			include(characters, succ(character));
		end;
	end;
end.
