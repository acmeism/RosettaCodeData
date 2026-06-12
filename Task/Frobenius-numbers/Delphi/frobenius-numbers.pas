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



procedure ShowFrobeniusNumbers(Memo: TMemo);
var N,N1,FN,Cnt: integer;
begin
N:=2;
Cnt:=0;
while true do
	begin
	Inc(Cnt);
	N1:=GetNextPrime(N);
	FN:=N * N1 - N - N1;
	N:=N1;
	if FN>10000 then break;
	Memo.Lines.Add(Format('%2d = %5d',[Cnt,FN]));
	end;
end;


