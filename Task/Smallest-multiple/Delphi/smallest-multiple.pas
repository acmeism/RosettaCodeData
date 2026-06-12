function IsDivisible120(N: integer): boolean;
{Is N evenly divisible by numbers 1..20}
var I: integer;
begin
Result:=False;
{For speed - larger numbers less likely divisor}
for I:=20 downto 2 do
 if (N mod I)<>0 then exit;
Result:=True;
end;


procedure SmallestDivide120(Memo: TMemo);
var I: integer;
begin
{Only look at even numbers for speed}
for I:=1 to High(Integer) do
 if IsDivisible120(I*2) then
	begin
	Memo.Lines.Add(FloatToStrF(I*2,ffNumber,18,0));
	break;
	end;
end;


