procedure FillSquare(Memo: TMemo; Size: integer);
var X,Y: integer;
var S: string;
begin
S:='';
for Y:=1 to Size do
	begin
	for X:=1 to Size do
		begin
		if (X=1) or (X=Size) or
		   (Y=1) or (Y=Size) then S:=S+' 1'
		else S:=S+' 0';
		end;
	S:=S+#$0D#$0A;
	end;
Memo.Lines.Add(S);
end;

procedure ShowFillSquare(Memo: TMemo);
begin
FillSquare(Memo, 6);
FillSquare(Memo, 7);
end;


