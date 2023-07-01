uses SysUtils,StdCtrls;

procedure CullenWoodallTest(Memo: TMemo);

implementation

procedure FindCullenNumbers(Memo: TMemo);
var N,R: integer;
var S: string;
begin
S:='';
Memo.Lines.Add('First 20 Cullen Numbers:');
for N:=1 to 20 do
	begin
	R:=N * (1 shl N) + 1;
	S:=S+IntToStr(R)+' ';
	end;
Memo.Lines.Add(S);
end;


procedure FindWoodallNumbers(Memo: TMemo);
var N,R: integer;
var S: string;
begin
S:='';
Memo.Lines.Add('First 20 Woodall  Numbers:');
for N:=1 to 20 do
	begin
	R:=N * (1 shl N) - 1;
	S:=S+IntToStr(R)+' ';
	end;
Memo.Lines.Add(S);
end;


procedure CullenWoodallTest(Memo: TMemo);
begin
FindCullenNumbers(Memo);
FindWoodallNumbers(Memo);
end;
