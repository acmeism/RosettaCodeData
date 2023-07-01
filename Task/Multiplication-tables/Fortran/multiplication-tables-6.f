      PROGRAM TABLES
C
C     Produce a formatted multiplication table of the kind memorised by rote
C     when in primary school. Only print the top half triangle of products.
C
C     23 Nov 15 - 0.1   - Adapted from original for VAX FORTRAN - MEJT
C     24 Nov 15 - 0.2   - FORTRAN IV version adapted from VAX FORTRAN and
C                         compiled using Microsoft FORTRAN-80 - MEJT
C     25 Nov 15 - 0.3   - Microsoft FORTRAN-80 version using a BYTE array
C                         which makes it easier to understand what is going
C                         on. - MEJT
C
      BYTE A
      DIMENSION A(24)
      DIMENSION K(12)
C
      DATA A/'(','1','H',' ',',','I','2',',','1','H','|',',',
     +       '0','1','X',',','I','3',',','1','1','I','4',')'/
C
C     Print a heading and (try to) underline it.
C
      WRITE(1,1) (I,I=1,12)
    1 FORMAT(4H   |,12I4,/,4H --+12(4H----))
      DO 3 I=1,12
        A(13)=48+((I*4-3)/10)
        A(14)=48+(I*4-3)-((I*4-3)/10)*10
        DO 2 J=1,12
          K(J)=I*J
    2   CONTINUE
        WRITE(1,A)I,(K(J), J = I,12)
    3 CONTINUE
C
      END
