procedure SummationOfPrimes(Memo: TMemo);
var I: integer;
var Sum: int64;
var Sieve: TPrimeSieve;
begin
Sieve:=TPrimeSieve.Create;
try
Sieve.Intialize(2000000);
Sum:=0;
for I:=0 to Sieve.PrimeCount-1 do
 Sum:=Sum+Sieve.Primes[I];
Memo.Lines.Add(Format('Sum of Primes Below 2 million: %.0n',[Sum+0.0]));
finally Sieve.Free; end;
end;


