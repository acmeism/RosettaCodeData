procedure FindSmallest(LS: TList; var Index,Value: Integer);
{Find smallest value in LIst}
var I: integer;
begin
Value:=High(integer);
for I:=0 to LS.Count-1 do
 if integer(LS[I])<Value then
	begin
	Value:=integer(LS[I]);
	Index:=I;
	end;
end;


procedure ShowArray(Memo: TMemo; LS: TList);
{Display the contents of specified array}
var I: integer;
var S: string;
begin
S:='[';
for I:=0 to LS.Count-1 do
	begin
	if I>0 then S:=S+' ';
	S:=S+IntToStr(Integer(LS[I]));
	end;
S:=S+']';
Memo.Lines.Add(S);
end;


procedure LastItem(Memo: TMemo; IA: array of integer);
{Repeatedly remove the two lowest values}
{Add them together and add to the list}
var LS: TList;
var I,Inx,Val1,Val2: integer;
begin
LS:=TList.Create;
try
for I:=0 to High(IA) do LS.Add(Pointer(IA[I]));
while LS.Count>1 do
	begin
	ShowArray(Memo,LS);
	FindSmallest(LS,Inx,Val1);
	LS.Delete(Inx);
	FindSmallest(LS,Inx,Val2);
	LS.Delete(Inx);
	LS.Add(Pointer(Val1 + Val2))
	end;
Memo.Lines.Add(IntToStr(integer(LS[0])));
finally LS.Free; end;
end;

{Supplied test array}

const IntArray: array [0..8] of integer=(6, 81, 243, 14, 25, 49, 123, 69, 11);

procedure DoLastItem(Memo: TMemo);
{Do last item problem}
begin
LastItem(Memo,IntArray);
end;


