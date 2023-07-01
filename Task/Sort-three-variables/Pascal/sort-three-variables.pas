program sortThreeVariables(output);

type
	{ this Extended Pascal data type may hold up to 25 `char` values }
	line = string(25);

{ this procedure sorts two lines }
procedure sortLines(var X, Y: line);
	{ nested procedure allocates space for Z only if needed }
	procedure swap;
	var
		Z: line;
	begin
		Z := X;
		X := Y;
		Y := Z
	end;
begin
	{ for lexical sorting write `if GT(X, Y) then` }
	if X > Y then
	begin
		swap
	end
end;

{ sorts three line variables’s values }
procedure sortThreeLines(var X, Y, Z: line);
begin
	{ `var` parameters can be modified at the calling site }
	sortLines(X, Y);
	sortLines(X, Z);
	sortLines(Y, Z)
end;

{ writes given lines on output preceded by `X = `, `Y = ` and `Z = ` }
procedure printThreeLines(protected X, Y, Z: line);
begin
	{ `protected` parameters cannot be overwritten }
	writeLn('X = ', X);
	writeLn('Y = ', Y);
	writeLn('Z = ', Z)
end;

{ === MAIN ============================================================= }
var
	A, B: line;
	{ for demonstration purposes: alternative method to initialize }
	C: line value '(from the "Wizard of OZ")';
begin
	A := 'lions, tigers, and';
	B := 'bears, oh my!';
	
	sortThreeLines(A, B, C);
	printThreeLines(A, B, C)
end.
