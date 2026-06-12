procedure FindDistinctPowers(Memo: TMemo);
{Display list of numbers a^b sort and exclude duplicates}
{tricks Delphi TStringGrid into sorting numerically}
var A,B,I,P: integer;
var SL: TStringList;
begin
SL:=TStringList.Create;
try
SL.Duplicates:=dupIgnore;
SL.Sorted:=True;
for A:=2 to 5 do
 for B:=2 to 5 do
	begin
	P:=Trunc(Power(A,B));
	{Add leading zeros to number so it sorts numerically}
	SL.AddObject(FormatFloat('00000',P),Pointer(P));
	end;
Memo.Text:=IntToStr(integer(SL.Objects[0]));
for I:=1 to SL.Count-1 do Memo.Text:=Memo.Text+','+IntToStr(integer(SL.Objects[I]));
finally SL.Free; end;
end;


