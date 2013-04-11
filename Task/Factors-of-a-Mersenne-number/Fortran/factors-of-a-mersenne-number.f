PROGRAM EXAMPLE
  IMPLICIT NONE
  INTEGER :: exponent, factor

  WRITE(*,*) "Enter exponent of Mersenne number"
  READ(*,*) exponent
  factor = Mfactor(exponent)
  IF (factor == 0) THEN
    WRITE(*,*) "No Factor found"
  ELSE
    WRITE(*,"(A,I0,A,I0)") "M", exponent, " has a factor: ", factor
  END IF

CONTAINS

FUNCTION isPrime(number)
!   code omitted - see [[Primality by Trial Division]]
END FUNCTION

FUNCTION  Mfactor(p)
  INTEGER :: Mfactor
  INTEGER, INTENT(IN) :: p
  INTEGER :: i, k,  maxk, msb, n, q

  DO i = 30, 0 , -1
    IF(BTEST(p, i)) THEN
      msb = i
      EXIT
    END IF
  END DO

  maxk = 16384  / p     ! limit for k to prevent overflow of 32 bit signed integer
  DO k = 1, maxk
    q = 2*p*k + 1
    IF (.NOT. isPrime(q)) CYCLE
    IF (MOD(q, 8) /= 1 .AND. MOD(q, 8) /= 7) CYCLE
    n = 1
    DO i = msb, 0, -1
      IF (BTEST(p, i)) THEN
        n = MOD(n*n*2, q)
      ELSE
        n = MOD(n*n, q)
      ENDIF
    END DO
    IF (n == 1) THEN
      Mfactor = q
      RETURN
    END IF
  END DO
  Mfactor = 0
END FUNCTION
END PROGRAM EXAMPLE
