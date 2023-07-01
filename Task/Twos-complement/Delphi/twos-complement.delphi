procedure TwosCompliment(Memo: TMemo);
var N: integer;
begin
N:=123456789;
Memo.Lines.Add(Format('N=%10d $%0.8x',[N,N]));
Memo.Lines.Add('');
Memo.Lines.Add('N:=(N xor $FFFFFFFF)+1');
N:=(N xor $FFFFFFFF)+1;
Memo.Lines.Add('');
Memo.Lines.Add(Format('N=%10d $%0.8x',[N,N]));
end;
