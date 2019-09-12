* STERN-BROCOT SEQUENCE - FORTRAN IV
      DIMENSION ISB(2400)
      NN=2400
      ISB(1)=1
      ISB(2)=1
      I=1
      J=2
      K=2
 1    IF(K.GE.NN) GOTO 2
        K=K+1
        ISB(K)=ISB(K-I)+ISB(K-J)
        K=K+1
        ISB(K)=ISB(K-J)
        I=I+1
        J=J+1
        GOTO 1
 2    N=15
      WRITE(*,101) N
  101 FORMAT(1X,'FIRST',I4)
      WRITE(*,102) (ISB(I),I=1,15)
  102 FORMAT(15I4)
      DO 5 J=1,11
        JJ=J
        IF(J.EQ.11) JJ=100
        DO 3 I=1,K
          IF(ISB(I).EQ.JJ) GOTO 4
 3      CONTINUE
 4      WRITE(*,103) JJ,I
  103   FORMAT(1X,'FIRST',I4,' AT ',I4)
 5    CONTINUE
      END
