function Compare(P1,P2: pointer): integer;
{Compare for quick sort}
begin
Result:=Integer(P1)-Integer(P2);
end;

procedure GetBrilliantNumbers(List: TList; Limit: integer);
{Return specified number of Brilliant Numbers in list}
var I,J,P,Stop: integer;
var Sieve: TPrimeSieve;
begin
Sieve:=TPrimeSieve.Create;
try
{build twices as many primes}
Sieve.Intialize(Limit*2);
{Pair every n-digt prime with every n-digit prime}
I:=2;
while true do
	begin
	J:=I;
	{Put primes in J up to next power of 10 - 1}
	Stop:=Trunc(Power(10,Trunc(Log10(I))+1));
	while J<Stop do
		begin
		{Get the product}
		P:=I * J;
		{and store in the list}
		List.Add(Pointer(P));
		{Exit if we have all the numbers}
		if List.Count>=Limit then break;
		{Get next prime}
		J:=Sieve.NextPrime(J);
		end;
	{break out of outer loop if done}
	if List.Count>=Limit then break;
	{Get next prime}
	I:=Sieve.NextPrime(I);
	end;
{The list won't be in order, so sort them}
List.Sort(Compare);
finally Sieve.Free; end;
end;


procedure ShowBrilliantNumbers(Memo: TMemo);
var List: TList;
var S: string;
var I,D,P: integer;
begin
List:=TList.Create;
try
{Get 10 million brilliant numbers}
GetBrilliantNumbers(List,1000000);
{Show the first 100}
S:='';
for I:=0 to 100-1 do
	begin
	S:=S+Format('%7d',[Integer(List[I])]);
	if (I mod 10)=9 then S:=S+CRLF;
	end;
Memo.Lines.Add(S);
{Show additional information}
for D:=1 to 8 do
	begin
	P:=Trunc(Power(10,D));
	{Scan to find for 1st brilliant number >= 10^D }
	for I:=0 to List.Count-1 do
	 if Integer(List[I])>=P then break;
	{Display the info}
	S:=Format('First brilliant number >= 10^%d is %10d',[D,Integer(List[I])]);
	S:=S+Format(' at position %10D', [I]);
	Memo.Lines.Add(S);
	end;
finally List.Free; end;
end;
