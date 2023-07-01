      PROGRAM Mersenne Primes
      IMPLICIT INTEGER (a-z)
      LOGICAL is mersenne prime

      PARAMETER (sz primes = 31)
      INTEGER*1 primes(sz primes)

      DATA primes
     &      /2,   3,  5,  7,  11, 13,  17,  19,  23,  29,
     &       31,  37, 41, 43, 47, 53,  59,  61,  67,  71,
     &       73,  79, 83, 89, 97, 101, 103, 107, 109, 113,
     &       127/

      PRINT *, 'These Mersenne numbers are prime:'

      DO 10 i = 1, sz primes
          p = primes(i)
10        IF (is mersenne prime(p))
     &       WRITE (*, '(I5)', ADVANCE = 'NO'), p

      PRINT *
      END


      FUNCTION is mersenne prime(p)
      IMPLICIT NONE
      LOGICAL is mersenne prime
      INTEGER*4 p, i
      INTEGER*16 n, s, modmul

      IF (p .LT. 3) THEN
         is mersenne prime = p .EQ. 2
      ELSE
         n = 2_16**p - 1
         s = 4
         DO 10 i = 1, p - 2
            s = modmul(s, s, n) - 2
10          IF (s .LT. 0) s = s + n
         is mersenne prime = s .EQ. 0
      END IF
      END


      FUNCTION modmul(a0, b0, m)
      IMPLICIT INTEGER*16 (a-z)

      modmul = 0
      a = MODULO(a0, m)
      b = MODULO(b0, m)

10    IF (b .EQ. 0) RETURN
      IF (MOD(b, 2) .EQ. 1) THEN
         IF (a .LT. m - modmul) THEN
            modmul = modmul + a
         ELSE
            modmul = modmul - m + a
         END IF
      END IF
      b = b / 2
      IF (a .LT. m - a) THEN
         a = a * 2
      ELSE
         a = a - m + a
      END IF
      GO TO 10
      END
