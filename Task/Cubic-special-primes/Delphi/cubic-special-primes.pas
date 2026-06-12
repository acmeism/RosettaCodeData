procedure CubicSpecialPrimes(Memo: TMemo);
const Limit = 15000;
var Sieve: TPrimeSieve;
var N,I,PP, Count: integer;
var S: string;
begin
Sieve:=TPrimeSieve.Create;
try
{Get all primes up to limit}
Sieve.Intialize(Limit);
N:=1;
Count:=0;
I:=1;
S:='';
while true do
	begin
	{Find first cube increment that is prime}
	PP:=N +I*I*I;
	if PP>Limit then break;
	if Sieve.Flags[PP] then
		begin
		Inc(Count);
		S:=S+Format('%6D',[PP]);
		if (Count mod 5) = 0 then S:=S+CRLF;
		{Step to next cube position}
		I:=1;
		N:=PP;
		end
	else Inc(I);
	end;
Memo.Lines.Add(Format('There are %d cubic special primes',[count]));
Memo.Lines.Add(S);
finally Sieve.Free; end;
end;


