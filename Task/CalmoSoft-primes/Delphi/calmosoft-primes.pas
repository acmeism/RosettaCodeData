type TLongInfo = record
 RangeStart,RangeStop: integer;
 SeqStart,SeqStop: integer;
 Count,Sum: integer;
 end;

procedure CalmoSoftPrimes(Memo: TMemo);
{Find longest sequence of prime numbers that adds up to a prime}
var Sieve: TPrimeSieve;
var Best,Tmp: TLongInfo;
var I,Cnt: integer;
var S: string;

	function GetLongest(N,Limit: integer): TLongInfo;
	{Get longest sequence starting at N}
	{Find longest sequence of primes whose sum is prime}
	var Next,Sum,Cnt: integer;
	begin
	Result.Count:=1;
	Result.SeqStart:=N;
	Result.SeqStop:=N;
	Result.Sum:=1;
	Sum:=N; Next:=N;
	Cnt:=1;
	while true do
		begin
		Next:=Sieve.NextPrime(Next);
		if Next>Limit then break;
		Sum:=Sum+Next;
		Inc(Cnt);
		if IsPrime(Sum) then
			begin
			Result.SeqStop:=Next;
			Result.Count:=Cnt;
			Result.Sum:=Sum;
			end;
		end;
	end;


	function LongestRange(Start,Limit: integer): TLongInfo;
	{Find longest sequence between Start and Limit}
	{Start should be a prime number}
	var I: integer;
	begin
	I:=Start;
	Result.SeqStart:=0;
	Result.SeqStop:=0;
	Result.Count:=0;
	while I<=Limit do
		begin
		Tmp:=GetLongest(I,Limit);
		if Tmp.Count>Result.Count then Result:=Tmp;
		I:=Sieve.NextPrime(I);
		end;
	Result.RangeStart:=Start;
	Result.RangeStop:=Limit;
	end;


	procedure ShowSequenceHeader(Best: TLongInfo);
	{Show summary of information}
	begin
	Memo.Lines.Add('Range: '+IntToStr(Best.RangeStart)+' '+IntToStr(Best.RangeStop));
	Memo.Lines.Add('Longest Sequence: '+IntToStr(Best.Count));
	Memo.Lines.Add('Sum: '+IntToStr(Best.Sum));
	end;



	procedure ShowSequence(Best: TLongInfo; Start,Limit: integer);
	{Extract sequence info from best and display it}
	var S: string;
	var I,Cnt: integer;
	begin
	S:=''; Cnt:=0;
	{if Start=0 display full range other wise}
	{display from start to limit}
	if Start=0 then I:=Best.SeqStart
	else I:=Start;
	while I<=Best.SeqStop do
		begin
		Inc(Cnt);
		S:=S+Format('%5d',[I]);
		if (Cnt mod 10)=0 then S:=S+CRLF;
		if Cnt>=Limit then break;
		I:=Sieve.NextPrime(I);
		end;
	Memo.Lines.Add(S);
	end;


	procedure ShowHeaderSequence(Best: TLongInfo);
	{Show header and sequence}
	begin
	ShowSequenceHeader(Best);
	ShowSequence(Best,0,high(integer));
	end;



begin
Sieve:=TPrimeSieve.Create;
try
{Create enough primes to cover range}
Sieve.Intialize(1000);
{Find longest sequence in range}
Best:=LongestRange(2,100);
ShowHeaderSequence(Best);
finally Sieve.Free; end;
end;


