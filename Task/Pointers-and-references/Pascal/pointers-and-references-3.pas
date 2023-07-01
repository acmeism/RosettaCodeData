program routineParameterDemo(output);

procedure foo(function f: Boolean);
begin
	writeLn(f);
end;

function bar: Boolean;
begin
	bar := false
end;

begin
	foo(bar);
end.
