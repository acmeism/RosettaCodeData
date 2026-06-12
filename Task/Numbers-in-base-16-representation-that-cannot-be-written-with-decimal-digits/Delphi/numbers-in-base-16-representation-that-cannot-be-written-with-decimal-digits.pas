function HasNoBase10(N: integer): boolean;
{Test N for decimal digits in hex string}
var I: integer;
var S: string;
begin
Result:=False;
S:=Format('%x',[N]);
for I:=1 to Length(S) do
 if S[I] in ['0'..'9'] then exit;
Result:=True;
end;



procedure ShowNoBase10inHex(Memo: TMemo);
var I,Cnt: integer;
var S: string;
begin
Cnt:=0;
for I:=0 to 500-1 do
 if HasNoBase10(I) then
	begin
	Inc(Cnt);
	S:=S+Format('%8D',[I]);
	If (Cnt mod 5)=0 then S:=S+#$0D#$0A;
	end;
Memo.Lines.Add('Count='+IntToStr(Cnt));
Memo.Lines.Add(S);
end;


