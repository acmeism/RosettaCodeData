      USE PROBE
      REAL A(3)
      REAL*4 X4E,X4L,X4S,X4C
      REAL*4 ONE,EPS
      REAL*8 X8E
      INTEGER I,N
      INTEGER BASE,W
Cast forth some pearls.
      WRITE (6,1) RADIX(X4E),DIGITS(X4E),EPSILON(X4E),
     1 RADIX(X8E),DIGITS(X8E),EPSILON(X8E)
    1 FORMAT ("Special functions report on the floating-point scheme.",
     1 /," Single precision: Radix=",I0,", Digits=",I0,", eps=",E14.7,
     2 /," Double precision: Radix=",I0,", Digits=",I0,", eps=",E14.7)
Concoct a heading for the table that will follow.
      WRITE (6,2) "eps","eps as stored"," as a number",
     1 " 1 + eps as stored","as a number"
    2 FORMAT ("Now to experiment with the computation scheme.",/,
     1 "Bit ",A14,2(A32,1X,A50))	!These sizes match those of FORMAT 11.
      N = 1		!In the beginning,
      EPS = 1		!There is one bit.
Consider the current precision.
   10 ONE = 1 + EPS	!Some numbers are more different than others.
      WRITE (6,11) N,EPS,EPS,FP8DIGITS(DBLE(EPS),2,2),
     1                   ONE,FP8DIGITS(DBLE(ONE),2,2)
   11 FORMAT (I3,":",1PE14.7,2(B32,1X,A50))
      IF (ONE .NE. 1) THEN	!Still see the difference?
        N = N + 1		!Yes. Count up another.
        EPS = EPS/2		!Go one smaller.
        GO TO 10		!And try again.
      END IF		!Mathematically, this will never end. But, with finite precision...
Compare with the results from the special function EPSILON.
      WRITE (6,*) "  ",EPS,"is the first eps indistinguishable from 1."
      WRITE (6,*) "  ",EPSILON(X4E),"reported smallest distinguishable."
      WRITE (6,*) "  ",2*EPS - EPSILON(EPS),"the difference."

Concoct some test values.
      A(1) = 1
      A(2) = +EPS
      A(3) = -EPS
Choose a revelation format.
      BASE = 2
      W = 2
Commence the tests.
      WRITE (6,*) "Sum via the additions in one expression."
      X4E = A(1) + A(2) + A(3)	!Calc. in R10, saved to R4.
      WRITE (6,665) "4",X4E
      WRITE (6,666) "1exprn",FP8DIGITS(DBLE(X4E),BASE,W)

      WRITE (6,*) "Sum via a loop."
      X4L = 0
      DO I = 1,3
        X4L = X4L + A(I)	!Terms in R10, saved to R4.
        WRITE (6,666) "A(i)",FP8DIGITS(DBLE(A(I)),BASE,W)
        WRITE (6,666) "X4L",FP8DIGITS(DBLE(X4L),BASE,W)
      END DO
      WRITE (6,665) "L",X4L
      WRITE (6,666) "Loop",FP8DIGITS(DBLE(X4L),BASE,W)

      WRITE (6,*) "Sum via SUM(A)"
      X4S = SUM(A)
      WRITE (6,665) "s",X4S
      WRITE (6,666) "SUM(A)",FP8DIGITS(DBLE(X4S),BASE,W)
      X8E = A(1) + A(2) + A(3)	!Calc in R10, saved to R8.
      WRITE (6,*) "X4E",X4E
      WRITE (6,*) "X4L",X4L
      WRITE (6,*) "X4S",X4S
      WRITE (6,*) "X4S - X4L",X4S - X4L
      WRITE (6,*) "X4E - X8E=",X4E - X8E
      WRITE (6,665) "8",X8E
      WRITE (6,666) "1exprn*8",FP8DIGITS(X8E,BASE,W)

      WRITE (6,*) "Sum via SUMC"
      X4C = SUMC(A,3)
      WRITE (6,665) "C",X4C
      WRITE (6,666) "SUMC",FP8DIGITS(DBLE(X4C),BASE,W)

      WRITE (6,*) "The array..."
      DO I = 1,3
        WRITE (6,*) FP8DIGITS(DBLE(A(I)),BASE,W)
      END DO
  665 FORMAT (A1,"Sum = ",F12.1)
  666 FORMAT (A8,":",A)
      END
