{Raw data to process}

var NumList: array [0..8] of integer = (2,43,81,122,63,13,7,95,103);

function Compare(P1,P2: pointer): integer;
{Compare for quick sort}
begin
Result:=Integer(P1)-Integer(P2);
end;

procedure GetSortedPrimes(Nums: Array of integer; var IA: TIntegerDynArray);
{Extract data from array "Nums" and return a sorted list of primes}
var I: integer;
var List: TList;
begin
List:=TList.Create;
try
{Put the primes in the TList object}
for I:=0 to High(Nums) do
 if IsPrime(Nums[I]) then List.Add(Pointer(Nums[I]));
{Sort the list}
List.Sort(Compare);
{Put the result in array}
SetLength(IA,List.Count);
for I:=0 to List.Count-1 do
 IA[I]:=Integer(List[I]);
finally List.Free; end;
end;


function ArrayToStr(Nums: array of integer): string;
{Convert array of integers to a string}
var I: integer;
begin
Result:='[';
for I:=0 to High(Nums) do
	begin
	if I<>0 then Result:=Result+',';
	Result:=Result+IntToStr(Nums[I]);
	end;
Result:=Result+']';
end;


procedure ShowSortedPrimes(Memo: TMemo);
var I: integer;
var IA: TIntegerDynArray;
var S: string;
begin
GetSortedPrimes(NumList,IA);
Memo.Lines.Add('Raw data:      '+ArrayToStr(NumList));
Memo.Lines.Add('Sorted Primes: '+ArrayToStr(IA));
end;


