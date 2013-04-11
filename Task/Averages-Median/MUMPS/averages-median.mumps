MEDIAN(X)
 ;X is assumed to be a list of numbers separated by "^"
 ;I is a loop index
 ;L is the length of X
 ;Y is a new array
 QUIT:'$DATA(X) "No data"
 QUIT:X="" "Empty Set"
 NEW I,ODD,L,Y
 SET L=$LENGTH(X,"^"),ODD=L#2,I=1
 ;The values in the vector are used as indices for a new array Y, which sorts them
 FOR  QUIT:I>L  SET Y($PIECE(X,"^",I))=1,I=I+1
 ;Go to the median index, or the lesser of the middle if there is an even number of elements
 SET J="" FOR I=1:1:$SELECT(ODD:L\2+1,'ODD:L/2) SET J=$ORDER(Y(J))
 QUIT $SELECT(ODD:J,'ODD:(J+$ORDER(Y(J)))/2)
