 FUNCTION isPrime(number)
   LOGICAL :: isPrime
   INTEGER, INTENT(IN) :: number
   INTEGER :: i

   IF(number==2) THEN
      isPrime = .TRUE.
   ELSE IF(number < 2 .OR. MOD(number,2) == 0) THEN
      isPRIME = .FALSE.
   ELSE
      isPrime = .TRUE.
      DO i = 3, INT(SQRT(REAL(number))), 2
         IF(MOD(number,i) == 0) THEN
            isPrime = .FALSE.
            EXIT
         END IF
      END DO
   END IF
 END FUNCTION
