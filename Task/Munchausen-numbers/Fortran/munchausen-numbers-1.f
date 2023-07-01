C MUNCHAUSEN NUMBERS - FORTRAN IV
      DO 2 I=1,5000
        IS=0
        II=I
        DO 1 J=1,4
          ID=10**(4-J)
          N=II/ID
          IR=MOD(II,ID)
          IF(N.NE.0) IS=IS+N**N
  1       II=IR
  2     IF(IS.EQ.I) WRITE(*,*) I
      END
