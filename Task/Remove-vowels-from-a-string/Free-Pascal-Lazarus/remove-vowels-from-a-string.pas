{$longStrings on}
uses
	strUtils;
var
	line: string;
	c: char;
begin
	readLn(line);
	for c in ['A', 'E', 'I', 'O', 'U', 'a', 'e', 'i', 'o', 'u'] do
	begin
		line := delChars(line, c)
	end;
	writeLn(line)
end.
