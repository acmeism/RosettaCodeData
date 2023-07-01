function CommonLetters(S1,S2: string): integer;
{Count the number of letters in S1 are found in S2}
var I, J: integer;
begin
Result:=0;
for I:=1 to Length(S1) do
 for J:=1 to Length(S2) do
  if S1[I]=S2[J] then Inc(Result);
end;

procedure ShowJewelsStones(Memo: TMemo; Jewels,Stones: string);
{Show one Jewels-Stones comparison}
begin
Memo.Lines.Add(Jewels+' '+Stones+' '+IntToStr(CommonLetters(Jewels,Stones)));
end;


procedure TestJewelsStones(Memo: TMemo);
begin
ShowJewelsStones(Memo,'aAAbbbb', 'aA');
ShowJewelsStones(Memo,'ZZ','z');
end;
