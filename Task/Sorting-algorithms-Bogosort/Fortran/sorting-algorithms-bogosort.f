MODULE BOGO
IMPLICIT NONE
CONTAINS
  FUNCTION Sorted(a)
    LOGICAL :: Sorted
    INTEGER, INTENT(IN) :: a(:)
    INTEGER :: i

    Sorted = .TRUE.
    DO i = 1, SIZE(a)-1
      IF(a(i) > a(i+1)) THEN
        Sorted = .FALSE.
        EXIT
      END IF
    END DO
  END FUNCTION Sorted

  SUBROUTINE SHUFFLE(a)
    INTEGER, INTENT(IN OUT) :: a(:)
    INTEGER :: i, rand, temp
    REAL :: x

    DO i = SIZE(a), 1, -1
       CALL RANDOM_NUMBER(x)
       rand = INT(x * i) + 1
       temp = a(rand)
       a(rand) = a(i)
       a(i) = temp
    END DO
  END SUBROUTINE
END MODULE

PROGRAM BOGOSORT

  USE BOGO
  IMPLICIT NONE
  INTEGER :: iter = 0
  INTEGER :: array(8) = (/2, 7, 5, 3, 4, 8, 6, 1/)
  LOGICAL :: s

  DO
    s = Sorted(array)
    IF (s) EXIT
    CALL SHUFFLE(array)
    iter = iter + 1
  END DO
  WRITE (*,*) "Array required", iter, " shuffles to sort"

END PROGRAM BOGOSORT
