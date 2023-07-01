PROGRAM SPIRAL

  IMPLICIT NONE

  INTEGER, PARAMETER :: size = 5
  INTEGER :: i, x = 0, y = 1, count = size, n = 0
  INTEGER :: array(size,size)

  DO i = 1, count
    x = x + 1
      array(x,y) = n
    n = n + 1
  END DO

  DO
    count = count  - 1
      DO i = 1, count
        y = y + 1
        array(x,y) = n
        n = n + 1
      END DO
      DO i = 1, count
        x = x - 1
        array(x,y) = n
        n = n + 1
      END DO
      IF (n > size*size-1) EXIT
      count = count - 1
      DO i = 1, count
        y = y - 1
        array(x,y) = n
        n = n + 1
      END DO
      DO i = 1, count
        x = x + 1
        array(x,y) = n
        n = n + 1
      END DO	
      IF (n > size*size-1) EXIT
  END DO

  DO y = 1, size
    DO x = 1, size
      WRITE (*, "(I4)", ADVANCE="NO") array (x, y)
    END DO
    WRITE (*,*)
  END DO

END PROGRAM SPIRAL
