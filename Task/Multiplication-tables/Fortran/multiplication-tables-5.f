      PROGRAM TABLES
C
C     Produce a formatted multiplication table of the kind memorised by rote
C     when in primary school. Only print the top half triangle of products.
C
C     23 Nov 15 - 0.1   - Adapted from original for VAX FORTRAN - MEJT
C     24 Nov 15 - 0.2   - FORTRAN IV version adapted from VAX FORTRAN and
C                         compiled using Microsoft FORTRAN-80 - MEJT
C
      DIMENSION K(12)
      DIMENSION A(6)
      DIMENSION L(12)
C
      COMMON //A
      EQUIVALENCE (A(1),L(1))
C
      DATA A/'(1H ',',I2,','1H|,','01X,','I3,1','2I4)'/
C
      WRITE(1,1) (I,I=1,12)
    1 FORMAT(4H0  |,12I4,/,4H --+12(4H----))
C
C     Overlaying the format specifier with an integer array makes it possibe
C     to modify the number of blank spaces.  The number of blank spaces is
C     stored as two consecuitive ASCII characters that overlay on the
C     integer value in L(7) in the ordr low byte, high byte.
C
      DO 3 I=1,12
        L(7)=(48+(I*4-3)-((I*4-3)/10)*10)*256+48+((I*4-3)/10)
        DO 2 J=1,12
          K(J)=I*J
    2   CONTINUE
        WRITE(1,A)I,(K(J), J = I,12)
    3 CONTINUE
C
      END
