C     FIBONACCI SEQUENCE - FORTRAN IV
      NN=46
      DO 1 I=0,NN
    1 WRITE(*,300) I,IFIBO(I)
  300 FORMAT(1X,I2,1X,I10)
      END
C
      FUNCTION IFIBO(N)
      IF(N) 9,1,2
    1 IFN=0
      GOTO 9
    2 IF(N-1) 9,3,4
    3 IFN=1
      GOTO 9
    4 IFNM1=0
      IFN=1
      DO 5 I=2,N
      IFNM2=IFNM1
      IFNM1=IFN
    5 IFN=IFNM1+IFNM2
    9 IFIBO=IFN
      END
