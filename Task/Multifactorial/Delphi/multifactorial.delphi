function MultiFact(Num,Deg: integer): integer;
{Multifactorial from Degree and Number}
var N: integer;
begin
N:=Num;
Result:=Num;
if N = 0 then Result:=1
else while true do
	begin
	N := N - deg;
	if N<1 then break;
	Result:=Result * N;
	end;
end;


procedure ShowMultifactorial(Memo: TMemo);
{Show combinations of deg/num of multifactorial}
var Deg,Num: integer;
var S: string;
begin
S:='';
for Deg:=1 to 5 do
	begin
	S:=S+Format('Degree: %d:',[Deg]);
	for Num:=1 to 10 do S:=S+' '+Format('%7d',[MultiFact(Num,Deg)]);
	S:=S+#$0D#$0A;
	end;
Memo.Lines.Add(S);
end;
