procedure DoPardoKnuth(Memo: TMemo; A: array of double);
var Y: double;
var I: integer;
var S: string;

	function Func(T: double): double;
	begin
	Result:=Sqrt(abs(T))+ 5*T*T*T;
	end;

begin
for I:=0 to High(A) do
	begin
	Y:=Func(A[I]);
	if y > 400 then S:='Too Large'
	else S:=Format('%f %f',[A[I],Y]);
	Memo.Lines.Add(S);
	end;
end;

procedure ShowPardoKnuth(Memo: TMemo);
begin
DoPardoKnuth(Memo, [1,2,3,4,5,6,7,8,9,10,11]);
end;
