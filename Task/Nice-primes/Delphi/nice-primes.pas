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



function SumDigits(N: integer): integer;
{Sum the integers in a number}
var T: integer;
begin
Result:=0;
repeat
	begin
	T:=N mod 10;
	N:=N div 10;
	Result:=Result+T;
	end
until N<1;
end;



function IsNiceNumber(N: integer): boolean;
{Return True if N is a nice number}
var Sum: integer;
begin
Result:=False;
{N must be primes}
if not IsPrime(N) then exit;
{Keep summing until one digit number}
Sum:=N;
repeat Sum:=SumDigits(Sum)
until Sum<10;
{Must be prime too}
Result:=IsPrime(Sum);
end;


procedure ShowNicePrimes(Memo: TMemo);
{Display Nice Primes between 501 and 999}
var I,Cnt: integer;
var S: string;
begin
Cnt:=0; S:='';
for I:=501 to 999 do
 if IsNiceNumber(I) then
	begin
	S:=S+Format('%4d',[i]);
	Inc(Cnt);
	if (Cnt mod 5)=0 then S:=S+#$0D#$0A;
	end;
Memo.Lines.Add(Format('Nice Primes: %3D',[Cnt]));
Memo.Lines.Add(S);
end;

