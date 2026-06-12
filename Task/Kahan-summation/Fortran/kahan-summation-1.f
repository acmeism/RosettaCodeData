      FUNCTION SUMC(A,N)
COMPENSATED SUMMATION. C WILL NOT STAY ZERO, DESPITE MATHEMATICS.
       DIMENSION A(12345)
        S = 0.0
        C = 0.0
        DO 1 I = 1,N
          Y = A(I) - C
          T = S + Y
          C = (T - S) - Y
          S = T
    1   CONTINUE
        SUMC = S
      END
      DIMENSION A(3)
      A(1) = 10000.0
      A(2) = 3.14159
      A(3) = 2.71828
      TYPE 1, A(1) + A(2) + A(3)
      TYPE 1, SUMC(A,3)
    1 FORMAT (6HSUM = ,F12.1)
      END
