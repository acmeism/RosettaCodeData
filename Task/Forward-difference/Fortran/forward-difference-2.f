PROGRAM TEST

  USE DIFFERENCE
  IMPLICIT NONE

  INTEGER :: array(10) = (/ 90, 47, 58, 29, 22, 32, 55, 5, 55, 73 /)
  INTEGER :: i

  DO i = 1, 9
    CALL Fdiff(array, i)
  END DO

  END PROGRAM TEST
