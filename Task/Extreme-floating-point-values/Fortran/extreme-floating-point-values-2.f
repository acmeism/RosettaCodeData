Cause various arithmetic errors to see what sort of hissy fit is thrown.
      REAL X2,X3,X4,Y4,XX,ZERO
      INTEGER IX4,IY4
      EQUIVALENCE (X4,IX4),(Y4,IY4)	!To view bits without provoking special fp handling.
      REAL*4 NaN4
      PARAMETER (NaN4 = Z'FFC00000')	!FFFFFFFF
c      PARAMETER (NaN4 = Z'FFFFFFFF')	!FFFFFFFF
      REAL*8 NaN8,X8(5),Y8,INF8
      PARAMETER (NaN8 = Z'FFF8000000000000')	!FFFFFFFF
c      PARAMETER (NaN8 = Z'FFFFFFFFFFFFFFFF')
      LOGICAL LX(5)
      INTEGER I
      X4 = NaN4
      WRITE (6,1) X4,IX4
    1 FORMAT ("X4 =",F12.4,' Hex ',Z8)
      WRITE (6,*) "Test X4 .EQ. Bad?  ",X4.EQ.NaN4
      WRITE (6,*) "Test X4 .NE. Bad?  ",X4.NE.NaN4
      WRITE (6,*) "Test IsNaN(X4)  ",ISNAN(X4)
      WRITE (6,*) "Test Abs(bad)   ",ABS(X4)
c      WRITE (6,*) "Test Exp(bad)",EXP(X4)
      Y8 = HUGE(Y8)
      WRITE(6,*) "Huge",Y8,LOG(Y8)
      Y8 = LOG(Y8)
      WRITE (6,*) "Hic",EXP(Y8)

      X2 = 0
      X3 = 0
      ZERO = 0
      XX = 666.66
      X2 = XX + X4
      WRITE (6,*) "Test x + BAD    ",X2
      WRITE (6,*) "Test 0/0        ",X3/ZERO
      WRITE (6,*) "Test 1/0        ",1/ZERO
      WRITE (6,*) "Test-1/0        ",-1/ZERO
      X2 = MIN(XX,X4)
      WRITE (6,*) "Test min(x,Bad) ",X2
      WRITE (6,*) "Test min(x,NaN4)",MIN(XX,NaN4)
c      WRITE (6,*) "Test mod(x,Bad) ",MOD(XX,X4)
c      WRITE (6,*) "Test mod(Bad,x) ",MOD(X4,XX)
c      WRITE (6,*) "Test mod(x,0)   ",MOD(XX,Z)
c      WRITE (6,*) "Sqrt(Bad)",SQRT(X4)

      DO I = 1,0,-1	!for sqrt(-1), a snarl.
        X4 = I
        X4 = X4/FLOAT(I)
        Y4 = SQRT(FLOAT(I))
        WRITE (6,10) I,I,X4,IX4,I,Y4,IY4
   10   FORMAT (I3,"/",I3," gives",F9.5," Hex ",Z8,
     1   ", Sqrt(",I3,") gives",F9.5," Hex ",Z8)
      END DO

Contemplate double precision.
      WRITE (6,*)
      WRITE (6,*) "Problems with IsNaN and arrays..."
      DO I = 1,5
        X8(I) = I
      END DO
      X8(3:4) = NaN8
      WRITE (6,*) "X=",X8
      WRITE (6,*) "X(2:4)=",X8(2:4)
      WRITE (6,*) "isnan(x(2:4))",ISNAN(X8(2:4))
      WRITE (6,*) "isnan(x(2))..(4))",ISNAN(X8(2)),ISNAN(X8(3)),
     1 ISNAN(X8(4))
      WRITE (6,*) "abs(x(2:4))",ABS(X8(2:4))
      WRITE (6,*) "isnan(abs(x(2:4)))",ISNAN(ABS(X8(2:4)))
      LX = ISNAN(X8)
      WRITE (6,*) "LX = isnan(X)",LX

      XX = HUGE(XX)
      WRITE(6,*) "Huge(x)=",XX,-XX
      XX = 1/ZERO
      WRITE(6,11) XX,-XX
   11 FORMAT("1/Zero=",Z8,", neg ",Z8)
      INF8 = XX
      WRITE (6,12) INF8,-INF8
   12 FORMAT("1/Zero=",Z16,", neg ",Z16)
      WRITE (6,*) "Burp!"
      END
