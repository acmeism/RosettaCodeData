{$mode objFPC}

generic procedure sort<T>(var X, Y: T);
	procedure swap;
	var
		Z: T;
	begin
		Z := X;
		X := Y;
		Y := Z
	end;
begin
	if X > Y then
	begin
		swap
	end
end;

generic procedure sort<T>(var X, Y, Z: T);
begin
	specialize sort<T>(X, Y);
	specialize sort<T>(X, Z);
	specialize sort<T>(Y, Z)
end;

generic procedure print<T>(const X, Y, Z: T);
begin
	writeLn('X = ', X);
	writeLn('Y = ', Y);
	writeLn('Z = ', Z)
end;

{ === MAIN ============================================================= }
var
	A, B, C: string;
	I, J, K: integer;
	P, Q, R: real;
begin
	A := 'lions, tigers, and';
	B := 'bears, oh my!';
	C := '(from the "Wizard of OZ")';
	
	specialize sort<string>(A, B, C);
	specialize print<string>(A, B, C);
	
	writeLn;
	I := 77444;
	J :=   -12;
	K :=     0;
	specialize sort<integer>(I, J, K);
	specialize print<integer>(I, J, K);
	
	writeLn;
	P :=  12.34;
	Q := -56.78;
	R :=   9.01;
	specialize sort<real>(P, Q, R);
	specialize print<real>(P, Q, R)
end.
