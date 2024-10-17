procedure ShowCompares(Memo: TMemo; S1,S2: string);
begin
if S1=S2  then Memo.Lines.Add(Format('"%s" is exactly equal to "%s"',[S1,S2]));
if S1<>S2 then Memo.Lines.Add(Format('"%s" is not equal to "%s"',[S1,S2]));
if S1<S2  then Memo.Lines.Add(Format('"%s" is less than "%s"',[S1,S2]));
if S1<=S2  then Memo.Lines.Add(Format('"%s" is less than or equal to "%s"',[S1,S2]));
if S1>S2  then Memo.Lines.Add(Format('"%s" is greater than "%s"',[S1,S2]));
if S1>=S2  then Memo.Lines.Add(Format('"%s" is greater than or equal to "%s"',[S1,S2]));
if AnsiSameText(S1, S2) then Memo.Lines.Add(Format('"%s" is case insensitive equal to "%s"',[S1,S2]));
Memo.Lines.Add(Format('"%s" "%s" case sensitive different = %d',[S1,S2,AnsiCompareStr(S1,S2)]));
Memo.Lines.Add(Format('"%s" "%s" case insensitive different = %d',[S1,S2,AnsiCompareText(S1,S2)]));
Memo.Lines.Add(Format('"%s" is found at Index %d in "%s"',[S1,Pos(S1,S2),S2]));
end;


procedure ShowStringCompares(Memo: TMemo);
begin
ShowCompares(Memo,'Equal', 'Equal');
ShowCompares(Memo,'Case', 'CASE');
ShowCompares(Memo,'91', '1234');
ShowCompares(Memo,'boy', 'cowboy');
end;
