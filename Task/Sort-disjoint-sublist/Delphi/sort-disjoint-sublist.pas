{Test values}

var Values: array [0..7] of integer = (7, 6, 5, 4, 3, 2, 1, 0);
var indices: array [0..2] of integer = (6, 1, 7);

function CompareValues(Item1, Item2: Pointer): Integer;
{Compare the values pointed to by the indices}
begin
Result:=Values[integer(Item1)]-Values[integer(Item2)];
end;

function CompareIndices(Item1, Item2: Pointer): Integer;
{Compare the indices themselves}
begin
Result:=integer(Item1)-integer(Item2);
end;

procedure SortDisjointSublist(Memo: TMemo);
var L1,L2: TList;
var I,Inx1,Inx2: integer;
var OutList: TIntegerDynArray;
var S: string;
begin
L1:=TList.Create;
L2:=TList.Create;
try
{Copy values array to output array}
SetLength(OutList,Length(Values));
for I:=0 to High(Values) do OutList[I]:=Values[I];
{Load two lists with the indices}
for I:=0 to High(Indices) do
	begin
	L1.Add(Pointer(Indices[I]));
	L2.Add(Pointer(Indices[I]));
	end;
{Sort by index and by value}
L1.Sort(CompareValues);
L2.Sort(CompareIndices);
{Copy the sorted values through the sorted indices}
for I:=0 to L1.Count-1 do
  OutList[Integer(L2[I])]:=Values[Integer(L1[I])];
{Display the result}
S:='[';
for I:=0 to High(OutLIst) do
 	begin
	if I>0 then S:=S+' ';
 	S:=S+IntToStr(OutList[I]);
 	end;
S:=S+']';
Memo.Lines.Add(S);
finally
 L1.Free;
 L2.Free;
 end;
end;
