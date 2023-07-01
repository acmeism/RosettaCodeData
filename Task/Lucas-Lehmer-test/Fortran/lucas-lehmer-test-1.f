PROGRAM LUCAS_LEHMER
  IMPLICIT NONE

  INTEGER, PARAMETER :: i64 = SELECTED_INT_KIND(18)
  INTEGER(i64) :: s, n
  INTEGER :: i, exponent

  DO exponent = 2, 31
     IF (exponent == 2) THEN
        s = 0
     ELSE
        s = 4
     END IF
     n = 2_i64**exponent - 1
     DO i = 1, exponent-2
        s = MOD(s*s - 2, n)
     END DO
     IF (s==0) WRITE(*,"(A,I0,A)") "M", exponent, " is PRIME"
  END DO

END PROGRAM LUCAS_LEHMER
