program RosettaCode_ReverseWordsInAString;

{$APPTYPE CONSOLE}

uses Classes, Types, StrUtils;

const
  TXT =
  '---------- Ice and Fire -----------'+sLineBreak+
  sLineBreak+
  'fire, in end will world the say Some'+sLineBreak+
  'ice. in say Some'+sLineBreak+
  'desire of tasted I''ve what From'+sLineBreak+
  'fire. favor who those with hold I'+sLineBreak+
  sLineBreak+
  '... elided paragraph last ...'+sLineBreak+
  sLineBreak+
  'Frost Robert -----------------------'+sLineBreak;

var
  i, w: Integer;
  d: TStringDynArray;
begin
  with TStringList.Create do
  try
    Text := TXT;
    for i := 0 to Count - 1 do
    begin
      d := SplitString(Strings[i], #32);
      Strings[i] := '';
      for w := Length(d) - 1 downto 0 do
        Strings[i] := Strings[i] + #32 + d[w];
    end;
    Writeln(Text);
  finally
    Free
  end;
  ReadLn;
end.
