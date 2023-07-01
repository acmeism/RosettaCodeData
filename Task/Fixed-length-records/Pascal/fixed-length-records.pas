program reverseFixedLines(input, output, stdErr);
const
	lineLength = 80;
var
	// in Pascal, `string[n]` is virtually an alias for `array[1..n] of char`
	line: string[lineLength];
	i: integer;
begin
	while not eof() do
	begin
		for i := 1 to lineLength do
		begin
			read(line[i]);
		end;
		
		for i := lineLength downto 1 do
		begin
			write(line[i]);
		end;
		writeLn();
	end;
end.
