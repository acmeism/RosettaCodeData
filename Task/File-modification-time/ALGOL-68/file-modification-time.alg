PROC get output = (STRING cmd) VOID:
IF STRING sh cmd = " " + cmd + " ; 2>&1";
   STRING output;
   execve output ("/bin/sh", ("sh", "-c", sh cmd), "", output) >= 0
THEN print (output) FI;
get output ("rm -rf WTC_1");				CO Ensure file doesn't exist CO
get output ("touch WTC_1");				CO Create file CO
get output ("ls -l --time-style=full-iso WTC_1");	CO Display its last modified time CO
get output ("touch -t 200109111246.40 WTC_1");		CO Change its last modified time CO
get output ("ls -l --time-style=full-iso WTC_1")	CO Verify it changed CO
