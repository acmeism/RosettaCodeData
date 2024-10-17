function GetMagicNumber(N: double): double;
begin
Result:=N * (((N * N) + 1) / 2);
end;

function GetNumberLess(N: double): integer;
var M: double;
begin
for Result:=1 to High(Integer) do
	begin
	M:=GetMagicNumber(Result);
	if M>N then break;
	end;
end;

procedure ShowMagicNumber(Memo: TMemo);
var I,J: integer;
var N,M: double;
var S: string;
begin
S:='';
for I:=3 to 23 do
	begin
	S:=S+Format('%8.0n',[GetMagicNumber(I)]);
	if (I mod 5)=2 then S:=S+#$0D#$0A;
	end;
Memo.Lines.Add(S);
Memo.Lines.Add('');
Memo.Lines.Add('1000th: '+Format('%8.0n',[GetMagicNumber(1002)]));
Memo.Lines.Add('');
N:=10;
for I:=1 to 20 do
	begin
	J:=GetNumberLess(N);
	Memo.Lines.Add('M^'+Format('%d%8d',[I,J]));
	N:=N * 10;
	end;
end;
