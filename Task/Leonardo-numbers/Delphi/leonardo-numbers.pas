type TIntArray = array of integer;

function GetLeonardoNumbers(Cnt,SN1,SN2,Add: integer): TIntArray;
var N: integer;
begin
SetLength(Result,Cnt);
Result[0]:=SN1; Result[1]:=SN2;
for N:=2 to Cnt-1 do
	begin
	Result[N]:=Result[N-1] + Result[N-2] + Add;
	end;
end;


procedure TestLeonardoNumbers(Memo: TMemo);
var IA: TIntArray;
var S: string;
var I: integer;
begin
Memo.Lines.Add('Leonardo Numbers:');
IA:=GetLeonardoNumbers(25,1,1,1);
S:='';
for I:=0 to High(IA) do
	begin
	S:=S+' '+Format('%6d',[IA[I]]);
	if I mod 5 = 4 then S:=S+#$0D#$0A;
	end;
Memo.Lines.Add(S);
Memo.Lines.Add('Fibonacci Numbers:');
IA:=GetLeonardoNumbers(25,0,1,0);
S:='';
for I:=0 to High(IA) do
	begin
	S:=S+' '+Format('%6d',[IA[I]]);
	if I mod 5 = 4 then S:=S+#$0D#$0A;
	end;
Memo.Lines.Add(S);
end;
