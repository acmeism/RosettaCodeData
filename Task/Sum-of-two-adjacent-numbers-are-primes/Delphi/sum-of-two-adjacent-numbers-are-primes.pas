procedure AdjacentPrimeSums(Memo: TMemo);
var I,Sum,Cnt: integer;
var S: string;
begin
Cnt:=0;
S:='';
for I:=0 to High(I) do
 if IsPrime(I+I+1) then
	begin
	Inc(Cnt);
	Memo.Lines.Add(Format('%3d %3d+%3d=%4d',[Cnt,I,I+1,I+I+1]));
	if Cnt>=20 then break
	end;
end;




