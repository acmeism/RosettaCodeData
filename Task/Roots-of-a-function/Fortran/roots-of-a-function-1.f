PROGRAM ROOTS_OF_A_FUNCTION

  IMPLICIT NONE

  INTEGER, PARAMETER :: dp = SELECTED_REAL_KIND(15)
  REAL(dp) :: f, e, x, step, value
  LOGICAL :: s

  f(x) = x*x*x - 3.0_dp*x*x + 2.0_dp*x

  x = -1.0_dp ; step = 1.0e-6_dp ; e = 1.0e-9_dp

  s = (f(x) > 0)
  DO WHILE (x < 3.0)
    value = f(x)
    IF(ABS(value) < e) THEN
      WRITE(*,"(A,F12.9)") "Root found at x =", x
      s = .NOT. s
    ELSE IF ((value > 0) .NEQV. s) THEN
      WRITE(*,"(A,F12.9)") "Root found near x = ", x
      s = .NOT. s
    END IF
    x = x + step
  END DO

END PROGRAM ROOTS_OF_A_FUNCTION
