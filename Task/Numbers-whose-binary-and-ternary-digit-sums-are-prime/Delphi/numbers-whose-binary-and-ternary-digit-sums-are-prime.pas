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


function SumDigitsByBase(N,Base: integer): integer;
{Sum all digits of N in the specified B}
var I: integer;
begin
Result:=0;
repeat
	begin
	I:=N mod Base;
	Result:=Result+I;
	N:=N div Base;
	end
until N = 0;
end;

function IsBinaryTernaryPrime(N: integer): boolean;
{Test if sums of binary and ternary digits is prime}
var Sum2,Sum3: integer;
begin
Result:=IsPrime(SumDigitsByBase(N,2)) and
	IsPrime(SumDigitsByBase(N,3));
end;

procedure ShowBinaryTernaryPrimes(Memo: TMemo);
{Show the Binary-Ternary sum primes of first 200 values}
var I,Cnt: integer;
var S: string;
begin
S:=''; Cnt:=0;
for I:=0 to 200-1 do
 if IsBinaryTernaryPrime(I) then
	begin
	Inc(Cnt);
	S:=S+Format('%8D',[I]);
	If (Cnt mod 5)=0 then S:=S+CRLF;
	end;
Memo.Lines.Add(S);
Memo.Lines.Add('Count= '+IntToStr(Cnt));
end;

