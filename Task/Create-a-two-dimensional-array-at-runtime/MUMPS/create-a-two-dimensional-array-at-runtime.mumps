ARA2D
 NEW X,Y,A,I,J
REARA
 WRITE !,"Please enter two positive integers"
 READ:10 !,"First: ",X
 READ:10 !,"Second: ",Y
 GOTO:(X\1'=X)!(X<0)!(Y\1'=Y)!(Y<0) REARA
 FOR I=1:1:X FOR J=1:1:Y SET A(I,J)=I+J
 WRITE !,"The corner of X and Y is ",A(X,Y)
 KILL X,Y,A,I,J
 QUIT
