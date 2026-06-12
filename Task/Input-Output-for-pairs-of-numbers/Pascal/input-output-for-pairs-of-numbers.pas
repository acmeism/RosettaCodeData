program inputOutputForPairsOfNumbers(input, output);
var
	lines: integer;
	x: integer;
	y: integer;
begin
	readLn(lines);
	for lines := 1 to lines do
	begin
		readLn(x, y);
		writeLn(x + y)
	end
end.
