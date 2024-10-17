procedure ShowRadixOutput(Memo: TMemo);
var I: integer;
begin
I:=123456789;
Memo.Lines.Add('Decimal     Hexadecimal');
Memo.Lines.Add('-----------------------');
Memo.Lines.Add(IntToStr(I)+' - '+IntToHex(I,8));
end;
