(* Read a text-file line by line *)
   program ReadFileByLine;
   var
      InputFile,OutputFile: text;
      TextLine: String;
   begin
      Assign(InputFile, 'testin.txt');
      Reset(InputFile);
      Assign(OutputFile, 'testout.txt');
      Rewrite(OutputFile);
      while not Eof(InputFile) do
    begin
         ReadLn(InputFile, TextLine);
     (* do someting with TextLine *)
         WriteLn(OutputFile, TextLine)
      end;
      Close(InputFile);
      Close(OutputFile)
   end.
