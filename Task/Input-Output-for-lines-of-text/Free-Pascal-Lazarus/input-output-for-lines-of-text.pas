program head(input, output, stdErr);

type
	obj = object
			public
				procedure method(const s: string); static;
		end;

procedure obj.method(const s: string);
begin
	writeLn(s);
end;

var
	numberOfLines: integer;
	line: string;
begin
	readLn(numberOfLines);
	
	for numberOfLines := numberOfLines downto 1 do
	begin
		readLn(line);
		obj.method(line);
	end;
end.
