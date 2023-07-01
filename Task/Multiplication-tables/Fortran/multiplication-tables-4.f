      PROGRAM TABLES
      IMPLICIT NONE
C
C     Produce a formatted multiplication table of the kind memorised by rote
C     when in primary school. Only print the top half triangle of products.
C
C     23 Nov 15 - 0.1   - Adapted from original for VAX FORTRAN - MEJT
C
      INTEGER I,J,K                                             ! Counters.
      CHARACTER*32 S                                            ! Buffer for format specifier.
C
      K=12
C
      WRITE(S,1) K,K
    1 FORMAT(8H(4H0  |,,I2.2,11HI4,/,4H --+,I2.2,9H(4H----)))
      WRITE(6,S) (I,I = 1,K)                                    ! Print heading.
C
      DO 3 I=1,K		                                ! Step down the lines.
        WRITE(S,2) (I-1)*4+1,K                                  ! Update format string.
    2   FORMAT(12H(1H ,I2,1H|,,I2.2,5HX,I3,,I2.2,3HI4),8X)      ! Format string includes an explicit carridge control character.
        WRITE(6,S) I,(I*J, J = I,K)                             ! Use format to print row with leading blanks, unused fields are ignored.
    3 CONTINUE
C
      END
