PROGRAM PROBS

  IMPLICIT NONE

  INTEGER, PARAMETER :: trials = 1000000
  INTEGER :: i, j, probcount(8) = 0
  REAL :: expected(8), mapping(8), rnum
  CHARACTER(6) :: items(8) = (/ "aleph ", "beth  ", "gimel ", "daleth", "he    ", "waw   ", "zayin ", "heth  " /)

  expected(1:7) = (/ (1.0/i, i=5,11) /)
  expected(8) = 1.0 - SUM(expected(1:7))
  mapping(1) = 1.0 / 5.0
  DO i = 2, 7
     mapping(i) = mapping(i-1) + 1.0/(i+4.0)
  END DO
  mapping(8) = 1.0

  DO i = 1, trials
     CALL RANDOM_NUMBER(rnum)
     DO j = 1, 8
        IF (rnum < mapping(j)) THEN
           probcount(j) = probcount(j) + 1
           EXIT
        END IF
     END DO
  END DO

  WRITE(*, "(A,I10)") "Trials:             ", trials
  WRITE(*, "(A,8A10)") "Items:             ", items
  WRITE(*, "(A,8F10.6)") "Target Probability:  ", expected
  WRITE(*, "(A,8F10.6)") "Attained Probability:", REAL(probcount) / REAL(trials)

ENDPROGRAM PROBS
