procedure DoFairshare(Memo: TMemo; Base: integer);
{Display 25 fairshare sequence items}
var I, N, Sum: integer;
var S: string;
begin
S:=Format('Base - %2d: ',[Base]);
for I:= 0 to 25-1 do
    begin
    N:= I; Sum:= 0;
    while N>0 do
    	begin
    	Sum:= Sum + (N mod Base);
    	N:= N div Base;
    	end;
    S:=S+' '+IntToStr(Sum mod Base);
    end;
Memo.Lines.Add(S);
end;


procedure ShowFairshare(Memo: TMemo);
begin
DoFairshare(Memo,2);
DoFairshare(Memo,3);
DoFairshare(Memo,5);
DoFairshare(Memo,11);
end;
