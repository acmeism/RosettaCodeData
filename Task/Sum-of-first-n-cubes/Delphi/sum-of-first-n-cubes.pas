procedure ShowSumFirst50Cubes(Memo: TMemo);
var I,Sum: integer;
var S: string;
begin
S:='';
Sum:=0;
for I:=0 to 50-1 do
	begin
	Sum:=Sum+I*I*I;
	S:=S+Format('%11.0n',[Sum+0.0]);
	if (I mod 5)=4 then S:=S+CRLF;
	end;
Memo.Lines.Add(S);
end;


