procedure StoogeSort(var L: array of integer; I,J: integer);
var T,M: integer;
begin
if L[j] < L[i] then
	begin
	M:=L[I];
	L[I]:=L[J];
	L[J]:=M;
	end;
if (J - I) > 1 then
	begin
	T:=(J - I + 1) div 3;
	StoogeSort(L, I, J-T);
	StoogeSort(L, I+T, J);
	StoogeSort(L, I, J-T);
	end;
end;


procedure DoStoogeSort(var L: array of integer);
begin
StoogeSort(L,0,High(L));
end;


var TestData: array [0..9] of integer = (17, 23, 21, 56, 14, 10, 5, 2, 30, 25);


function GetArrayStr(IA: array of integer): string;
var I: integer;
begin
Result:='[';
for I:=0 to High(IA) do
 	begin
	if I>0 then Result:=Result+' ';
 	Result:=Result+Format('%3d',[IA[I]]);
 	end;
Result:=Result+']';
end;

procedure ShowStoogeSort(Memo: TMemo);
begin
Memo.Lines.Add('Raw Data:    '+GetArrayStr(TestData));
DoStoogeSort(TestData);
Memo.Lines.Add('Sorted Data: '+GetArrayStr(TestData));
end;
