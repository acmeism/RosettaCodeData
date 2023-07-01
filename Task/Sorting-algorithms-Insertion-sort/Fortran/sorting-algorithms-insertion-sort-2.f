      SUBROUTINE SORT(N,A)
      IMPLICIT NONE
      INTEGER N,I,J
      DOUBLE PRECISION A(N),X
      DO 30 I = 2,N
        X = A(I)
        J = I
   10   J = J - 1
        IF (J.EQ.0) GO TO 20
        IF (A(J).LE.X) GO TO 20
        A(J + 1) = A(J)
        GO TO 10
   20   A(J + 1) = X
   30 CONTINUE
      END
