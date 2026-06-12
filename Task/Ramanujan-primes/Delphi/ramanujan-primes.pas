procedure ShowRamanujanPrimes(Memo: TMemo);
var S: string;
var PrimeCounts: array of Integer;
var Sieve: TPrimeSieve;
var I,Cnt,P: integer;
const Size = 1000000;

	function GetRamanujanMax(N: integer): integer;
	{Get maximum possible Ramanujan for a particular N}
	begin
	Result:=Ceil(4 * N * (log(4 * N) / log(2)));
	end;


	function RamanujanPrime(N: integer): integer;
	{Find largest I for Pi[I]-Pi[I/2]<N, Pi[I] is count primes less than I}
	var I: integer;
	begin
	for I:=GetRamanujanMax(N) downto 0 do
	 if (PrimeCounts[I] - PrimeCounts[I div 2]) < N then
		begin
		Result:=I+1;
		exit;
		end;
	Result:=0;
	end;


begin
Sieve:=TPrimeSieve.Create;
try
{Get primes up to 1 million}
Sieve.Intialize(Size);
{Count total number of primes up to a specific number}
SetLength(PrimeCounts,Size);
Cnt:=0;
for I:=0 to Sieve.Count-1 do
	begin
	if Sieve.Flags[I] then Inc(Cnt);
	PrimeCounts[I]:=Cnt;
	end;
{display first 100 Ramanujan Prime}
S:='';
for I:=1 to 100 do
	begin
	P:=RamanujanPrime(I);
	S:=S+Format('%5d',[P]);
	if (I mod 10)=0 then S:=S+CRLF;
        end;
Memo.Lines.Add(S);
P:=RamanujanPrime(1000);
Memo.Lines.Add('1,000th Prime: '+IntToStr(P));
P:=RamanujanPrime(10000);
Memo.Lines.Add('10,000th Prime: '+IntToStr(P));
finally Sieve.Free; end;
end;




