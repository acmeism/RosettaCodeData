procedure SpecialNeighborPrimes(Memo: TMemo);
var I: integer;
var P1,P2: integer;
var Sieve: TPrimeSieve;
begin
Sieve:=TPrimeSieve.Create;
try
{Build more primes than we need}
Sieve.Intialize(200);
{Go through all primes}
for I:=1 to High(Sieve.Primes) do
	begin
	{Get neighbor primes}
	P1:=Sieve.Primes[I-1];
	P2:=Sieve.Primes[I];
	{only test up to 100}
	if P2>=100 then break;
	{if P1+P2-1 is prime then display}
	if Sieve.Flags[P1 + P2 - 1] then Memo.Lines.Add(Format('(%d, %d)',[P1,P2]));
	end;
finally Sieve.Free; end;
end;


