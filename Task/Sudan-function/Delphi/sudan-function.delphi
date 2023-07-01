function SudanFunction(N,X,Y: integer): integer;
begin
if n = 0 then Result:=X + Y
else if y = 0 then Result:=X
else Result:=SudanFunction(N - 1, SudanFunction(N, X, Y - 1), SudanFunction(N, X, Y - 1) + Y);
end;


procedure ShowSudanFunction(Memo: TMemo; N,X,Y: integer);
begin
Memo.Lines.Add(Format('Sudan(%d,%d,%d)=%d',[n,x,y,SudanFunction(N,X,Y)]));
end;


procedure ShowSudanFunctions(Memo: TMemo);
var N,X,Y: integer;
var S: string;
begin
for N:=0 to 1 do
	begin
	Memo.Lines.Add(Format('Sudan(%d,X,Y)',[N]));
	Memo.Lines.Add('Y/X    0   1   2   3   4   5');
	Memo.Lines.Add('----------------------------');
	for Y:=0 to 6 do
		begin
		S:=Format('%2d | ',[Y]);
		for X:=0 to 5 do
			begin
			S:=S+Format('%3d ',[SudanFunction(N,X,Y)]);
			end;
		Memo.Lines.Add(S);
		end;
	Memo.Lines.Add('');
	end;

ShowSudanFunction(Memo, 1, 3, 3);
ShowSudanFunction(Memo, 2, 1, 1);
ShowSudanFunction(Memo, 2, 2, 1);
ShowSudanFunction(Memo, 3, 1, 1);
end;
