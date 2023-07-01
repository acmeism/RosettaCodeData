program letterFrequency(input, output);
var
	chart: array[char] of 0..maxInt value [otherwise 0];
	c: char;
begin
	{ parameter-less EOF checks for EOF(input) }
	while not EOF do
	begin
		read(c);
		chart[c] := chart[c] + 1
	end;
	
	{ now, chart[someLetter] gives you the letter’s frequency }
end.
