APOLLONIUS(CIR1,CIR2,CIR3,S1,S2,S3)
 ;Circles are passed in as strings with three parts with a "^" separator in the order x^y^r
 ;The three circles are CIR1, CIR2, and CIR3
 ;The S1, S2, and S3 parameters determine if the solution will be internally or externally
 ;tangent to the circle. (+1 external, -1 internal)
 ;CIRR is the circle returned in the same format as the input circles
 ;
 ;Xn, Yn, and Rn are the values for a circle n - following the precedents from the
 ;other examples because doing $Pieces would make this confusing to read
 NEW X1,X2,X3,Y1,Y2,Y3,R1,R2,R3,RS,V11,V12,V13,V14,V21,V22,V23,V24,W12,W13,W14,W22,W23,W24,P,M,N,Q,A,B,C,D
 NEW CIRR
 SET X1=$PIECE(CIR1,"^",1),X2=$PIECE(CIR2,"^",1),X3=$PIECE(CIR3,"^",1)
 SET Y1=$PIECE(CIR1,"^",2),Y2=$PIECE(CIR2,"^",2),Y3=$PIECE(CIR3,"^",2)
 SET R1=$PIECE(CIR1,"^",3),R2=$PIECE(CIR2,"^",3),R3=$PIECE(CIR3,"^",3)
 SET V11=(2*X2)-(2*X1)
 SET V12=(2*Y2)-(2*Y1)
 SET V13=(X1*X1)-(X2*X2)+(Y1*Y1)-(Y2*Y2)-(R1*R1)+(R2*R2)
 SET V14=(2*S2*R2)-(2*S1*R1)
 SET V21=(2*X3)-(2*X2)
 SET V22=(2*Y3)-(2*Y2)
 SET V23=(X2*X2)-(X3*X3)+(Y2*Y2)-(Y3*Y3)-(R2*R2)+(R3*R3)
 SET V24=(2*S3*R3)-(2*S2*R2)
 SET W12=V12/V11
 SET W13=V13/V11
 SET W14=V14/V11
 SET W22=(V22/V21)-W12 ;Parentheses for insurance - MUMPS evaluates left to right
 SET W23=(V23/V21)-W13
 SET W24=(V24/V21)-W14
 SET P=-W23/W22
 SET Q=W24/W22
 SET M=-(W12*P)-W13
 SET N=W14-(W12*Q)
 SET A=(N*N)+(Q*Q)-1
 SET B=(2*M*N)-(2*N*X1)+(2*P*Q)-(2*Q*Y1)+(2*S1*R1)
 SET C=(X1*X1)+(M*M)+(2*M*X1)+(P*P)+(Y1*Y1)-(2*P*Y1)-(R1*R1)
 SET D=(B*B)-(4*A*C)
 SET RS=(-B-(D**.5))/(2*A)
 SET $PIECE(CIRR,"^",1)=M+(N*RS)
 SET $PIECE(CIRR,"^",2)=P+(Q*RS)
 SET $PIECE(CIRR,"^",3)=RS
 KILL X1,X2,X3,Y1,Y2,Y3,R1,R2,R3,RS,V11,V12,V13,V14,V21,V22,V23,V24,W12,W13,W14,W22,W23,W24,P,M,N,Q,A,B,C,D
 QUIT CIRR
