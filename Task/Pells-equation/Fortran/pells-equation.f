      PROGRAM Pell
      IMPLICIT NONE
      INTEGER n(4)
      DATA n /61, 109, 181, 277/
      INTEGER*16 x, y
      INTEGER i

      DO 10, i = 1, size(n)
         CALL solve(n(i), x, y)
10       PRINT 100, n(i), x, y

100   FORMAT ('x² - ', i3, 'y² = 1; x = ', i24, ' and y = ', i24)
      END PROGRAM


      SUBROUTINE solve(n, a, b)
      IMPLICIT INTEGER*16 (A-Z)
      INTEGER n

      x = INT(sqrt(REAL(n)))
      IF (x**2 .ne. n) GOTO 10

      a = 1 ! perfect square; only trivial solution exists
      b = 0
      RETURN

10    y = x
      z = 1
      r = 2*x
      e1 = 1
      e2 = 0
      f1 = 0
      f2 = 1

20    y = r*z - y
      z = (n - y**2) / z
      r = (x + y) / z

      e3 = r*e2 + e1
      e1 = e2
      e2 = e3

      f3 = r*f2 + f1
      f1 = f2
      f2 = f3

      a = e2 + x*f2
      b = f2

      IF (a**2 - n*b**2 .eq. 1) RETURN
      GOTO 20

      END SUBROUTINE
