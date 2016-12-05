Coded by Stanley Rabinowitz, 12 Vine Brook Road, Westford MA, 01886-4212.
      INTEGER VECT(3350),BUFFER(201)
      DATA VECT/3350*2/,MORE/0/
      DO 2 N = 1,201
        KARRAY = 0
        DO 3 L = 3350,1,-1
          NUM = 100000*VECT(L) + KARRAY*L
          KARRAY = NUM/(2*L - 1)
    3     VECT(L) = NUM - KARRAY*(2*L - 1)
        K = KARRAY/100000
        BUFFER(N) = MORE + K
    2   MORE = KARRAY - K*100000
      WRITE (*,100) BUFFER
  100 FORMAT (I2,"."/(1X,10I5.5))
      END
