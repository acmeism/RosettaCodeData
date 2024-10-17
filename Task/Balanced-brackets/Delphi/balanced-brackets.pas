procedure Balanced_Brackets;

var   BracketsStr : string;
      TmpStr      : string;
      I,J         : integer;

begin
  Randomize;
  for I := 1 to 9 do
    begin
      { Create a random string of 2*N chars with N*"[" and N*"]" }
      TmpStr  := '';
      for J := 1 to I do
        TmpStr := '['+TmpStr+']';
      BracketsStr := '';
      while TmpStr > '' do
        begin
          J := Random(Length(TmpStr))+1;
          BracketsStr := BracketsStr+TmpStr[J];
          Delete(TmpStr,J,1);
        end;
      TmpStr := BracketsStr;
      { Test for balanced brackets }
      while Pos('[]',TmpStr) > 0 do
        Delete(TmpStr,Pos('[]',TmpStr),2);
      if TmpStr = '' then
        writeln(BracketsStr+': OK')
      else
        writeln(BracketsStr+': not OK');
    end;
end;
