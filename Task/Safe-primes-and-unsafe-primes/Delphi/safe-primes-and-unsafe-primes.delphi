{Uses seive object that creates an array of flags that tells whether a particular number is prime or not}


function GetSafeUnsafePrimes(MaxCount,MaxPrime: integer; ShowSafe, Display: boolean): string;
{MaxCount = Maximum number of Safe/Unsafe primes to find}
{MaxPrime = Maximum number of primes tested}
{ShowSafe = Controls whether we are looking for Save/Unsafe primes}
{Display = Controls whether the primes are displayed or just counted}
var I,Cnt: integer;
var Sieve: TPrimeSieve;
var IsSafe: boolean;

	procedure CountAndDisplay;
	begin
	Inc(Cnt);
	if Display then Result:=Result+Format('%7D',[I]);
	If Display and ((Cnt mod 5)=0) then Result:=Result+CRLF;
	end;

begin
{Create sieve and set sieve size}
Sieve:=TPrimeSieve.Create;
try
Sieve.Intialize(MaxPrime*2);
Cnt:=0;
Result:='';
I:=2;
while true do
	begin
	if I>=MaxPrime then break;
	IsSafe:=(I>3) and Sieve[(I-1) div 2];
	if IsSafe=ShowSafe then CountAndDisplay;
	if Cnt>=MaxCount then break;
	I:=Sieve.NextPrime(I);
	end;
Result:=Result+'Count = '+FloatToStrF(Cnt,ffNumber,18,0);
finally Sieve.Free; end;
end;


procedure ShowSafeUnsafePrimes(Memo: TMemo);
var S: string;
begin
Memo.Lines.Add('The first 35 safe primes: ');
S:=GetSafeUnsafePrimes(35,10000000,True,True);
Memo.Lines.Add(S);
Memo.Lines.Add('Safe Primes Under 1,000,000: ');
S:=GetSafeUnsafePrimes(high(integer),1000000,True,False);
Memo.Lines.Add(S);
Memo.Lines.Add('Safe Primes Under 10,000,000: ');
S:=GetSafeUnsafePrimes(high(integer),10000000,True,False);
Memo.Lines.Add(S);

Memo.Lines.Add('The first 40 Unsafe primes: ');
S:=GetSafeUnsafePrimes(40,10000000,False,True);
Memo.Lines.Add(S);
Memo.Lines.Add('Unsafe Primes Under 1,000,000: ');
S:=GetSafeUnsafePrimes(high(integer),1000000,False,False);
Memo.Lines.Add(S);
Memo.Lines.Add('Unsafe Primes Under 10,000,000: ');
S:=GetSafeUnsafePrimes(high(integer),10000000,False,False);
Memo.Lines.Add(S);
end;
