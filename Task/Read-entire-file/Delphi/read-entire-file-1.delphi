program ReadAll;

{$APPTYPE CONSOLE}

uses Classes;

var
  i: Integer;
  lList: TStringList;
begin
  lList := TStringList.Create;
  try
    lList.LoadFromFile('c:\input.txt');
    // Write everything at once
    Writeln(lList.Text);
    // Write one line at a time
    for i := 0 to lList.Count - 1 do
      Writeln(lList[i]);
  finally
    lList.Free;
  end;
end.
