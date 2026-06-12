function IntRoot(Base: int64; N: cardinal): int64;
var N1: cardinal;
var N2,N3,C: int64;
var D,E: int64;
begin
if Base < 2 then Result:=Base
else if N = 0 then Result:=1
else
	begin
	N1:=N - 1;
	N2:=N;
	N3:=N1;
	C:=1;
	d:=round((N3 + Base) / N2);
	e:=round((N3 * D + Base / Power(D, N1)) / N2);
	while (C<>D) and (C<>E) do
		begin
		C:=D;
		D:=E;
		E:=Round((N3*E + Base / Power(E, N1)) / N2);
		end;
	if D < E then Result:=D
	else Result:=E;
	end;
end;


procedure ShowIntegerRoots(Memo: TMemo);
var Base: int64;
begin
Memo.Lines.Add('3rd integer root of 8 = '+IntToStr(IntRoot(8, 3)));
Memo.Lines.Add('3rd integer root of 9 = '+IntToStr(IntRoot(9, 3)));
Base:=2000000000000000000;
Memo.Lines.Add('sqaure root of 2 = '+IntToStr(IntRoot(Base, 2)));
end;



