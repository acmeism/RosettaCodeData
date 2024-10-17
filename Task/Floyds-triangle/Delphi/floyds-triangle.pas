procedure FloydsTriangle(Memo: TMemo; Rows: integer);
var I,R,C: integer;
var S: string;
begin
I:=1;
S:='';
for R:=1 to Rows do
	begin
	for C:=1 to R do
		begin
		S:=S+Format('%4d',[I]);
		Inc(I);
		end;
	S:=S+#$0D#$0A;
	end;
Memo.Lines.Add(S);
end;


procedure ShowFloydsTriangles(Memo: TMemo);
begin
FloydsTriangle(Memo,5);
FloydsTriangle(Memo,14);
end;
