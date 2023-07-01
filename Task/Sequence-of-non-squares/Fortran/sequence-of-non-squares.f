PROGRAM NONSQUARES

  IMPLICIT NONE

  INTEGER :: m, n, nonsqr

  DO n = 1, 22
    nonsqr =  n + FLOOR(0.5 + SQRT(REAL(n)))  ! or could use NINT(SQRT(REAL(n)))
    WRITE(*,*) nonsqr
  END DO

  DO n = 1, 1000000
    nonsqr =  n + FLOOR(0.5 + SQRT(REAL(n)))
    m = INT(SQRT(REAL(nonsqr)))
    IF (m*m == nonsqr) THEN
      WRITE(*,*) "Square found, n=", n
    END IF
  END DO

END PROGRAM NONSQUARES
