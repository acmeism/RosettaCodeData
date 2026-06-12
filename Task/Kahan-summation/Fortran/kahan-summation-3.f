      MODULE PROBE
      CONTAINS
      CHARACTER*76 FUNCTION FP8DIGITS(X,BASE,W)	!Full expansion of the value of X in BASE.
Converts a number X to a specified BASE. For integers, successive division by BASE, for fractions, successive multiplication.
Can't use the FORMAT system in case this function is invoked in a formatted WRITE: some furrytrans don't handle reentrancy.
       REAL*8 X,T		!The value, and an associate.
       INTEGER BASE		!As desired.
       INTEGER W		!Allowance for the integer part, to promote alignment.
       CHARACTER*(76) TEXT	!Scratchpad for results.
       INTEGER L		!The length of the result.
       INTEGER N,ND		!Counters.
       INTEGER D		!The digit of the moment.
       LOGICAL NEG		!Annoyance with signs.
       CHARACTER*1 DIGIT(0:15)	!Want more than just decimal.
       PARAMETER (DIGIT = (/"0","1","2","3","4","5","6","7","8","9",	!So no CHAR(ICHAR("0") + d) tricks.
     1  "A","B","C","D","E","F"/))	!Because these are not adjacent character codes.
        IF (BASE.LE.1 .OR. BASE.GT.16) BASE = 10	!Preclude oddities.
        TEXT = "Base"		!Scrub the TEXT with an announcement.
        IF (BASE.GE.10) TEXT (6:6) = "1"	!I'm playing with a restricted range only.
        TEXT (7:7) = DIGIT(MOD(BASE,10))	!So in-line code will do.
        TEXT(8:8) = ":"		!So much for the preamble.
        T = X			!Grab the value.
        N = T			!Its integer part, with truncation.
        T = ABS(T - N)		!Thus obtain the fractional part.
        NEG = X .LT. 0		!Negative numbers are a nuisance.
        IF (NEG) N = -N		!So simplify for what follows.
        L = 10 + W		!Finger the units position..
        ND = 0			!No digits have been rolled.
Crunch the integer part.
   10   D = MOD(N,BASE)		!Extract the low-order digit in BASE.
        TEXT(L:L) = DIGIT(D)	!Place it as text.
        ND = ND + 1		!Count another digit rolled.
        N = N/BASE		!Drop down a power.
        L = L - 1		!Move back correspondingly.
        IF (L.LT.10) THEN	!Run out of space?
          TEXT(9:9) = "!"	!"Overflow!"
          GO TO 900		!TEXT might be far too short.
        END IF			!But, space is expected.
        IF (N.GT.0) GO TO 10	!Are we there yet?
        IF (NEG) TEXT(L:L) = "-"!Yes! Is a negative sign needed?
        L = 10 + W + 1		!Finger what follows the units position.
        TEXT(L:L) = "."		!Laziness leads to a full stop for a decimal point.
Crunch through the fractional part until nothing remains.
        DO WHILE(T.GT.0)	!Eventually, this will be zero.
          IF (L.GE.LEN(TEXT)) THEN	!Provided I have enough space!
            L = LEN(TEXT)		!If not, use the whole supply.
            TEXT(L:L) = "~"		!Place a marker suggesting that more should follow.
            GO TO 900			!And give up.
          END IF		!Otherwise, a digit is to be found.
          T = T*BASE		!Shift up a power.
          N = T			!The integer part is the digit.
          T = T - N		!Remove that integer part from T.
          L = L + 1		!Advance the finger.
          TEXT(L:L) = DIGIT(N)	!Place the digit.
          ND = ND + 1		!Count it also.
        END DO		!And see if anything remains.
Cast forth an addendum, to save the reader from mumbling while counting long strings of digits.
        IF (LEN(TEXT) - L .GT. 11) THEN	!Err, is there space for an addendum?
          TEXT(L + 2:L + 8) = "Digits:"	!Yes! Reveal the number of digits.
          L = L + 10			!Advance to the tens-to-be location.
          IF (ND.GT.9) TEXT(L:L) = DIGIT(ND/10)	!I expect no more than two-digit digit counts.
          L = L + 1			!Finger the units position.
          TEXT(L:L) = DIGIT(MOD(ND,10))	!Thus, no use of the FORMAT system.
        END IF				!So m uch for the addendum.
  900   FP8DIGITS = TEXT	!Anyway, here it all is.
      END FUNCTION FP8DIGITS	!Bases play best with related bases, such as 4 and 8. Less so with (say) 3 and 7...

      REAL FUNCTION SUMC(A,N)	!Add elements of the array, using limited precision.
Compensated summation. C will not stay zero, despite mathematics.
       REAL A(N)	!The array. Presumably with at least one element. Horror if N is wrongly supplied!
       INTEGER N	!The number of elements.
       REAL S,C,Y,T	!Assistants.
       INTEGER I	!A stepper.
        IF (N.LT.1) STOP "Yes, we have no bananas."	!This shouldn't happen.
        S = A(1)	!Start with the first element.
        C = 0.0		!No previous omissions to carry forward.
        DO I = 2,N	!Step through the remainder of the array.
          WRITE (6,*) "i=",I
          WRITE (6,666) "A(i)", FP8DIGITS(DBLE(A(I)),2,14)
  666     FORMAT (A8,":",A)
          WRITE (6,666) "C",    FP8DIGITS(DBLE(C),2,14)
          Y = A(I) - C		!Combine the next value with the compensation.
          WRITE (6,666) "Y=A-C",FP8DIGITS(DBLE(Y),2,14)
          WRITE (6,666) "S",    FP8DIGITS(DBLE(S),2,14)
          T = S + Y		!Augment the sum, temporarily in T.
          WRITE (6,666) "T=S+Y",FP8DIGITS(DBLE(T),2,14)
          WRITE (6,666) "T-S",  FP8DIGITS(DBLE(T - S),2,14)
          C = (T - S) - Y	!Catch what part of Y didn't get added to T.
          WRITE (6,666) "C=T-S-Y",FP8DIGITS(DBLE(C),2,14)
          S = T			!Place the sum.
          WRITE (6,666) "S",FP8DIGITS(DBLE(S),2,14)
        END DO		!On to the next element.
        SUMC = S	!C will no longer be zero.
      END FUNCTION SUMC	!Using a working mean might help.
      END MODULE PROBE

      USE PROBE
      REAL A(3)
      REAL*4 X4E,X4L,X4S,X4C
      REAL*8 X8E
      INTEGER I
      INTEGER BASE,W
      BASE = 2
      W = 14
      A(1) = 10000.0
      A(2) = 3.14159
      A(3) = 2.71828

      WRITE (6,*) "Sum via the additions in one expression."
      X4E = A(1) + A(2) + A(3)	!Calc. in R10, saved to R4.
      WRITE (6,1) "4",X4E
      WRITE (6,666) "1exprn",FP8DIGITS(DBLE(X4E),BASE,W)

      WRITE (6,*) "Sum via a loop."
      X4L = 0
      DO I = 1,3
        X4L = X4L + A(I)	!Terms in R10, saved to R4.
        WRITE (6,666) "A(i)",FP8DIGITS(DBLE(A(I)),BASE,W)
        WRITE (6,666) "X4L",FP8DIGITS(DBLE(X4L),BASE,W)
      END DO
      WRITE (6,1) "L",X4L
      WRITE (6,666) "Loop",FP8DIGITS(DBLE(X4L),BASE,W)

      WRITE (6,*) "Sum via SUM(A)"
      X4S = SUM(A)
      WRITE (6,1) "s",X4S
      WRITE (6,666) "SUM(A)",FP8DIGITS(DBLE(X4S),BASE,W)
      X8E = A(1) + A(2) + A(3)	!Calc in R10, saved to R8.
      WRITE (6,*) "X4S - X4L",X4S - X4L
      WRITE (6,*) "X4E - X8E=",X4E - X8E
      WRITE (6,1) "8",X8E
      WRITE (6,666) "1exprn*8",FP8DIGITS(X8E,BASE,W)

      WRITE (6,*) "Sum via SUMC"
      X4C = SUMC(A,3)
      WRITE (6,1) "C",X4C
      WRITE (6,666) "SUMC",FP8DIGITS(DBLE(X4C),BASE,W)

      WRITE (6,666) "Dec. calc",FP8DIGITS(10005.85987D0,BASE,W)
      WRITE (6,666) "Pie",FP8DIGITS(10000D0+4*ATAN(1D0)+EXP(1D0),BASE,W)
      WRITE (6,*) "The array..."
      DO I = 1,3
        WRITE (6,*) FP8DIGITS(DBLE(A(I)),BASE,W)
      END DO
      WRITE (6,"('3.14159 bits, packed',B32)") A(2)
    1 FORMAT (A1,"Sum = ",F12.1)
  666 FORMAT (A8,":",A)
      END
