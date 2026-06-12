function HasAlphaDigits(W: integer): boolean;
{test if number has A..F in one or more of the digits}
{Only works for numbers up to 9FF or 2559}
begin
Result:=((W and $000F) in [$000A,$000B,$000C,$000D,$000E,$000F]) or
	((W and $00F0) in [$00A0,$00B0,$00C0,$00D0,$00E0,$00F0]);
end;

procedure HasNibblesAF(Memo: TMemo);
{Find all numbers 1 through 500 where the hex}
{version has A..F in any of the nibbles}
var I,Cnt: integer;
var S: string;
begin
Cnt:=0;
S:='';
for I:=1 to 500 do
 if HasAlphaDigits(I) then
	begin
	Inc(Cnt);
	S:=S+Format('%4.0d', [I]);
	if (Cnt mod 20)=0 then S:=S+#$0D+#$0A;
	end;
Memo.Text:=S;
Memo.Lines.Add('Count = '+IntToStr(Cnt));
end;

