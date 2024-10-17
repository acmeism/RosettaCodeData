type TIntArray = array of integer;

procedure FillHofstadterArray(var HA: TIntArray);
{Fill array with Hofstader numbers}
{Preset array size to the number of terms you want}
var I: integer;
begin
{Starting condition}
HA[1]:=1; HA[2]:=1;
{Fill array up to last item}
for I:=3 to High(HA) do HA[I]:=HA[I-HA[I-1]]+HA[I-HA[I-2]];
end;


procedure ShowHofstadterNumbers(Memo: TMemo);
{Fill array with a }
var I, LessCount: integer;
var QArray: TIntArray;
begin
{Select the number of items we want}
SetLength(QArray,100000);
{Fill array}
FillHofstadterArray(QArray);
{Display first 10}
for I:=1 to 10 do Memo.Lines.Add(Format('%4d: %4d',[I,QArray[I]]));
Memo.Lines.Add(Format('%4d: %4d',[1000,QArray[1000]]));
{Count number the number of times Q(n)<Q(n-1)}
LessCount:=0;
for I:=1 to High(QArray) do
 if QArray[I]>QArray[I-1] then Inc(LessCount);
Memo.Lines.Add('Count of Q(n)<Q(n-1) = '+IntToStr(LessCount));
end;
