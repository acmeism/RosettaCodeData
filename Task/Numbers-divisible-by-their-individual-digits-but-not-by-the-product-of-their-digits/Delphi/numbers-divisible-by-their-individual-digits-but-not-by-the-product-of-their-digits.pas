function IsDivisible(N: integer): boolean;
{Returns true if N is divisible by each of its digits}
{And not divisible by the product of all the digits}
var I: integer;
var S: string;
var B: byte;
var P: integer;
begin
Result:=False;
{Test if digits divide into N}
S:=IntToStr(N);
for I:=1 to Length(S) do
  begin
  B:=Byte(S[I])-$30;
  if B=0 then exit;
  if (N mod B)<>0 then exit;
  end;
{Test if product of digits doesn't divide into N}
P:=1;
for I:=1 to Length(S) do
  begin
  B:=Byte(S[I])-$30;
  P:=P * B;
  end;
Result:=(N mod P)<>0;
end;


procedure ShowDivisibleDigits(Memo: TMemo);
{Show numbers that are even divisible by each of its digits}
{But not divisible by the product of all its digits}
var I,Cnt: integer;
var S: string;
begin
Cnt:=0;
S:='';
for I:=1 to 999 do
 if IsDivisible(I) then
  begin
  Inc(Cnt);
  S:=S+Format('%4D',[I]);
  If (Cnt mod 10)=0 then S:=S+#$0D#$0A;
  end;
Memo.Lines.Add('Count='+IntToStr(Cnt));
Memo.Lines.Add(S);
end;

