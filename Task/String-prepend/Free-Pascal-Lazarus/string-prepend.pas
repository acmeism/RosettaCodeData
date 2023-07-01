var
	line: string[20];
begin
	line := 'Hello ';
	{$COperators on}
	line += 'world!';
	writeLn(line)
end.
