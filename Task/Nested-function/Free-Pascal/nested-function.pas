// In Pascal, functions always _have_ to return _some_ value,
// but the the task doesn’t specify what to return.
// Hence makeList and makeItem became procedures.
procedure makeList(const separator: string);
// The var-section for variables that ought to be accessible
// in the routine’s body as well as the /nested/ routines
// has to appear /before/ the nested routines’ definitions.
var
	counter: 1..high(integer);
	
	procedure makeItem;
	begin
		write(counter, separator);
		case counter of
			1:
			begin
				write('first');
			end;
			2:
			begin
				write('second');
			end;
			3:
			begin
				write('third');
			end;
		end;
		writeLn();
		counter := counter + 1;
	end;
// You can insert another var-section here, but variables declared
// in this block would _not_ be accessible in the /nested/ routine.
begin
	counter := 1;
	makeItem;
	makeItem;
	makeItem;
end;
