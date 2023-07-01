uses Windows,SysUtils,StdCtrls;

type TProgress = procedure(Percent: integer);

procedure ShowAscendingPrimes(Memo: TMemo; Prog: TProgress);

implementation


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



function IsAscending(N: integer): boolean;
{Determine if each digit is greater than previous, left to right}
var S: string;
var I: integer;
begin
Result:=False;
S:=IntToStr(N);
for I:=1 to Length(S)-1 do
 if S[I]>=S[I+1] then exit;
Result:=True;
end;


procedure ShowAscendingPrimes(Memo: TMemo; Prog: TProgress);
{Write Ascending primes up to 123,456,789 }
{It has an optional, user-supplied progress routine }
var I,Cnt: integer;
var S: string;
const Max = 123456789;
begin
if Assigned(Prog) then Prog(0);
S:='';
Cnt:=0;
for I:=2 to Max do
	begin
	if ((I mod 1000000)=0) and Assigned(Prog) then Prog(Trunc(100*(I/Max)));
	if IsAscending(I) and IsPrime(I) then
		begin
		S:=S+Format('%9.0d', [I]);
		Inc(Cnt);
		if (Cnt mod 10)=0 then
			begin
			Memo.Lines.Add(S);
			S:='';
			end;
		end;
	end;
end;
