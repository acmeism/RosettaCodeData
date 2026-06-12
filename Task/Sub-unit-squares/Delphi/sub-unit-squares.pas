function IsSubUnitSquare(SQ: integer): boolean;
{Returns true if you subtract one from each digit}
{and it is still square. Assume SQ is square}
var I,J: integer;
var IA: TIntegerDynArray;
begin
Result:=False;
{Get all digits}
GetDigits(SQ,IA);
{Subtract one from each digit}
for J:=0 to High(IA) do
	begin
	{Zeros not allowed = they would cause negative digits}
	if IA[J]=0 then exit;
	IA[J]:=IA[J]-1;
	end;
{Turn digits into number again}
SQ:=DigitsToInt(IA);
{Test if it is square}
if Frac(Sqrt(SQ))<>0 then exit;
Result:=True;
end;

procedure ShowSubUnitSquares(Memo: TMemo);
var I,SQ,Cnt: integer;
begin
Cnt:=0;

for I:=1 to high(Integer) do
	begin
	SQ:=I*I;
	if IsSubUnitSquare(SQ) then
		begin
		Inc(Cnt);
		Memo.Lines.Add(Format('%d %8.0n',[Cnt,SQ+0.0]));
		if Cnt>=7 then break;
		end;
	end;
end;


