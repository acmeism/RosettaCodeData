{Dynamic array of pointers}

type TPointerArray = array of Pointer;

procedure QuickSort(SortList: TPointerArray; L, R: Integer; SCompare: TListSortCompare);
{Do quick sort on items held in TPointerArray}
{SCompare controls how the pointers are interpreted}
var I, J: Integer;
var P,T: Pointer;
begin
repeat
	begin
	I := L;
	J := R;
	P := SortList[(L + R) shr 1];
	repeat
		begin
		while SCompare(SortList[I], P) < 0 do Inc(I);
		while SCompare(SortList[J], P) > 0 do Dec(J);
		if I <= J then
			begin
			{Exchange itesm}
			T:=SortList[I];
			SortList[I]:=SortList[J];
			SortList[J]:=T;
			if P = SortList[I] then P := SortList[J]
			else if P = SortList[J] then P := SortList[I];
			Inc(I);
			Dec(J);
			end;
		end
	until I > J;
	if L < J then QuickSort(SortList, L, J, SCompare);
	L := I;
	end
until I >= R;
end;



procedure DisplayStrings(Memo: TMemo; PA: TPointerArray);
{Display pointers as strings}
var I: integer;
var S: string;
begin
S:='[';
for I:=0 to High(PA) do
	begin
	if I>0 then S:=S+' ';
	S:=S+string(PA[I]^);
	end;
S:=S+']';
Memo.Lines.Add(S);
end;


procedure DisplayIntegers(Memo: TMemo; PA: TPointerArray);
{Display pointer array as integers}
var I: integer;
var S: string;
begin
S:='[';
for I:=0 to High(PA) do
	begin
	if I>0 then S:=S+' ';
	S:=S+IntToStr(Integer(PA[I]));
	end;
S:=S+']';
Memo.Lines.Add(S);
end;


function IntCompare(Item1, Item2: Pointer): Integer;
{Compare for integer sort}
begin
Result:=Integer(Item1)-Integer(Item2);
end;



function StringCompare(Item1, Item2: Pointer): Integer;
{Compare for alphabetical string sort}
begin
Result:=AnsiCompareText(string(Item1^),string(Item2^));
end;

function StringRevCompare(Item1, Item2: Pointer): Integer;
{Compare for reverse alphabetical order}
begin
Result:=AnsiCompareText(string(Item2^),string(Item1^));
end;


function StringLenCompare(Item1, Item2: Pointer): Integer;
{Compare for string length sort}
begin
Result:=Length(string(Item1^))-Length(string(Item2^));
end;

{Arrays of strings and integers}

var IA: array [0..9] of integer = (23, 14, 62, 28, 56, 91, 33, 30, 75, 5);
var SA: array [0..15] of string = ('Now','is','the','time','for','all','good','men','to','come','to','the','aid','of','the','party.');

procedure ShowQuickSort(Memo: TMemo);
var L: TStringList;
var PA: TPointerArray;
var I: integer;
begin
Memo.Lines.Add('Integer Sort');
SetLength(PA,Length(IA));
for I:=0 to High(IA) do PA[I]:=Pointer(IA[I]);
Memo.Lines.Add('Before Sorting');
DisplayIntegers(Memo,PA);
QuickSort(PA,0,High(PA),IntCompare);
Memo.Lines.Add('After Sorting');
DisplayIntegers(Memo,PA);

Memo.Lines.Add('');
Memo.Lines.Add('String Sort - Alphabetical');
SetLength(PA,Length(SA));
for I:=0 to High(SA) do PA[I]:=Pointer(@SA[I]);
Memo.Lines.Add('Before Sorting');
DisplayStrings(Memo,PA);
QuickSort(PA,0,High(PA),StringCompare);
Memo.Lines.Add('After Sorting');
DisplayStrings(Memo,PA);

Memo.Lines.Add('');
Memo.Lines.Add('String Sort - Reverse Alphabetical');
QuickSort(PA,0,High(PA),StringRevCompare);
Memo.Lines.Add('After Sorting');
DisplayStrings(Memo,PA);

Memo.Lines.Add('');
Memo.Lines.Add('String Sort - By Length');
QuickSort(PA,0,High(PA),StringLenCompare);
Memo.Lines.Add('After Sorting');
DisplayStrings(Memo,PA);
end;
