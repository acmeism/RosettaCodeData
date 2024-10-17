procedure PrimeCompositeSums(Memo: TMemo);
{Find places where the prime and composite sums match}
var Sieve: TPrimeSieve;
var I,P,C,Count: integer;
var CSumArray,PSumArray: TInt64DynArray;
var CSum,PSum: int64;
var S: string;
begin
Sieve:=TPrimeSieve.Create;
try
{Build 10 million primes}
Sieve.Intialize(10000000);
{Build arrays of Prime and Composite sums}
SetLength(CSumArray,0);
SetLength(PSumArray,0);
CSum:=0; PSum:=0;
for I:=2 to Sieve.Count-1 do
 if Sieve.Flags[I] then
	begin
	PSum:=PSum+I;
	SetLength(PSumArray,Length(PSumArray)+1);
	PSumArray[High(PSumArray)]:=PSum;
	end
 else
	begin
	CSum:=CSum+I;
	SetLength(CSumArray,Length(CSumArray)+1);
	CSumArray[High(CSumArray)]:=CSum;
	end;
Memo.Lines.Add('Sum                   | Prime Index  | Composite Index');
Memo.Lines.Add('------------------------------------------------------');
P:=0;C:=0;
Count:=0;
{Traverse the prime and composite sum looking for places they match}
while true do
	begin
	if PSumArray[P]=CSumArray[C] then
		begin
		Inc(Count);
		Memo.Lines.Add(Format('%d %19.0n | %12d | %15d',[Count,PSumArray[P]+0.0,P+1,C+1]));
		if Count>=8 then break;
		end;
	{Increment the index of array that is behind}
	if PSumArray[P]<CSumArray[C] then Inc(P)
	else Inc(C);
	end;
finally Sieve.Free; end;
end;
