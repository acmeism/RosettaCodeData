   procedure ReadFileByLine;
   var
      TextFile: text;
      TextLine: String;
   begin
      Assign(TextFile, 'c:\test.txt');
      Reset(TextFile);
      while not Eof(TextFile) do
         Readln(TextFile, TextLine);
      CloseFile(TextFile);
   end;
