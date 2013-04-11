      MODULE QUEENS_MOD
      IMPLICIT NONE
      INTEGER, PARAMETER :: LONG=SELECTED_INT_KIND(17)
      CONTAINS
      FUNCTION PQUEENS(N,K1,K2) RESULT(M)
      IMPLICIT NONE
      INTEGER(KIND=LONG) :: M
      INTEGER, INTENT(IN) :: N,K1,K2
      INTEGER, PARAMETER :: L=20
      INTEGER :: A(L),S(L),U(4*L-2)
      INTEGER :: I,J,Y,Z,P,Q,R
      DO 10 I=1,N
   10 A(I)=I
      DO 20 I=1,4*N-2
   20 U(I)=0
      M=0
      R=2*N-1
      IF(K1.EQ.K2) RETURN
      P=1-K1+N
      Q=1+K1-1
      IF((U(P).NE.0).OR.(U(Q+R).NE.0)) RETURN
      U(P)=1
      U(Q+R)=1
      Z=A(1)
      A(1)=A(K1)
      A(K1)=Z
      P=2-K2+N
      Q=2+K2-1
      IF((U(P).NE.0).OR.(U(Q+R).NE.0)) RETURN
      U(P)=1
      U(Q+R)=1
      IF(K2.NE.1) THEN
      Z=A(2)
      A(2)=A(K2)
      A(K2)=Z
      ELSE
      Z=A(2)
      A(2)=A(K1)
      A(K1)=Z
      END IF
      I=3
      GO TO 40
   30 S(I)=J
      U(P)=1
      U(Q+R)=1
      I=I+1
   40 IF(I.GT.N) GO TO 80
      J=I
   50 Z=A(I)
      Y=A(J)
      P=I-Y+N
      Q=I+Y-1
      A(I)=Y
      A(J)=Z
      IF((U(P).EQ.0).AND.(U(Q+R).EQ.0)) GO TO 30
   60 J=J+1
      IF(J.LE.N) GO TO 50
   70 J=J-1
      IF(J.EQ.I) GO TO 90
      Z=A(I)
      A(I)=A(J)
      A(J)=Z
      GO TO 70
   80 M=M+1
   90 I=I-1
      IF(I.EQ.2) RETURN
      P=I-A(I)+N
      Q=I+A(I)-1
      J=S(I)
      U(P)=0
      U(Q+R)=0
      GO TO 60
      END FUNCTION
      END MODULE
      PROGRAM QUEENS
      USE OMP_LIB
      USE QUEENS_MOD
      IMPLICIT NONE
      INTEGER, PARAMETER :: L=20
      INTEGER :: N,I,J,A(L*L,2),K,P,Q
      INTEGER(KIND=LONG) :: S,B(L*L)
      DOUBLE PRECISION :: T1,T2
      DO N=6,18
      K=0
      P=N/2
      Q=MOD(N,2)*(P+1)
      DO I=1,N
      DO J=1,N
      IF((ABS(I-J).GT.1).AND.((I.LE.P).OR.((I.EQ.Q).AND.(J.LT.I)))) THEN
      K=K+1
      A(K,1)=I
      A(K,2)=J
      END IF
      END DO
      END DO
      S=0
      T1=OMP_GET_WTIME()
C$OMP PARALLEL DO SCHEDULE(DYNAMIC)
      DO I=1,K
      B(I)=PQUEENS(N,A(I,1),A(I,2))
      END DO
C$OMP END PARALLEL DO
      T2=OMP_GET_WTIME()
      PRINT '(I4,I12,F12.3)',N,2*SUM(B(1:K)),T2-T1
      END DO
      END PROGRAM
