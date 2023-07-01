SUMSQUARE(X)
 ;X is assumed to be a list of numbers separated by "^"
 NEW RESULT,I
 SET RESULT=0,I=1
 FOR  QUIT:(I>$LENGTH(X,"^"))  SET RESULT=($PIECE(X,"^",I)*$PIECE(X,"^",I))+RESULT,I=I+1
 QUIT RESULT
