      REAL FUNCTION STDDEV(X)	!Standard deviation for successive values.
       REAL X		!The latest value.
       REAL V		!Scratchpad.
       INTEGER N	!Ongoing: count of the values.
       REAL EX,EX2	!Ongoing: sum of X and X**2.
       SAVE N,EX,EX2		!Retain values from one invocation to the next.
       DATA N,EX,EX2/0,0.0,0.0/	!Initial values.
        N = N + 1		!Another value arrives.
        EX = X + EX		!Augment the total.
        EX2 = X**2 + EX2	!Augment the sum of squares.
        V = EX2/N - (EX/N)**2	!The variance, but, it might come out negative!
        STDDEV = SIGN(SQRT(ABS(V)),V)	!Protect the SQRT, but produce a negative result if so.
      END FUNCTION STDDEV	!For the sequence of received X values.

      REAL FUNCTION STDDEVP(X)	!Standard deviation for successive values.
       REAL X		!The latest value.
       INTEGER N	!Ongoing: count of the values.
       REAL A,V		!Ongoing: average, and sum of squared deviations.
       SAVE N,A,V		!Retain values from one invocation to the next.
       DATA N,A,V/0,0.0,0.0/	!Initial values.
        N = N + 1		!Another value arrives.
        V = (N - 1)*(X - A)**2 /N + V	!First, as it requires the existing average.
        A = (X - A)/N + A		!= [x + (n - 1).A)]/n: recover the total from the average.
        STDDEVP = SQRT(V/N)	!V can never be negative, even with limited precision.
      END FUNCTION STDDEVP	!For the sequence of received X values.

      REAL FUNCTION STDDEVW(X)	!Standard deviation for successive values.
       REAL X		!The latest value.
       REAL V,D		!Scratchpads.
       INTEGER N	!Ongoing: count of the values.
       REAL EX,EX2	!Ongoing: sum of X and X**2.
       REAL W		!Ongoing: working mean.
       SAVE N,EX,EX2,W		!Retain values from one invocation to the next.
       DATA N,EX,EX2/0,0.0,0.0/	!Initial values.
        IF (N.LE.0) W = X	!Take the first value as the working mean.
        N = N + 1		!Another value arrives.
        D = X - W		!Its deviation from the working mean.
        EX = D + EX		!Augment the total.
        EX2 = D**2 + EX2	!Augment the sum of squares.
        V = EX2/N - (EX/N)**2	!The variance, but, it might come out negative!
        STDDEVW = SIGN(SQRT(ABS(V)),V)	!Protect the SQRT, but produce a negative result if so.
      END FUNCTION STDDEVW	!For the sequence of received X values.

      REAL FUNCTION STDDEVPW(X)	!Standard deviation for successive values.
       REAL X		!The latest value.
       INTEGER N	!Ongoing: count of the values.
       REAL A,V		!Ongoing: average, and sum of squared deviations.
       REAL W		!Ongoing: working mean.
       SAVE N,A,V,W		!Retain values from one invocation to the next.
       DATA N,A,V/0,0.0,0.0/	!Initial values.
        IF (N.LE.0) W = X	!Oh for self-modifying code!
        N = N + 1		!Another value arrives.
        D = X - W		!Its deviation from the working mean.
        V = (N - 1)*(D - A)**2 /N + V	!First, as it requires the existing average.
        A = (D - A)/N + A		!= [x + (n - 1).A)]/n: recover the total from the average.
        STDDEVPW = SQRT(V/N)	!V can never be negative, even with limited precision.
      END FUNCTION STDDEVPW	!For the sequence of received X values.

      PROGRAM TEST
      INTEGER I		!A stepper.
      REAL A(8)		!The example data.
      DATA A/2.0,3*4.0,2*5.0,7.0,9.0/	!Alas, another opportunity to use @ passed over.
      REAL B		!An offsetting base.
      WRITE (6,1)
    1 FORMAT ("Progressive calculation of the standard deviation."/
     1 " I",7X,"A(I)       EX EX2      Av V*N      Ed Ed2     wAv V*N")
      B = 1000000		!Provoke truncation error.
      DO I = 1,8			!Step along the data series,
        WRITE (6,2) I,INT(A(I) + B),		!No fractional part, so I don't want F11.0.
     1   STDDEV(A(I) + B),STDDEVP(A(I) + B),	!Showing progressive values.
     2  STDDEVW(A(I) + B),STDDEVPW(A(I) + B)	!These with a working mean.
    2   FORMAT (I2,I11,1X,4F12.6)		!Should do for the example.
      END DO				!On to the next value.
      END
