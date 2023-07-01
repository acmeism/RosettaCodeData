MODULE SEDOL_CHECK
  IMPLICIT NONE
  CONTAINS

  FUNCTION Checkdigit(c)
    CHARACTER :: Checkdigit
    CHARACTER(6), INTENT(IN) :: c
    CHARACTER(36) :: alpha = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    INTEGER, DIMENSION(6) :: weights = (/ 1, 3, 1, 7, 3, 9 /), temp
    INTEGER :: i, n

    DO i = 1, 6
      temp(i) = INDEX(alpha, c(i:i)) - 1
    END DO
    temp = temp * weights
    n = MOD(10 - (MOD(SUM(temp), 10)), 10)
    Checkdigit = ACHAR(n + 48)
  END FUNCTION Checkdigit

END MODULE SEDOL_CHECK

PROGRAM SEDOLTEST
  USE SEDOL_CHECK
  IMPLICIT NONE

  CHARACTER(31) :: valid = "0123456789BCDFGHJKLMNPQRSTVWXYZ"
  CHARACTER(6) :: codes(10) = (/ "710889", "B0YBKJ", "406566", "B0YBLH", "228276" ,  &
                                 "B0YBKL", "557910", "B0YBKR", "585284", "B0YBKT" /)
  CHARACTER(7) :: sedol
  INTEGER :: i, invalid

  DO i = 1, 10
    invalid = VERIFY(codes(i), valid)
    IF (invalid == 0) THEN
      sedol = codes(i)
      sedol(7:7) = Checkdigit(codes(i))
    ELSE
      sedol = "INVALID"
    END IF
    WRITE(*, "(2A9)") codes(i), sedol
  END DO

END PROGRAM SEDOLTEST
