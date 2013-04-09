PROGRAM EXAMPLE
  IMPLICIT NONE

  INTEGER :: i, j

  DO i = 0, 3
    DO j = 0, 6
       WRITE(*, "(I10)", ADVANCE="NO") Ackermann(i, j)
    END DO
    WRITE(*,*)
  END DO

CONTAINS

  RECURSIVE FUNCTION Ackermann(m, n) RESULT(ack)
    INTEGER :: ack, m, n

    IF (m == 0) THEN
      ack = n + 1
    ELSE IF (n == 0) THEN
      ack = Ackermann(m - 1, 1)
    ELSE
      ack = Ackermann(m - 1, Ackermann(m, n - 1))
    END IF
  END FUNCTION Ackermann

END PROGRAM EXAMPLE
