procedure StrongWeakPrimes(Memo: TMemo);
{Display Strong/Weak prime information}
var I,P: integer;
var Sieve: TPrimeSieve;
var S: string;
var Cnt,Cnt1,Cnt2: integer;

	type TPrimeTypes = (ptStrong,ptWeak,ptBalanced);


	function GetTypeStr(PrimeType: TPrimeTypes): string;
	{Get string describing PrimeType}
	begin
	case PrimeType of
	 ptStrong: Result:='Strong';
	 ptWeak: Result:='Weak';
	 ptBalanced: Result:='Balanced';
	 end;
	end;

	function GetPrimeType(N: integer): TPrimeTypes;
	{Return flag indicating type of prime Primes[N] is}
	{Strong =     Primes(N) > [Primes(N-1) + Primes(N+1)] / 2}
	{Weak   =     Primes(N) < [Primes(N-1) + Primes(N+1)] / 2}
	{Balanced   = Primes(N) = [Primes(N-1) + Primes(N+1)] / 2}
	var P,P1: double;
	begin
	P:=Sieve.Primes[N];
	P1:=(Sieve.Primes[N-1] + Sieve.Primes[N+1]) / 2;
	if P>P1 then Result:=ptStrong
	else if P<P1 then Result:=ptWeak
	else Result:=ptBalanced;
	end;

	procedure GetPrimeCounts(PT: TPrimeTypes; var Cnt1,Cnt2: integer);
	{Get number of primes of type "PT" below 1 million and 10 million}
	var I: integer;
	begin
	Cnt1:=0; Cnt2:=0;
	for I:=1 to 1000000-1 do
		begin
		if GetPrimeType(I)=PT then
			begin
			if Sieve.Primes[I]>10000000 then break;
			Inc(Cnt2);
			if Sieve.Primes[I]<1000000 then Inc(Cnt1);
			end;
		end;
	end;


	function GetPrimeList(PT: TPrimeTypes; Limit: integer): string;
	{Get a list of primes of type PT up to Limit}
	var I,Cnt: integer;
	begin
	Result:='';
	Cnt:=0;
	for I:=1 to Sieve.PrimeCount-1 do
	 if GetPrimeType(I)=PT then
		begin
		Inc(Cnt);
		P:=Sieve.Primes[I];
		Result:=Result+Format('%5d',[P]);
		if Cnt>=Limit then break;
		if (Cnt mod 10)=0 then Result:=Result+CRLF;
		end;
	end;



	procedure ShowPrimeTypeData(PT: TPrimeTypes; Limit: Integer);
	{Display information about specified PrimeType, listing items up to Limit}
	var S,TS: string;
	begin
	S:=GetPrimeList(PT,Limit);
	TS:=GetTypeStr(PT);
	Memo.Lines.Add(Format('First %d %s primes are:',[Limit,TS]));
	Memo.Lines.Add(S);

	GetPrimeCounts(PT,Cnt1,Cnt2);
	Memo.Lines.Add(Format('Number %s primes <1,000,000:  %8.0n', [TS,Cnt1+0.0]));
	Memo.Lines.Add(Format('Number %s primes <10,000,000: %8.0n', [TS,Cnt2+0.0]));
	Memo.Lines.Add('');
	end;


begin
Sieve:=TPrimeSieve.Create;
try
Sieve.Intialize(200000000);
Memo.Lines.Add('Primes in Sieve : '+IntToStr(Sieve.PrimeCount));
ShowPrimeTypeData(ptStrong,36);
ShowPrimeTypeData(ptWeak,37);
ShowPrimeTypeData(ptBalanced,28);
finally Sieve.Free; end;
end;
