program removeVowelsFromString(input, output);

const
	stringLength = 80;

type
	stringIndex = 1..stringLength;
	string = array[stringIndex] of char;

var
	sourceIndex, destinationIndex: stringIndex;
	line, disemvoweledLine: string;
	vowels: set of char;

function lineHasVowels: Boolean;
var
	sourceIndex: stringIndex;
	vowelIndices: set of stringIndex;
begin
	vowelIndices := [];
	
	for sourceIndex := 1 to stringLength do
	begin
		if line[sourceIndex] in vowels then
		begin
			vowelIndices := vowelIndices + [sourceIndex]
		end
	end;
	
	lineHasVowels := vowelIndices <> []
end;

begin
	vowels := ['A', 'E', 'I', 'O', 'U', 'a', 'e', 'i', 'o', 'u'];
	
	{ - - input - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
	for destinationIndex := 1 to stringLength do
	begin
		line[destinationIndex] := ' ';
		if not EOLn(input) then
		begin
			read(line[destinationIndex])
		end
	end;
	
	{ - - processing  - - - - - - - - - - - - - - - - - - - - - - - - - - - }
	if lineHasVowels then
	begin
		destinationIndex := 1;
		for sourceIndex := 1 to stringLength do
		begin
			if not (line[sourceIndex] in vowels) then
			begin
				disemvoweledLine[destinationIndex] := line[sourceIndex];
				destinationIndex := destinationIndex + 1
			end
		end;
		{ pad remaining characters in `disemvoweledLine` with spaces }
		for destinationIndex := destinationIndex to stringLength do
		begin
			disemvoweledLine[destinationIndex] := ' '
		end;
	end
	else
	begin
		disemvoweledLine := line
	end;
	
	{ - - output  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
	for destinationIndex := 1 to stringLength do
	begin
		write(disemvoweledLine[destinationIndex])
	end;
	writeLn
end.
