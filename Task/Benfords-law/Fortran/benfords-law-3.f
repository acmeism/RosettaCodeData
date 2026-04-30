      PROGRAM benford
      INTEGER counts(9)

      expected(d) = log10(1.0 + 1.0/d)

      CALL tally(counts)

      PRINT 100, 'Digit', 'Actual', 'Expected'
      DO 10, i = 1, 9
10       PRINT 101, i, counts(i)/1E3, expected(real(i))

100   FORMAT (A6, 1X, A9, 1X, A9)
101   FORMAT (I4, 3X, F9.3, 1X, F9.4)
      END PROGRAM


      SUBROUTINE tally(counts)
      INTEGER counts(9)
      CHARACTER*20 str
      DOUBLE PRECISION a, b, c
      INTEGER d

      counts = [(0, i = 1, 9)]
      a = 0
      b = 1
      DO 10, i = 1, 1000
         WRITE (str, '(E12.6)') b
         d = ichar(str(3:3)) - ichar('0')
         counts(d) = counts(d) + 1
         c = a + b
         a = b
10       b = c
      END SUBROUTINE
