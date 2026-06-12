function EdgeDistance(P: TPoint; Size: integer): integer;
{Find the distance to the nearest edge}
begin
Result:=Min(Min(P.X,(Size-1)-P.X),Min(P.Y,(Size-1)-P.Y));
end;


procedure MapMatrix(Memo: TMemo; Size: integer);
{Map each cell in Size X Size matrix}
{with the distance to nearest edge}
var X,Y,E: integer;
var S: string;
begin
Memo.Lines.Add(Format('Map for %d X %d Matrix',[Size,Size]));
S:='';
for Y:=0 to Size-1 do
	begin
	for X:=0 to Size-1 do
		begin
		E:=EdgeDistance(Point(X,Y),Size);
		S:=S+Format('%3d',[E]);
		end;
	S:=S+#$0D#$0A;
	end;
Memo.Lines.Add(S);
end;


procedure ShowEdgeMaps(Memo: TMemo);
{Show a series of maps for matrices of different sizes}
var I: integer;
begin
for I:=3 to 12 do MapMatrix(Memo,I);
end;

