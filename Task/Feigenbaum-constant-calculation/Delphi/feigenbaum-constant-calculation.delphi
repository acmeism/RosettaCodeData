procedure FeigenbaumConstant(Memo: TMemo);
{ Calculate the Feigenbaum constant }
const IMax = 13;
const JMax = 10;
var I,J,K: integer;
var A1,A2,D1,X,Y: double;
var A,D: double;
begin
Memo.Lines.Add('Feigenbaum constant calculation:');
{Set initial starting values for iterations}
A1:=1.0; A2:=0.0; D1:=3.2;
Memo.Lines.Add(' I           A           D');
for I:=2 to IMax do
	begin
	{Find next Bifurcation parameter, A}
	A:=A1 + (A1 - A2) / D1;
	for J:=1 to JMax do
		begin
		X:=0; Y:=0;
		for K:=1 to 1 shl i do
			begin
			Y:=1 - 2 * y * x;
			X:=A - X * X
			end;
		A:=A - X / Y
		end;
	{Use current and previous values of A}
	{to calculate the Feigenbaum constant D }
	D:= (A1 - A2) / (A - A1);
	Memo.Lines.Add(Format('%2d  %2.8f  %2.8f',[I,A,D]));
	D1:=D; A2:=A1; A1:=A;
	end;
end;
