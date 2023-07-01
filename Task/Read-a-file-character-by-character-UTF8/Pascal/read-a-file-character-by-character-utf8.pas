(* Read a file char by char *)
   program ReadFileByChar;
   var
      InputFile,OutputFile: file of char;
      InputChar: char;
   begin
      Assign(InputFile, 'testin.txt');
      Reset(InputFile);
      Assign(OutputFile, 'testout.txt');
      Rewrite(OutputFile);
      while not Eof(InputFile) do
      begin
         Read(InputFile, InputChar);
         Write(OutputFile, InputChar)
      end;
      Close(InputFile);
      Close(OutputFile)
   end.
