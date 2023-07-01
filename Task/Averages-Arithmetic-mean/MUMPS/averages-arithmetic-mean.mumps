MEAN(X)
 ;X is assumed to be a list of numbers separated by "^"
 QUIT:'$DATA(X) "No data"
 QUIT:X="" "Empty Set"
 NEW S,I
 SET S=0,I=1
 FOR  QUIT:I>$L(X,"^")  SET S=S+$P(X,"^",I),I=I+1
 QUIT (S/$L(X,"^"))
