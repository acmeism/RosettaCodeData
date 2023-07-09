      PROGRAM endianness
      IMPLICIT NONE
      INTEGER(KIND=4)  :: i = 1

      !ISHFT(INTEGER, SHIFT) : Left shift if SHIFT > 0
      !ISHFT(INTEGER, SHIFT) : Right shift if SHIFT < 0
      IF (ISHFT(i,1) .EQ. 0) THEN
        WRITE(*,FMT='(A)') 'Architechture is Big Endian'
      ELSE
        WRITE(*,FMT='(A)') 'Architecture is Little Endian'
      END IF

      RETURN

      STOP
      END PROGRAM endianness
