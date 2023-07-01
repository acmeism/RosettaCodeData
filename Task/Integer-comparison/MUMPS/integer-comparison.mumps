INTCOMP
 NEW A,B
INTCOMPREAD
 READ !,"Enter an integer to test: ",A
 READ !,"Enter another integer: ",B
 IF (+A\1'=A)!(+B\1'=B) WRITE !!,"Please enter two integers.",! GOTO INTCOMPREAD
 IF A<B WRITE !,A," is less than ",B
 IF A=B WRITE !,A," is equal to ",B
 IF A>B WRITE !,A," is greater than ",B
 KILL A,B
 QUIT
