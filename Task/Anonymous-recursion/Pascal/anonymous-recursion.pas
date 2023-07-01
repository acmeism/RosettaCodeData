program AnonymousRecursion;

function Fib(X: Integer): integer;

	function DoFib(N: Integer): Integer;
	begin
	if N < 2 then DoFib:=N
	else DoFib:=DoFib(N-1) + DoFib(N-2);
	end;

begin
if X < 0 then Fib:=X
else Fib:=DoFib(X);
end;


var I,V: integer;

begin
for I:=-1 to 15 do
	begin
	V:=Fib(I);
	Write(I:3,' - ',V:3);
	if V<0 then Write(' - Error');
	WriteLn;
	end;
WriteLn('Hit Any Key');
ReadLn;
end.
