var Seed: int64 = 675248;

function MiddleSquareRandom: int64;
var S: string;
begin
S:=IntToStr(Seed * Seed);
while Length(S)<12 do S:='0'+S;
Seed:=StrToInt(MidStr(S, 4, 6));
Result:=Seed;
end;


procedure ShowMiddleSqrRandom(Memo: TMemo);
var I: integer;
begin
for I:=1 to 5 do
 Memo.Lines.Add(IntToStr(MiddleSquareRandom));
end;
