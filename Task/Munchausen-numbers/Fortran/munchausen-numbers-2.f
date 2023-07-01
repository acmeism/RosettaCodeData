! MUNCHAUSEN NUMBERS - FORTRAN 77
      DO I=1,5000
        IS=0
        II=I
        DO J=1,4
          ID=10**(4-J)
          N=II/ID
          IR=MOD(II,ID)
          IF(N.NE.0) IS=IS+N**N
          II=IR
        END DO
        IF(IS.EQ.I) WRITE(*,*) I
      END DO
      END
