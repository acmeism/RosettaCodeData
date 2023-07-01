IMPORT STD;
RemoveLines(logicalfile, startline, numlines) := FUNCTIONMACRO
  EndLine := startline + numlines - 1;
  RecCnt  := COUNT(logicalfile);
  Res := logicalfile[1..startline-1] + logicalfile[endline+1..];
  RETURN WHEN(IF(RecCnt < EndLine,logicalfile,Res),
              IF(RecCnt < EndLine,STD.System.Log.addWorkunitWarning('Attempted removal past end of file-removal ignored')));
ENDMACRO;
