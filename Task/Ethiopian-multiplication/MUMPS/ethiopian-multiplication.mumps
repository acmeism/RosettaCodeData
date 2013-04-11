HALVE(I)
 ;I should be an integer
 QUIT I\2
DOUBLE(I)
 ;I should be an integer
 QUIT I*2
ISEVEN(I)
 ;I should be an integer
 QUIT '(I#2)
E2(M,N)
 New W,A,E,L Set W=$Select($Length(M)>=$Length(N):$Length(M)+2,1:$L(N)+2),A=0,L=0,A(L,1)=M,A(L,2)=N
 Write "Multiplying two numbers:"
 For  Write !,$Justify(A(L,1),W),?W,$Justify(A(L,2),W) Write:$$ISEVEN(A(L,1)) ?(2*W)," Struck" Set:'$$ISEVEN(A(L,1)) A=A+A(L,2) Set L=L+1,A(L,1)=$$HALVE(A(L-1,1)),A(L,2)=$$DOUBLE(A(L-1,2)) Quit:A(L,1)<1
 Write ! For E=W:1:(2*W) Write ?E,"="
 Write !,?W,$Justify(A,W),!
 Kill W,A,E,L
 Q
