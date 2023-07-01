* RC task: use the Chinese Remainder Theorem to solve a system of congruences.

      FUNCTION crt(n, residues, moduli)
      IMPLICIT INTEGER (A-Z)
      DIMENSION residues(n), moduli(n)

      p = product(moduli)
      crt = 0
      DO 10 i = 1, n
         m = p/moduli(i)
         CALL egcd(moduli(i), m, r, s, gcd)
         IF (gcd .ne. 1) GO TO 20 ! error exit
10       crt = crt + residues(i)*s*m
      crt = modulo(crt, p)
      RETURN

20    crt = -1 ! will never be negative, so flag an error
      END


* Compute egcd(a, b), returning x, y, g s.t.
*   g = gcd(a, b) and a*x + b*y = g
*
      SUBROUTINE egcd(a, b, x, y, g)
      IMPLICIT INTEGER (A-Z)

      g = a
      u = 0
      v = 1
      w = b
      x = 1
      y = 0

1     IF (w .eq. 0) RETURN
      q = g/w
      u next = x - q*u
      v next = y - q*v
      w next = g - q*w
      x = u
      y = v
      g = w
      u = u next
      v = v next
      w = w next
      GO TO 1
      END


      PROGRAM Chinese Remainder
      IMPLICIT INTEGER (A-Z)

      PRINT *, crt(3, [2, 3, 2], [3, 5, 7])
      PRINT *, crt(3, [2, 3, 2], [3, 6, 7]) ! no solution

      END
