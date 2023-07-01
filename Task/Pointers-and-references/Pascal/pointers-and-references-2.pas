program variantRecordDemo;

type
	fooReference = ^foo;
	foo = record
			case Boolean of
			false: ( );
			true: (location: fooReference);
		end;
	
var
	head: fooReference;
begin
	new(head, true);
	{ … }
	dispose(head, true);
end.
