FILTERARRAY
 ;NEW I,J,A,B - Not making new, so we can show the values
 ;Populate array A
 FOR I=1:1:10 SET A(I)=I
 ;Move even numbers into B
 SET J=0 FOR I=1:1:10 SET:A(I)#2=0 B($INCREMENT(J))=A(I)
 QUIT
