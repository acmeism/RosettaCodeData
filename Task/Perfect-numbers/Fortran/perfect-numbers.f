FUNCTION isPerfect(n)
  LOGICAL :: isPerfect
  INTEGER, INTENT(IN) :: n
  INTEGER :: i, factorsum

  isPerfect = .FALSE.
  factorsum = 1
  DO i = 2, INT(SQRT(REAL(n)))
     IF(MOD(n, i) == 0) factorsum = factorsum + i + (n / i)
  END DO
  IF (factorsum == n) isPerfect = .TRUE.
END FUNCTION isPerfect
