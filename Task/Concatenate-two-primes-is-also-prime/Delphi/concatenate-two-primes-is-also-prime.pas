function Compare(P1,P2: pointer): integer;
{Compare for quick sort}
begin
Result:=Integer(P1)-Integer(P2);
end;

procedure ConcatonatePrimes(Memo: TMemo);
{Show concatonated pairs of primes that are also prime}
var List: TList;
var I,P1,P2,ConCat: integer;
var Sieve: TPrimeSieve;
const Max =100;
var S: string;

	function ConcatNums(I1,I2: integer): integer;
	begin
	Result:=StrToInt(IntToStr(I1)+IntToStr(I2));
	end;

begin
{Create sieve to for fast prime generation}
Sieve:=TPrimeSieve.Create;
try
List:=TList.Create;
try
{Sieve first 1,000 primes}
Sieve.Intialize(1000);

{Generate all combinations of primes}
{ P1 and P2, from 2 to 100}
P1:=2;
while P1<Max do
	begin
	P2:=2;
	while P2<Max do
		begin
		{Concatonates the two primes}
		ConCat:=ConcatNums(P1,P2);
		{Test if it is prime and only store unique primes}
		if IsPrime(ConCat) then
		 if List.IndexOf(Pointer(ConCat))<0 then
		  List.Add(Pointer(ConCat));
		P2:=Sieve.NextPrime(P2);
		end;
	P1:=Sieve.NextPrime(P1);
	end;
{Sort list in numerical order}
List.Sort(Compare);
{Display the result}
Memo.Lines.Add('Concatonated Primes Found: '+IntToStr(List.Count));
for I:=0 to List.Count-1 do
	begin
	S:=S+Format('%5d',[integer(List[I])]);
	if (I mod 10)=9 then S:=S+CRLF;
	end;
Memo.Lines.Add(S);
finally List.Free; end;
finally Sieve.Free; end;
end;


