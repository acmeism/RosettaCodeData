procedure SpinningRod(Memo: TMemo);
var I: integer;
const CA: array [0..3] of char = ('|','/','-','\');
begin
LastKey:=#0;
for I:=0 to 1000 do
	begin
	Memo.SetFocus;
	Memo.Lines.Clear;
	Memo.Lines.Add(CA[I mod 4]+' - Press Any Key To Stop');
	Sleep(250);
	if (LastKey<>#0) or Application.Terminated then break;
	Application.ProcessMessages;
	end;
end;
