MODULE BbtComputeCRC32;
IMPORT ZlibCrc32,StdLog;

PROCEDURE Do*;
VAR
	s: ARRAY 128 OF SHORTCHAR;
BEGIN	
	s := "The quick brown fox jumps over the lazy dog";
	StdLog.IntForm(ZlibCrc32.CRC32(0,s,0,LEN(s$)),16,12,'0',TRUE);
	StdLog.Ln;
END Do;
END BbtComputeCRC32.
