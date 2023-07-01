MULTTABLE(SIZE)
 ;Print out a multiplication table
 ;SIZE is the size of the multiplication table to make
 ;MW is the maximum width of the numbers
 ;D is the down axis
 ;A is the across axis
 ;BAR is the horizontal bar under the operands
 NEW MW,D,A,BAR
 IF $DATA(SIZE)<1 SET SIZE=12
 SET MW=$LENGTH(SIZE*SIZE)
 SET BAR="" FOR I=1:1:(MW+2) SET BAR=BAR_"-"
 FOR D=1:1:(SIZE+2) DO
 .FOR A=1:1:(SIZE+1) DO
 ..WRITE:(D=1)&(A=1) !,$JUSTIFY("",MW-1)," X|"
 ..WRITE:(D=1)&(A>1) ?((A-1)*5),$JUSTIFY((A-1),MW)
 ..WRITE:(D=2)&(A=1) !,BAR
 ..WRITE:(D=2)&(A'=1) BAR
 ..WRITE:(D>2)&(A=1) !,$JUSTIFY((D-2),MW)," |"
 ..WRITE:((A-1)>=(D-2))&((D-2)>=1) ?((A-1)*5),$JUSTIFY((D-2)*(A-1),MW)
 KILL MW,D,A,BAR
 QUIT
