procedure ReadFileByLine;
   var
      TextLines :  TStringList;
      i         :  Integer;
   begin
      TextLines := TStringList.Create;
      TextLines.LoadFromFile('c:\text.txt');
      for i := 0 to TextLines.count -1 do
      ShowMessage(TextLines[i]);
   end;
