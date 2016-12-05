(* Read a file line by line *)
   program ReadFileByLine;
   var
      InputFile,OutputFile: File;
      TextLine: String;
   begin
      Assign(InputFile, 'c:\testin.txt');
      Reset(InputFile);
      Assign(InputFile, 'c:\testout.txt');
      Rewrite(InputFile);
      while not Eof(InputFile) do
	  begin
         ReadLn(InputFile, TextLine);
		 (* do someting with TextLine *)
         WriteLn(OutputFile, TextLine)
      end;
      Close(InputFile);
      Close(OutputFile)
   end.
