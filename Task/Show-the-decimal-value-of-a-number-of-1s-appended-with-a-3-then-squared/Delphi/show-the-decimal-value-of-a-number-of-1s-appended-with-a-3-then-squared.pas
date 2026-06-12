procedure OnesPlusThree(Memo: TMemo);
{Create pattern: 3, 13, 113, 1113, and square}
var NS: string;
var I: integer;
var NV: int64;
begin
{Start with 3 in number string}
NS:='3';
for I:=1 to 7 do
	begin
	{Convert to a number}
	NV:=StrToInt(NS);
	Memo.Lines.Add(Format('%2D - %10d^2 =%18.0n',[I,NV,NV*NV+0.0]));
	{Add a "1" to the number string}
	NS:='1'+NS;
	end;
end;

