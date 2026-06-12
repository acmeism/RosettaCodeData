function LowSquareStartN(N: byte): integer;
{Find lowest square that matches N}
var S: string;
var T,J,DR,DN,DX: integer;
begin
{Get number of digits in N}
DN:=NumberOfDigits(N);
for Result:=1 to High(Integer) do
	begin
	T:=Result*Result;
	{Divide off digits so no bigger than N}
	DR:=NumberOfDigits(T);
	DX:=DR-DN;
	for J:=1 to DX do T:=T div 10;
	{Does it match}
	if T=N then break;
	end;
end;



procedure SquareStartsN(Memo: TMemo);
{Find smallest square that begins with N}
var I,T: integer;
begin
for I:=1 to 50-1 do
	begin
	T:=LowSquareStartN(I);
	Memo.Lines.Add(IntToStr(I)+' '+IntToStr(T*T));
	end;
end;

