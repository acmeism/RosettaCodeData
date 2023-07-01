SUBSTR(S,N,M,C,K)
 ;show substring operations
 ;S is the string
 ;N is a position within the string (that is, n<length(string))
 ;M is an integer of positions to show
 ;C is a character within the string S
 ;K is a substring within the string S
 ;$Find returns the position after the substring
 NEW X
 WRITE !,"The base string is:",!,?5,"'",S,"'"
 WRITE !,"From position ",N," for ",M," characters:"
 WRITE !,?5,$EXTRACT(S,N,N+M-1)
 WRITE !,"From position ",N," to the end of the string:"
 WRITE !,?5,$EXTRACT(S,N,$LENGTH(S))
 WRITE !,"Whole string minus last character:"
 WRITE !,?5,$EXTRACT(S,1,$LENGTH(S)-1)
 WRITE !,"Starting from character '",C,"' for ",M," characters:"
 SET X=$FIND(S,C)-$LENGTH(C)
 WRITE !,?5,$EXTRACT(S,X,X+M-1)
 WRITE !,"Starting from string '",K,"' for ",M," characters:"
 SET X=$FIND(S,K)-$LENGTH(K)
 W !,?5,$EXTRACT(S,X,X+M-1)
 QUIT
