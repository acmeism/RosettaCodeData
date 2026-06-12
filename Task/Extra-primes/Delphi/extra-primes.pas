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

function IsExtraPrime(N: integer): boolean;
{Check if 1) The number is prime}
{2) All the digits in the number is prime}
{3) The sum of all digits is prime}
var S: string;
var I,Sum,D: integer;
begin
Result:=False;
if not IsPrime(N) then exit;
Sum:=0;
S:=IntToStr(N);
for I:=1 to Length(S) do
	begin
	D:=byte(S[I])-$30;
	if not IsPrime(D) then exit;
	Sum:=Sum+D;
	end;
Result:=IsPrime(Sum);
end;


procedure ShowExtraPrimes(Memo: TMemo);
{Show all extra-primes less than 10,000}
var I: integer;
var Cnt: integer;
var S: string;
begin
Cnt:=0;
S:='';
for I:=1 to 10000 do
 if IsExtraPrime(I) then
	begin
	Inc(Cnt);
	S:=S+Format('%5d',[I]);
	if (Cnt mod 9)=0 then S:=S+#$0D#$0A;
	end;
Memo.Lines.Add(S);
end;
