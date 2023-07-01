INTEGER, PARAMETER :: dp = SELECTED_REAL_KIND(15)
INTEGER :: i=1, limit=100
REAL(dp) :: d, e, f, x, x1, x2

f(x) = x*x*x - 3.0_dp*x*x + 2.0_dp*x

x1 = -1.0_dp ; x2 = 3.0_dp ; e = 1.0e-15_dp

DO
  IF (i > limit) THEN
    WRITE(*,*) "Function not converging"
    EXIT
  END IF
  d = (x2 - x1) / (f(x2) - f(x1)) * f(x2)
  IF (ABS(d) < e) THEN
    WRITE(*,"(A,F18.15)") "Root found at x = ", x2
    EXIT
  END IF
  x1 = x2
  x2 = x2 - d
  i = i + 1
END DO
