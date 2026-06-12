procedure ShowOHalloranNumbers(Memo: TMemo);
var L, W, H: integer;
var CubeArea, I, Cnt: integer;
const Limit = 1000;
const Limit2 = Limit div 2;
const Limit4 = Limit div 4;
var ValidOH: array [0..Limit2] of boolean;
var S: string;
begin
{Since we are using CuboidArea/2, use half the space }
for I:= 0 to Limit2-1 do ValidOH[I]:= true;
for L:= 1 to Limit4 do
 for W:= 1 to L do
  for H:= 1 to L do
	begin
	{Calculate 1/2 Cuboid value}
	CubeArea:=L * W + L * H + W * H;
	{Make sure number doesn't overrun array}
	if CubeArea>=Length(ValidOH) then continue;
	{Mark it as not an OHalloran number}
	ValidOH[CubeArea]:= false;
	end;
S:=''; Cnt:=0;
{Since we are using half the space}
{everything has to be doubled}
for I:=2 * 3 to Limit2-1 do
 if ValidOH[I] then
	begin
	Inc(Cnt);
	S:=S+Format('%8D',[I*2]);
	If (Cnt mod 5)=0 then S:=S+CRLF;
	end;

Memo.Lines.Add(S);
Memo.Lines.Add('Count='+IntToStr(Cnt));
end;


