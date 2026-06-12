program tac(input, output);

procedure reverse;
var
	line: text;
begin
	{ Open for (over-)writing. }
	rewrite(line);
	
	{ `EOLn` is shorthand for `EOLn(input)`. }
	while not EOLn do
	begin
		{ `line^` and `input^` refer to buffer variables [their values]. }
		line^ := input^;
		{ Write buffer and advance writing position. }
		put(line);
		{ Advance reading cursor and obtain next value [if such exists]. }
		get(input)
	end;
	
	{ Consume “newline” character in `input` }
	readLn;
	
	{ Likewise, `EOF` is shorthand for `EOF(input)`. }
	if not EOF then
	begin
		reverse
	end;
	
	{ (Re‑)open for reading. }
	reset(line);
	
	while not EOLn(line) do
	begin
		output^ := line^;
		put(output);
		get(line)
	end;
	
	{ `writeLn` is shorthand for `writeLn(output)`. }
	writeLn
end;

begin
	reverse
end.
