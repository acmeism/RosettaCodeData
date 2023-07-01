program topAndTail(output);
var
	line: string(20);
begin
	line := 'ABCDEF';
	
	if length(line) > 1 then
	begin
		{ string with first character removed }
		writeLn(subStr(line, 2));
		{ index range expression: only possible for strings }
		{ _not_ designated `bindable` [e.g. `bindable string(20)`] }
		writeLn(line[2..length(line)]);
		
		{ string with last character removed }
		
		writeLn(subStr(line, 1, length(line) - 1));
		{ only legal with non-bindable strings: }
		writeLn(line[1..length(line)-1])
	end;
	
	{ string with both the first and last characters removed }
	if length(line) > 2 then
	begin
		writeLn(subStr(line, 2, length(line) - 2));
		{ only for non-bindable strings: }
		writeLn(line[2..length(line)-1])
	end
end.
