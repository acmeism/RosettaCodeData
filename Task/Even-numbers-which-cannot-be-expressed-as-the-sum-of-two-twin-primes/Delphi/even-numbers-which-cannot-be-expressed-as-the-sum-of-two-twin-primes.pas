procedure ShowSumTwinPrimes(Memo: TMemo);
var Sieve: TPrimeSieve;
var Twins: TIntegerDynArray;
var S: string;

	procedure GetTwinPrimes(WithOne: boolean);
	{Build list of twin primes - include one, WithOne is true}
	var I,P1,P2: integer;
	begin
	{Add one to list?}
	if WithOne then
		begin
		SetLength(Twins,1);
		Twins[0]:=1;
		end
	else SetLength(Twins,0);
	{Look for numbers that P-1 or P+1 are two apart}
	for I:=0 to Sieve.PrimeCount-1 do
	 if ((I>0) and ((Sieve.Primes[I]-Sieve.Primes[I-1]) = 2)) or
	    ((I<(Sieve.PrimeCount-1)) and ((Sieve.Primes[I+1]-Sieve.Primes[I]) = 2)) then
	 	begin
	 	{Store twin}
	 	SetLength(Twins,Length(Twins)+1);
	 	Twins[High(Twins)]:=Sieve.Primes[I];
	 	end;
	end;


	function IsNotTwinPrimeSum(N: integer): boolean;
	{Test if number is NOT the sum of twin primes}
	var I,J,Sum: integer;
	begin
	Result:=False;
	{Test all combination of twin-prime sums}
	for I:=0 to High(Twins) do
	 for J:=0 to High(Twins) do
		begin
		Sum:=Twins[I]+Twins[J];
	        if Sum>N then break;
	        if Sum=N then exit;
		end;
	Result:=True;
	end;


	function GetItems: string;
	{Get first 5000 non twin prime sums}
	var I,N,Cnt: integer;
	begin
	Result:=''; Cnt:=0;
	for I:=1 to (5000 div 2)-1 do
		begin
		N:=I * 2;
		if IsNotTwinPrimeSum(N) then
			begin
			Inc(Cnt);
			Result:=Result+Format('%5d',[N]);
			if (Cnt mod 10)=0 then Result:=Result+CRLF;
			end;
		end;
	end;

begin
Sieve:=TPrimeSieve.Create;
try
Sieve.Intialize(1000000);
GetTwinPrimes(False);
Memo.Lines.Add('Non twin prime sums:');
Memo.Lines.Add(GetItems);
GetTwinPrimes(True);
Memo.Lines.Add('Non twin prime sums with one:');
Memo.Lines.Add(GetItems);
finally Sieve.Free; end;
end;


