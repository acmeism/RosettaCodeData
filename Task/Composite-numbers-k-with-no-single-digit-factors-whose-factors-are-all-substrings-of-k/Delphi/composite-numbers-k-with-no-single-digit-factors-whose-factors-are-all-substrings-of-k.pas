procedure MultidigitComposites(Memo: TMemo);
var I,Cnt: integer;
var IA: TIntegerDynArray;
var Sieve: TPrimeSieve;


	function MatchCriteria(N: integer): boolean;
	{Test N against Criteria}
	var I,L: integer;
	var SN,ST: string;
	begin
	Result:=False;
	{No even numbers}
	if (N and 1)=0 then exit;
	{N can't be prime}
	if Sieve[N] then exit;
	I:=3;
	SN:=IntToStr(N);
	repeat
		begin
		{Is it a factor }
		if (N mod I) = 0 then
			begin
			{No one-digit numbers}
			if I<10 then exit;
			{Factor string must be found in N's string}
			ST:=IntToStr(I);
			if Pos(ST,SN)<1 then exit;
			N:=N div I;
			end
		else I:=I+2;
		end
	until N<=1;
	Result:=True;
	end;


begin
Sieve:=TPrimeSieve.Create;
try
{Create 30 million primes}
Sieve.Intialize(30000000);
Cnt:=0;
{Smallest prime factor}
I:=11*11;
while I<High(integer) do
	begin
	{Test if I matches criteria}
	 if MatchCriteria(I) then
		begin
		Inc(Cnt);
		Memo.Lines.Add(IntToStr(Cnt)+' - '+FloatToStrF(I,ffNumber,18,0));
		if Cnt>=20 then break;
		end;
	Inc(I,2);
	end;
finally Sieve.Free; end;
end;
