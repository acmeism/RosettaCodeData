SORTARRAY(X,SEP)
 ;X is the list of items to sort
 ;X1 is the temporary array
 ;SEP is the separator string between items in the list X
 ;Y is the returned list
 ;This routine uses the inherent sorting of the arrays
 NEW I,X1,Y
 SET Y=""
 FOR I=1:1:$LENGTH(X,SEP) SET X1($PIECE(X,SEP,I))=""
 SET I="" FOR  SET I=$O(X1(I)) Q:I=""  SET Y=$SELECT($L(Y)=0:I,1:Y_SEP_I)
 KILL I,X1
 QUIT Y
