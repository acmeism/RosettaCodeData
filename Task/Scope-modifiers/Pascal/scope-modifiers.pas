procedure super;
var
	f: boolean;
	
	procedure nestedProcedure;
	var
		c: char;
	begin
		// here, `f`, `c`, `nestedProcedure` and `super` are available
	end;
	procedure commonTask;
	var
		f: boolean;
	begin
		// here, `super`, `commonTask` and _only_ the _local_ `f` is available
	end;
var
	c: char;

	procedure fooBar;
	begin
		// here, `super`, `fooBar`, `f` and `c` are available
	end;
var
	x: integer;
begin
	// here, `c`, `f`, and `x`, as well as,
	// `nestedProcedure`, `commonTask`, `fooBar` and `super` are available
end;
