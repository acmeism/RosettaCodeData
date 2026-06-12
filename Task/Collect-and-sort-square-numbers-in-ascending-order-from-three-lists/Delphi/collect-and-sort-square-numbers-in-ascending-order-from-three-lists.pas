const List1: array [0..8] of integer = (3,4,34,25,9,12,36,56,36);
const List2: array [0..8] of integer = (2,8,81,169,34,55,76,49,7);
const List3: array [0..7] of integer = (75,121,75,144,35,16,46,35);


function Compare(P1,P2: pointer): integer;
{Compare for quick sort}
begin
Result:=Integer(P1)-Integer(P2);
end;


procedure SortedSquareNumbers(Memo: TMemo);
{Find and sort numbers that are perfect squares}
var I: integer;
var NumList: TList;
var S: string;

	procedure LoadList(L: array of integer);
	{Load only perfect squares from one of the list }
	var I: integer;
	begin
	for I:=0 to High(L) do
	 if  Sqr(Trunc(Sqrt(L[I])))=L[I] then
	 NumList.Add(Pointer(L[I]));
	end;

begin
NumList:=TList.Create;
try
LoadList(List1);
LoadList(List2);
LoadList(List3);
NumList.Sort(Compare);
S:='';
for I:=0 to NumList.Count-1 do
 S:=S+' '+IntToStr(Integer(NumList[I]));
Memo.Lines.Add(S);
finally NumList.Free; end;
end;
