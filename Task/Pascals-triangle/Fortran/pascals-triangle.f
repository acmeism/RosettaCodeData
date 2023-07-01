PROGRAM Pascals_Triangle

  CALL Print_Triangle(8)

END PROGRAM Pascals_Triangle

SUBROUTINE Print_Triangle(n)

  IMPLICIT NONE
  INTEGER, INTENT(IN) :: n
  INTEGER :: c, i, j, k, spaces

  DO i = 0, n-1
     c = 1
     spaces = 3 * (n - 1 - i)
     DO j = 1, spaces
        WRITE(*,"(A)", ADVANCE="NO") " "
     END DO
     DO k = 0, i
        WRITE(*,"(I6)", ADVANCE="NO") c
        c = c * (i - k) / (k + 1)
     END DO
     WRITE(*,*)
  END DO

END SUBROUTINE Print_Triangle
