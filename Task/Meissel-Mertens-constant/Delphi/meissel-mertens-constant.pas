function IsPrime(N: int64): boolean;
{Fast, optimised prime test}
var I,Stop: int64;
begin
if (N = 2) or (N=3) then Result:=true
else if (n <= 1) or ((n mod 2) = 0) or ((n mod 3) = 0) then Result:= false
else
     begin
     I:=5;
     Stop:=Trunc(sqrt(N+0.0));
     Result:=False;
     while I<=Stop do
           begin
           if ((N mod I) = 0) or ((N mod (I + 2)) = 0) then exit;
           Inc(I,6);
           end;
     Result:=True;
     end;
end;


function GetNextPrime(var Start: integer): integer;
{Get the next prime number after Start}
{Start is passed by "reference," so the
{original variable is incremented}
begin
repeat Inc(Start)
until IsPrime(Start);
Result:=Start;
end;


function MeisselMertens(Depth: integer; Prog: TProgress): extended;
{Calculate MM value up a certain Depth}
var I,P: integer;
const Euler = 0.57721566490153286;
begin
Result:=0;
P:=1;
for I:=1 to Depth do
	begin
	P:=GetNextPrime(P);
	Result:=Result+Ln(1-(1/P)) + (1/P);
	if Assigned(Prog) and ((I mod 10000)=0) then
		HandleProgress(MulDiv(100,I,Depth));
	end;
Result:=Result+Euler;
end;


procedure ShowMeisselMertens(Memo: TMemo; Prog: TProgress);
var I,IT,Digits: integer;
var M,Last: extended;
begin
Memo.Lines.Add('Primes  Digits       M');
Memo.Lines.Add('-----------------------------------------');
Last:=0;
IT:=1;
{Calculate MM to specified Power of 10}
for I:=1 to 7 do
	begin
	IT:=IT*10;
	M:=MeisselMertens(IT,Prog);
	{Calculated Digits of accuracy}
	Digits:=Trunc(abs(Log(abs(M-Last))));
	Memo.Lines.Add(Format('10^%2d  %7d  %25.18f',[I,Digits,M]));
	Last:=M
	end;
end;
