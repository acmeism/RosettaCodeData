      MODULE REBASE	!Play with some conversions between bases.
       CHARACTER*36 DIGIT	!A set of acceptable digit characters.
       PARAMETER (DIGIT = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ")	!Not only including hexadecimal.
       CONTAINS		!No great complication.
        LOGICAL FUNCTION EATNUM(ACARD,BASE,V)	!Reads a text number using the specified base.
Chews into the likes of 666, -666.666, .666 with their variations.
Completes with the value in V, success as the result.
Could check that no digit exceeds the specified BASE usage, but that would mean an error message...
Concocted by R.N.McLean (whom God preserve) May XXMM.
Clunky usage of ICHAR encourages the compaq compiler to employ single-character-at-a-time usage.
         CHARACTER*(*) ACARD	!The text.
         INTEGER BASE		!The base may not be ten.
         DOUBLE PRECISION V	!The object of the exercise.
         DOUBLE PRECISION X	!Maximum precision for all this fun. No sign of REAL*10.
         INTEGER D,DD		!A single digit. and a digit count.
         INTEGER L2,LC		!Finger and limit.
         INTEGER*1 C		!Since ICHAR is in use.
         LOGICAL ADIGIT,XNEG	!Things noticed along the way.
          ADIGIT = .FALSE.	!No digits seen.
          XNEG = .FALSE.	!No negative number.
          DD = 0		!No decimal digits.
          X = 0			!No value.
          L2 = 1		!The starting point.
          LC = LEN(ACARD)	!The ending point
          IF (L2.GT.LC) GO TO 20	!Urk! Off the end even before I start.
Chew into the number. Admit a possible leading sign, then digits.
          C = ICHAR(ACARD(L2:L2))	!Grab, since there are two comparisons.
          IF (C.EQ.ICHAR("+")) GO TO 1	!First consider
          IF (C.NE.ICHAR("-")) GO TO 2	!Possible signs.
          XNEG = .TRUE.		!To be acted upon later.
    1     L2 = L2 + 1		!Advance one.
          IF (L2.GT.LC) GO TO 20	!Off the end?
    2     D = INDEX(DIGIT,ACARD(L2:L2)) - 1	!No. Taste the candidate digit.
          IF (D .LT. 0) GO TO 10	!Is it to my taste?
          X = D				!Yes. Yum.
          ADIGIT = .TRUE.		!A digit has been seen. One is enough to be seen.
    3     L2 = L2 + 1			!More may follow.
          IF (L2.GT.LC) GO TO 20	!Perhaps not.
          D = ICHAR(ACARD(L2:L2)) - ICHAR("0")	!Taste the candidate digit.
          IF (D .LT. 0) GO TO 10	!Digitish?
          X = X*BASE + D		!Yes. Assimilate.
          GO TO 3			!Even more might well follow.
Consider any decimal digits, introduced by a decimal point.
   10     IF (ICHAR(ACARD(L2:L2)).EQ.ICHAR(".")) GO TO 11	!A full stop as a decimal point?
          IF (ICHAR(ACARD(L2:L2)).NE.ICHAR("·")) GO TO 20	!So, is there a decimal point?
   11     L2 = L2 + 1			!Advance one.
          IF (L2.GT.LC) GO TO 20	!Sudden end?
          D = INDEX(DIGIT,ACARD(L2:L2)) - 1	!No. Taste the digit candidate.
          IF (D .LT. 0) GO TO 20	!Suitable?
          X = X*BASE + D		!Yes. Continue augmenting the number.
          DD = 1			!This is the first decimal digit.
          ADIGIT = .TRUE.		!There may have been none before the decimal point.
   12     L2 = L2 + 1			!If once one digit is seen, is not the jungle full of digits?
          IF (L2.GT.LC) GO TO 20	!Perhaps not.
          D = ICHAR(ACARD(L2:L2)) - ICHAR("0")	!Taste the digit candidate.
          IF (D < 0 .OR. 9 < D) GO TO 20	!Suitable?
          X = X*BASE + D			!Yes. Accept as before.
          DD = DD + 1			!Now, no need to set ADIGIT to true again.
          GO TO 12			!Carry on.
Can't consider any exponent part, started by an "E" or "D", as these may be possible digit symbols.
   20     IF (DD .GT. 0) X = X/BASE**DD	!Rescale for the fractional digits.
          IF (XNEG) X = -X		!Fix the sign.
          V = X				!Place the result.
          EATNUM = ADIGIT		!Report success.
        END FUNCTION EATNUM	!And awayt.

        SUBROUTINE FP8DIGITS(X,BASE,TEXT,L)	!Full expansion of the value of X in BASE.
Converts a number X to a specified BASE. For integers, successive division by BASE, for fractions, successive multiplication.
         REAL*8 X,T		!The value, and an associate.
         INTEGER BASE		!As desired.
         CHARACTER*(*) TEXT	!Scratchpad for results.
         INTEGER L		!The length of the result.
         INTEGER N,ND		!Counters.
         INTEGER D		!The digit of the moment.
         LOGICAL NEG		!Annoyance with signs.
          IF (BASE.LE.1 .OR. BASE.GT.LEN(DIGIT)) BASE = 10	!Preclude oddities.
          WRITE (TEXT,1) BASE	!Scrub the TEXT with an announcement.
    1     FORMAT ("Base",I3)	!A limited range is expected..
          T = X			!Grab the value.
          N = T			!Its integer part, with truncation.
          T = ABS(T - N)	!Thus obtain the fractional part.
          NEG = N .LT. 0	!Negative numbers are a nuisance.
          IF (NEG) N = -N	!So simplify for what follows.
          L = LEN(TEXT)		!Limit of the scratchpad.
          ND = 0		!No digits have been rolled.
Crunch the integer part. Use the tail end of TEXT as a scratchpad, as the size of N is unassessed.
   10     D = MOD(N,BASE)		!Extract the low-order digit in BASE.
          TEXT(L:L) = DIGIT(D+1:D+1)	!Place it as text.
          ND = ND + 1			!Count another digit rolled.
          N = N/BASE			!Drop down a power.
          L = L - 1			!Move back correspondingly.
          IF (L.LE.0) THEN		!Run out of space?
            TEXT = "Overflow!"		!Then, this will have to do!
            L = MIN(9,LEN(TEXT))	!TEXT might be far too short.
           RETURN			!Give up.
          END IF			!But, space is expected.
          IF (N.GT.0) GO TO 10		!Are we there yet?
          IF (NEG) THEN			!Yes! Is a negative sign needed?
            TEXT(L:L) = "-"		!Yes. Place it.
            L = L - 1			!And retreat another place.
          END IF			!No + sign for positive numbers.
          N = LEN(TEXT) - L		!So, how much scratchpad was used?
          TEXT(9:9 + N - 1) = TEXT(L + 1:)	!Append to the initial TEXT(1:8) from the start.
          L = 9 + N			!Finger what follows the units position.
          TEXT(L:L) = "."		!Laziness leads to a full stop for a decimal point.
Crunch through the fractional part until nothing remains.
          DO WHILE(T.GT.0)	!Eventually, this will be zero.
            IF (L.GE.LEN(TEXT)) THEN	!Provided I have enough space!
              L = LEN(TEXT)		!If not, use the whole supply.
              TEXT(L:L) = "~"		!Place a marker suggesting that more should follow.
             RETURN		!And give up.
            END IF		!Otherwise, a digit is to be found.
            T = T*BASE		!Shift up a power.
            N = T		!The integer part is the digit.
            T = T - N		!Remove that integer part from T.
            L = L + 1		!Advance the finger.
            TEXT(L:L) = DIGIT(N+1:N+1)	!Place the digit.
            ND = ND + 1		!Count it also.
          END DO		!And see if anything remains.
Cast forth an addendum, to save the reader from mumbling while counting long strings of digits.
          IF (LEN(TEXT) - L .GT. 11) THEN	!Err, is there space for an addendum?
            WRITE (TEXT(L + 2:),11) ND		!Yes! Reveal the number of digits.
   11       FORMAT ("Digits:",I3)		!I expect no ore than two-digit digit counts.
            L = L + 1 + 10			!So this should do.
          END IF				!So much for the addendum.
        END SUBROUTINE FP8DIGITS	!Bases play best with related bases, such as 4 and 8. Less so with (say) 3 and 7...
      END MODULE REBASE	!Enough for inspection.

      PROGRAM TESTSOME
Check some conversions from one base to another.
      USE REBASE
      INTEGER N		!Some number of tests.
      PARAMETER (N = 5)		!This number.
      CHARACTER*12 TEXT(N)	!Sufficient size texts.
      DATA TEXT/"23.34375","10111.01011","1011.1101","11.90625","-666"/	!Also demonstrate a negative.
      DOUBLE PRECISION V	!The value in the computer's own representation.
      INTEGER I,L,BASE		!Assistants.
      CHARACTER*88 BACK		!A scratchpad.

      WRITE (6,1)	!A heading would be nice.
    1 FORMAT ("Test text in base",3X,"Value in base 10")
Chug through the tests.
      DO BASE = 10,2,-8	!Odd loop generates BASE = 10 then BASE = 2.
        DO I = 1,N		!Step through the test texts.
          WRITE (6,11) TEXT(I),BASE	!Start the line with the input.
   11     FORMAT (A,I5,$)		!The $, obviously, means no new line.
          IF (.NOT.EATNUM(TEXT(I),BASE,V)) THEN	!There shouldn't be any trouble.
            WRITE (6,*) "Not a good number!"		!But...
           ELSE				!So then,
            WRITE (BACK,*) V			!Reveal the resulting value.
            WRITE (6,12) BACK(1:20)		!Sufficient space, I hope.
   12       FORMAT (A,$)			!All to produce tabular output.
            CALL FP8DIGITS(V,2,BACK,L)		!Convert back to a text string.
            WRITE (6,13) BACK(1:L)		!And reveal.
   13       FORMAT (A)				!Thus end the line.
            CALL FP8DIGITS(V,10,BACK,L)		!And in another base,
            WRITE (6,14) BACK(1:L)		!The same value.
   14       FORMAT (37X,A)			!Nicely aligned.
          END IF			!So much for that test.
        END DO			!On to the next test.
      END DO		!And another base.
      END	!Enough of that.
