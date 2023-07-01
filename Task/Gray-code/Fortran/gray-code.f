      PROGRAM GRAY
      IMPLICIT NONE
      INTEGER IGRAY,I,J,K
      CHARACTER*5 A,B,C
      DO 10 I=0,31
      J=IGRAY(I,1)
      K=IGRAY(J,-1)
      CALL BINARY(A,I,5)
      CALL BINARY(B,J,5)
      CALL BINARY(C,K,5)
      PRINT 99,I,A,B,C,K
   10 CONTINUE
   99 FORMAT(I2,3H : ,A5,4H => ,A5,4H => ,A5,3H : ,I2)
      END

      FUNCTION IGRAY(N,D)
      IMPLICIT NONE
      INTEGER D,K,N,IGRAY
      IF(D.LT.0) GO TO 10
      IGRAY=IEOR(N,ISHFT(N,-1))
      RETURN
   10 K=N
      IGRAY=0
   20 IGRAY=IEOR(IGRAY,K)
      K=K/2
      IF(K.NE.0) GO TO 20
      END

      SUBROUTINE BINARY(S,N,K)
      IMPLICIT NONE
      INTEGER I,K,L,N
      CHARACTER*(*) S
      L=LEN(S)
      DO 10 I=0,K-1
C The following line may replace the next block-if,
C on machines using ASCII code :
C     S(L-I:L-I)=CHAR(48+IAND(1,ISHFT(N,-I)))
C On EBCDIC machines, use 240 instead of 48.
      IF(BTEST(N,I)) THEN
      S(L-I:L-I)='1'
      ELSE
      S(L-I:L-I)='0'
      END IF
   10 CONTINUE
      S(1:L-K)=''
      END
