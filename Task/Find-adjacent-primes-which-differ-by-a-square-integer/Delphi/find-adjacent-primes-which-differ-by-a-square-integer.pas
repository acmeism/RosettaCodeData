function IsPrime(N: integer): boolean;
{Optimised prime test - about 40% faster than the naive approach}
var I,Stop: integer;
begin
if (N = 2) or (N=3) then Result:=true
else if (n <= 1) or ((n mod 2) = 0) or ((n mod 3) = 0) then Result:= false
else
	begin
	I:=5;
	Stop:=Trunc(sqrt(N));
	Result:=False;
	while I<=Stop do
		begin
		if ((N mod I) = 0) or ((N mod (i + 2)) = 0) then exit;
		Inc(I,6);
		end;
	Result:=True;
	end;
end;

function GetNextPrime(Start: integer): integer;
{Get the next prime number after Start}
begin
repeat Inc(Start)
until IsPrime(Start);
Result:=Start;
end;



procedure ShowPrimeDiffs(Memo: TMemo);
var P1,P2,D: integer;
begin
P1:=GetNextPrime(2);
repeat
	begin
	P2:=GetNextPrime(P1);
	D:=P2 - P1;
	if (D>36) and (Frac(sqrt(D))=0) then
		begin
		Memo.Lines.Add(IntToStr(P2)+' - '+IntToStr(P1)+' = '+IntToStr(D));
		end;
	P1:=P2;
	end
until P2>=1000000;
end;

