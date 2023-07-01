MODULE CreateFile;
IMPORT Files, StdLog;

PROCEDURE Do*;
VAR
	f: Files.File;
	res: INTEGER;
BEGIN
	f := Files.dir.New(Files.dir.This("docs"),Files.dontAsk);
	f.Register("output","txt",TRUE,res);
	f.Close();
	
	f := Files.dir.New(Files.dir.This("C:\AEAT\docs"),Files.dontAsk);
	f.Register("output","txt",TRUE,res);
	f.Close()
END Do;

END CreateFile.
