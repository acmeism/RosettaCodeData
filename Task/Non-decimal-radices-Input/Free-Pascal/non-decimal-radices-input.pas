program readIntegers(input, output);
var
	i: aluSInt;
begin
	while not EOF(input) do
	begin
		readLn(i);
		writeLn(i:24);
	end;
end.
