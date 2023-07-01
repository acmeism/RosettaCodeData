program writeInput(input, output);
var
	buffer: char;
begin
	while not EOF() do
	begin
		read(buffer); // shorthand for read(input, buffer)
		write(buffer); // shorthand for write(output, buffer)
	end;
end.
