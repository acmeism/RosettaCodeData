TOKENS
 NEW I,J,INP
 SET INP="Hello,how,are,you,today"
 NEW I FOR I=1:1:$LENGTH(INP,",") SET INP(I)=$PIECE(INP,",",I)
 NEW J FOR J=1:1:I WRITE INP(J) WRITE:J'=I "."
 KILL I,J,INP  // Kill is optional. "New" variables automatically are killed on "Quit"
 QUIT
