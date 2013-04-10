OP ! = (STRING cmd)BOOL: system(cmd) = 0;

IF ! "touch test.tmp" ANDF ( ! "ls test.tmp" ANDF ! "rm test.tmp" ) THEN
  print (("test.tmp now gone!", new line))
FI
