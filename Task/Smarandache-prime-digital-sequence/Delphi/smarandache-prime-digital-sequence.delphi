procedure ShowSmarandachePrimes(Memo: TMemo);
{Show primes where all digits are also prime}
var Sieve: TPrimeSieve;
var I,J,P,Count: integer;
var S: string;


	function AllDigitsPrime(N: integer): boolean;
	{Test all digits on N to see if they are prime}
	var I,Count: integer;
	var IA: TIntegerDynArray;
	begin
	Result:=False;
	GetDigits(N,IA);
	for I:=0 to High(IA) do
	 if not Sieve.Flags[IA[I]] then exit;
	Result:=True;
	end;


begin
Sieve:=TPrimeSieve.Create;
try
{Build 1 million primes}
Sieve.Intialize(1000000);
Count:=0;
{Test if all digits of the number are prime}
for I:=0 to Sieve.PrimeCount-1 do
	begin
	P:=Sieve.Primes[I];
	if AllDigitsPrime(P) then
		begin
		Inc(Count);
		if Count<=25 then Memo.Lines.Add(IntToStr(Count)+' - '+IntToStr(P));
		if Count=100 then
			begin
                        Memo.Lines.Add('100th = '+IntToStr(P));
			break;
			end;
		end;
	end;
finally Sieve.Free; end;
end;
