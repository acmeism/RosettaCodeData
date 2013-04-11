ANB
 NEW A,B,T,S
 READ !,"Input two integers between -1000 and 1000, separated by a space: ",S
 SET A=$PIECE(S," ",1),B=$PIECE(S," ",2)
 SET T=(A>=-1000)&(A<=1000)&(B>=-1000)&(B<=1000)&(A\1=A)&(B\1=B)
 IF T WRITE !,(A+B)
 IF 'T WRITE !,"Bad input"
 QUIT
