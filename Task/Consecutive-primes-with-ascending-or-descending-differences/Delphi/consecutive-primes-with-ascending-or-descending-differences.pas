procedure LongestAscendDescend(Memo: TMemo);
{Find the longest Ascending and Descending sequences of primes}
var I: integer;
var Sieve: TPrimeSieve;

	procedure FindLongestSequence(Ascend: boolean);
	{Find the longest sequence - Ascend controls}
	{ whether it ascending or descending}
	var I,J,Count,BestCount,BestStart: integer;
        var S: string;

		function Compare(N1,N2: integer; Ascend: boolean): boolean;
		{Compare for ascending or descending}
		begin
		if Ascend then Result:=N1>N2
		else Result:=N1<N2;
		end;

	begin
	BestStart:=0; BestCount:=0;
	{Check all the primes in the sieve}
	for I:=2 to High(Sieve.Primes)-1 do
		begin
		J:=I + 1;
		Count:= 1;
		{Count all the elements in the sequence}
		while (j<=High(Sieve.Primes)) and
		      Compare(Sieve.Primes[J]-Sieve.Primes[J-1],Sieve.Primes[J-1]-Sieve.Primes[j-2],Ascend) do
			begin
			Inc(Count);
			Inc(J);
			end;
		{Save the info if it is the best so far}
		if Count > BestCount then
			begin
			BestStart:=I-1;
			BestCount:= Count;
			end;
		end;
	Memo.Lines.Add('Count = '+IntToStr(BestCount+1));
	{Display the sequence}
	S:='[';
	for I:=BestStart to BestStart+BestCount do
		begin
		S:=S+IntToStr(Sieve.Primes[I]);
		if I<(BestStart+BestCount) then S:=S+' ('+IntToStr(Sieve.Primes[I+1]-Sieve.Primes[I])+') ';
		end;
	S:=S+']';
	Memo.Lines.Add(S);
	end;



begin
Sieve:=TPrimeSieve.Create;
try
{Generate all primes below 1 million}
Sieve.Intialize(1000000);

Memo.Lines.Add('The longest sequence of ascending primes');
FindLongestSequence(True);
Memo.Lines.Add('The longest sequence of ascending primes');
FindLongestSequence(False);
finally Sieve.Free; end;
end;
