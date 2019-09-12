program letterFrequency(input, output, stdErr);
var
	chart: array[char] of integer;
	c: char;
begin
	for c := low(chart) to high(chart) do
	begin
		chart[c] := 0;
	end;
	
	// parameter-less EOF() checks for EOF(input)
	while not EOF() do
	begin
		read(c);
		inc(chart[c]);
	end;
	
	// now, chart[someLetter] gives you the letter’s frequency
end.
