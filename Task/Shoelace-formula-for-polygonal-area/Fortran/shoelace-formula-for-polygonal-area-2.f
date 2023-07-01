C SHOELACE FORMULA FOR POLYGONAL AREA
      DIMENSION X(33),Y(33)
      READ 101,N
      DO 1 I=1,N
   1    READ 102,X(I),Y(I)
      X(I)=X(1)
      Y(I)=Y(1)
      A=0
      DO 2 I=1,N
   2    A=A+X(I)*Y(I+1)-X(I+1)*Y(I)
      A=ABSF(A/2.)
      PRINT 303,A
      STOP
 101  FORMAT(I2)
 102  FORMAT(2F6.2)
 303  FORMAT(F10.2)
