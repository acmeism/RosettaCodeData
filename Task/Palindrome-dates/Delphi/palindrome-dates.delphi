procedure ShowPalindromeDate(Memo: TMemo);
var DT: TDateTime;
var S,S2: string;
var I,Cnt: integer;
begin
Cnt:=0;
DT:=EncodeDate(2020,02,02);
for I:=0 to High(integer) do
	begin
	S:=FormatDateTime('yyyymmdd',DT);
	S2:=ReverseString(S);
	if S=S2 then
		begin
		Inc(Cnt);
		Memo.Lines.Add(IntToStr(Cnt)+' '+FormatDateTime('yyyy-mm-dd',DT));
		if Cnt>15 then break;
		end;
	DT:=DT+1;
	end;
end;
