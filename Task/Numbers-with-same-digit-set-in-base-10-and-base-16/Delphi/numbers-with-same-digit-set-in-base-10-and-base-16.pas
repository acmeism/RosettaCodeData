function HasSameDigits1016(N: integer): boolean;
{Return true if base-10 string and base-16 string have same characters}
var S10,S16: string;
var I: integer;
begin
Result:=False;
{Get base-10 and -16 string}
S10:=IntToStr(N);
S16:=Format('%x',[N]);
{Compare S10 to S16}
for I:=1 to Length(S10) do
 if Pos(S10[I],S16)=0 then exit;
{Compare S16 to S10}
for I:=1 to Length(S16) do
 if Pos(S16[I],S10)=0 then exit;
Result:=True;
end;


procedure ShowSameDigits1016(Memo: TMemo);
var I,Cnt: integer;
var S: string;
begin
Cnt:=0;
for I:=0 to 100000-1 do
 if HasSameDigits1016(I) then
	begin
	Inc(Cnt);
	S:=S+Format('%8D',[I]);
	If (Cnt mod 5)=0 then S:=S+CRLF;
	end;
Memo.Lines.Add(S);
Memo.Lines.Add('Count='+IntToStr(Cnt));
end;


