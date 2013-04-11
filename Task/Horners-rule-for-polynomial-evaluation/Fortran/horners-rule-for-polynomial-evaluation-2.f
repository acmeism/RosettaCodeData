      FUNCTION HORNER(N,A,X)
      IMPLICIT NONE
      INTEGER I,N
      DOUBLE PRECISION A(N),X,Y,HORNER
      Y=A(N)
      DO I=N-1,1,-1
      Y=Y*X+A(I)
      END DO
      HORNER=Y
      END
