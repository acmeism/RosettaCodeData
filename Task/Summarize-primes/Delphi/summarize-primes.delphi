procedure SumOfPrimeSequences(Memo: TMemo);
var Sieve: TPrimeSieve;
var I,Inx, Sum: integer;
begin
Sieve:=TPrimeSieve.Create;
try
Sieve.Intialize(100000);
Memo.Lines.Add('  I  P(I)   Sum');
Memo.Lines.Add('---------------');
I:=0;
Sum:=0;
while Sieve.Primes[I]<1000 do
	begin
	Sum:=Sum+Sieve.Primes[I];
	if Sieve.Flags[Sum] then
		begin
		Memo.Lines.Add(Format('%3d %4d %6d',[I,Sieve.Primes[I],Sum]));
		end;
	Inc(I,1);
	end;

finally Sieve.Free; end;
end;
