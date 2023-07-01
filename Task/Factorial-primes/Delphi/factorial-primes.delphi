function IsPrime(N: int64): boolean;
{Optimised prime test - about 40% faster than the naive approach}
var I,Stop: integer;
begin
if (N = 2) or (N=3) then Result:=true
else if (n <= 1) or ((n mod 2) = 0) or ((n mod 3) = 0) then Result:= false
else
	begin
	I:=5;
	Stop:=Trunc(sqrt(N*1.0));
	Result:=False;
	while I<=Stop do
		begin
		if ((N mod I) = 0) or ((N mod (i + 2)) = 0) then exit;
		Inc(I,6);
		end;
	Result:=True;
	end;
end;


function Factorial(N: Word): int64;
var  I: integer;
begin
Result:= 1;
for I := 2 to N do Result:=Result * I;
end;


procedure ShowFactorialPrimes(Memo: TMemo);
{Show factorials where F+1 or F-1 are prime}
var I,Cnt: integer;
var F: int64;

	procedure DisplayItem(Minus: boolean);
	var S: string;
	var Sign: char;
	var F1: int64;
	begin
	Inc(Cnt);
	if Minus then F1:=F-1 else F1:=F+1;
	if Minus then Sign:='-' else Sign:='+';
	S:=Format('%2d:   %3d! %s 1 = %d',[Cnt,I,Sign,F1]);
	Memo.Lines.Add(S);
	end;

begin
Cnt:=0;
for I:=1 to High(Integer) do
	begin
	F:=Factorial(I);
	if IsPrime(F+1) then DisplayItem(False);
	if IsPrime(F-1) then DisplayItem(True);
	if Cnt>=10 then break;
	end;
end;
