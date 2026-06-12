Program OddWords;
Uses
  Classes;
Const
  F_NAME = 'unixdict.txt';
Var
  WordList: TStringList;
  Str, ShortStr: string;
  I: LongInt;

Begin
  WordList := TStringList.Create;
  WordList.LoadFromFile(F_NAME);
  WordList.Sorted := True;
  For Str In WordList Do
    If Length(Str) > 8 Then
    Begin
      ShortStr := '';
      I := 1;
      Repeat
        ShortStr := ShortStr + Str[I];
        Inc(I, 2);
      Until I > Length(Str);
      If WordList.IndexOf(ShortStr) > -1 Then
        Writeln(Str:12, ShortStr:10);
    End;
  WordList.Free;
End.
