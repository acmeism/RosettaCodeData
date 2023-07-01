function IsMersennePrime(P: int64): boolean;
{Test for Mersenne Prime - P cannot be bigger than 63}
{Because (1 shl 64) would be bigger than in64}
var S,MP: int64;
var I: integer;
begin
if P= 2 then Result:=true
else
	begin
	MP:=(1 shl P) - 1;
	S:=4;
	for I:=3 to P do
		begin
		S:=(S * S - 2) mod MP;
		end;
	Result:=S = 0;
	end;
end;


procedure ShowMersennePrime(Memo: TMemo);
var Sieve: TPrimeSieve;
var I: integer;
begin
{Create Sieve}
Sieve:=TPrimeSieve.Create;
{Test cannot handle values bigger than 64}
Sieve.Intialize(64);
for I:=0 to Sieve.PrimeCount-1 do
 if IsMersennePrime(Sieve.Primes[I]) then
	begin
	Memo.Lines.Add(IntToStr(Sieve.Primes[I]));
	end;
Sieve.Free;
end;
