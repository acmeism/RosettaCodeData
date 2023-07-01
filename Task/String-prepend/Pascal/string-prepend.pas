program stringPrepend(output);
var
	line: string(20);
begin
	line := 'Hello ';
	line := line + 'world!';
	writeLn(line);
	
	line := 'Hello ';
	writeStr(line, line, 'world!');
	writeLn(line)
end.
