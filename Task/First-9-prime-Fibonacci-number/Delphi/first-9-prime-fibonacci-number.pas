function IsPrime(N: integer): boolean;
{Fast, optimised prime test}
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
           if ((N mod I) = 0) or ((N mod (I + 2)) = 0) then exit;
           Inc(I,6);
           end;
     Result:=True;
     end;
end;


procedure ShowFibonacciPrimes(Memo: TMemo);
{Find and display first nine Fibonacci primes}
var N1,N2,T,Cnt: integer;
begin
Cnt:=0;
N1:=0; N2:=1;
while true do
	begin
	{Calculate next Fib number}
	T:=N1+N2;
	N1:=N2; N2:=T;
	{Test if it is prime}
	if IsPrime(N2) then
		begin
		Inc(Cnt);
		Memo.Lines.Add(IntToStr(N2));
		if Cnt>=9 then break;
		end;
	end;
end;
