program AnonymousRecursion;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function Fib(X: Integer): integer;

	function DoFib(N: Integer): Integer;
	begin
	if N < 2 then Result:=N
	else Result:=DoFib(N-1) + DoFib(N-2);
	end;

begin
if X < 0 then raise Exception.Create('Argument < 0')
else Result:=DoFib(X);
end;


var I: integer;

begin
for I:=-1 to 15 do
	begin
	try
	WriteLn(I:3,' - ',Fib(I):3);
	except WriteLn(I,' - Error'); end;
	end;
WriteLn('Hit Any Key');
ReadLn;
end.
