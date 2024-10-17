procedure FindTriples(Memo: TMemo; Max,Angle,Coeff: integer);
var Count,A,B,C: integer;
var S: string;
begin
Memo.Lines.Add(Format('Gamma= %d°',[Angle]));
Count:=0;
S:='';
for A:=1 to Max do
 for B:=1 to A do
  for C:=1 to Max do
   if A*A+B*B-Coeff*A*B=C*C then
	begin
	Inc(Count);
	S:=S+Format('(%d,%d,%d) ',[A,B,C]);
	if (Count mod 3)=0 then S:=S+CRLF;
	end;
Memo.Lines.Add(Format('Number of triangles = %d',[Count]));
Memo.Lines.Add(S);
end;



procedure LawOfCosines(Memo: TMemo);
begin
FindTriples(Memo,13,90,0);
FindTriples(Memo,13,60,1);
FindTriples(Memo,13,120,-1);
end;
