DOTPROD(A,B)
 ;Returns the dot product of two vectors. Vectors are assumed to be stored as caret-delimited strings of numbers.
 ;If the vectors are not of equal length, a null string is returned.
 QUIT:$LENGTH(A,"^")'=$LENGTH(B,"^") ""
 NEW I,SUM
 SET SUM=0
 FOR I=1:1:$LENGTH(A,"^") SET SUM=SUM+($PIECE(A,"^",I)*$PIECE(B,"^",I))
 KILL I
 QUIT SUM
