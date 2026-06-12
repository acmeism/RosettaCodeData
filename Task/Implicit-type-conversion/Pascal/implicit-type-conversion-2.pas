program additionalImplicitTypeConversionInExtendedPascal;
var
	c: char;
	s: string(20);
	i: integer;
	r: real;
	x: complex;
begin
	c := 'X';
	s := c;   { char → string(…) }
		
	i := 42;
	x := i;   { integer → complex }
	
	r := 123.456;
	x := r    { real → complex }
end.
