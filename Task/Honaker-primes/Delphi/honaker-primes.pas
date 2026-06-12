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



function GetNextPrime(var Start: integer): integer;
{Get the next prime number after Start}
{Start is passed by "reference," so the
{original variable is incremented}
begin
repeat Inc(Start)
until IsPrime(Start);
Result:=Start;
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


function IsHonaker(I,N: integer): boolean;
{A Honaker prime is one where the sums of digits}
{of the prime and its position are equal}
begin
Result:=SumDigits(I) = SumDigits(N);
end;

procedure ShowHonakerPrimes(Memo: TMemo);
{Test Honaker primes}
var I, N,Cnt: integer;
var S: string;
begin
N:=0; Cnt:=0; S:='';
{Test all numbers to see if they are prime}
for I:=1 to High(integer) do
	begin
	N:=GetNextPrime(N);
	{Test the number if it Honaker}
	if IsHonaker(I,N) then
		begin
		{Display if Honaker}
		Inc(Cnt);
		S:=S+Format('(%2d%5d%5d)   ',[Cnt,I,N]);
		if (Cnt mod 3)=0 then S:=S+#$0D#$0A;
		if Cnt>=50 then break;
		end;
	end;
Memo.Lines.Add('First 50 Honaker Primes');
Memo.Lines.Add(S);
Memo.Lines.Add('');

{Find the 10,000th Honaker}
Memo.Lines.Add('The 10,000th Honaker Primes');
N:=0; Cnt:=0;
for I:=1 to High(integer) do
	begin
	N:=GetNextPrime(N);
	if IsHonaker(I,N) then
		begin
		Inc(Cnt);
		if Cnt=10000 then
			begin
                        Memo.Lines.Add(Format('(%5d %5d %5d)   ',[Cnt,I,N]));
			break;
			end;
		end;
	end;
end;


