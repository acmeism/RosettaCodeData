procedure TruncatablePrimes(Memo: TMemo);
var Sieve: TPrimeSieve;
var I,P: integer;


	function IsLeftTruncatable(P: integer): boolean;
	{A prime is Left truncatable, if you can remove digits}
	{one at a time from the left and it is still prime}
	var S: string;
	var P2: integer;
	begin
	Result:=False;
	{Conver number to string}
	S:=IntToStr(P);
	{Delete one char from the left}
	Delete(S,1,1);
	while Length(S)>0 do
		begin
		{Zeros no allowed}
		if S[1]='0' then exit;
		{Convert back to number}
		P2:=StrToInt(S);
		{Exit if it is not prime}
		if not Sieve.Flags[P2] then exit;
		{Delete next char from left}
		Delete(S,1,1);
		end;
	{If all truncated numbers are prime}
	Result:=True;
	end;


	function IsRightTruncatable(P: integer): boolean;
	{A prime is right truncatable, if you can remove digits}
	{one at a time from the right and it is still prime}
	var S: string;
	var P2: integer;
	begin
	Result:=False;
	{Conver number to string}
	S:=IntToStr(P);
	{Delete one char from the right}
	Delete(S,Length(S),1);
	while Length(S)>0 do
		begin
		{No zeros allowed}
		if S[1]='0' then exit;
		{Convert back to number}
		P2:=StrToInt(S);
		{exit if it is not prime}
		if not Sieve.Flags[P2] then exit;
		{Delete next char from the right}
		Delete(S,Length(S),1);
		end;
	{If all truncated numbers are prime}
	Result:=True;
	end;



begin
Sieve:=TPrimeSieve.Create;
try
{Look at primes under 1 million}
Sieve.Intialize(1000000);
{Look for the highest Left Truncatable prime}
{Test all primes from 1 million down}
for I:=Sieve.PrimeCount-1 downto 0 do
	begin
	P:=Sieve.Primes[I];
	{The first number that is Left Truncatable, will be the highest}
	if IsLeftTruncatable(P) then
		begin
		Memo.Lines.Add(IntToStr(P));
		break;
		end;
	end;
{Look for the highest Right Truncatable prime}
{Test all primes from 1 million down}
for I:=Sieve.PrimeCount-1 downto 0 do
	begin
	P:=Sieve.Primes[I];
	if IsRightTruncatable(P) then
		begin
		Memo.Lines.Add(IntToStr(P));
		break;
		end;
	end;
finally Sieve.Free; end;
end;
