const TestOrder: array [0..11] of string =
   ('Blue','Blue','White','Blue','White','Blue',
    'Red','White','White','Blue','White','Red');


procedure DoDutchFlag(Memo: TMemo; Order: array of string);
{Solve dutch flag color order using TStringList component}
{Encode colors "Red", "White" and "Blue" to "1", "2", and "3" }
{This allows them to be sorted in the TString List}
var I: integer;
var SL: TStringList;
var S2: string;

	function DecodeList(SL: TStringList): string;
	{Convert encoded colors 1, 2 and 3 to Red, White and Blue}
	var I: integer;
	begin
	Result:='';
	for I:=0 to SL.Count-1 do
		begin
		if I>0 then Result:=Result+',';
		if SL[I]='1' then Result:=Result+'Red'
		else if SL[I]='2' then Result:=Result+'White'
		else Result:=Result+'Blue'
		end;
	end;

begin
SL:=TStringList.Create;
try
{Encode colors from array of strings}
for I:=0 to High(TestOrder) do
	begin
	if Order[I]='Red' then SL.Add('1')
	else if Order[I]='White' then SL.Add('2')
	else SL.Add('3');
	end;
Memo.Lines.Add('Original Order:');
Memo.Lines.Add('['+DecodeList(SL)+']');
SL.Sort;
Memo.Lines.Add('Original Order:');
Memo.Lines.Add('['+DecodeList(SL)+']');
finally SL.Free; end;
end;


procedure ShowDutchFlag(Memo: TMemo);
begin
DoDutchFlag(Memo,TestOrder);
end;
