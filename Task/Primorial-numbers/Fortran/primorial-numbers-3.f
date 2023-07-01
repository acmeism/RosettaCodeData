      MODULE BIGNUMBERS	!Limited services: decimal integers, no negative numbers.
       INTEGER BIGORDER		!A limit attempt at generality.
       PARAMETER (BIGORDER = 2)	!This is the order of the base of the big number arithmetic.
       INTEGER BIGBASE,BIGLIMIT	!Sized thusly.
       PARAMETER (BIGBASE = 10**BIGORDER, BIGLIMIT = 8888888/BIGORDER)	!Enough?
       TYPE BIGNUM	!So, a big number is simple.
        INTEGER LAST		!This many digits (of size BIGBASE) are in use.
        INTEGER DIGIT(BIGLIMIT)	!The digits, in ascending power order.
       END TYPE BIGNUM	!So much for that.
       CONTAINS		!Now for some assistants.
        SUBROUTINE BIGMULT(B,N)	!B:=B*N;	Multiply by an integer possibly bigger than the base.
         TYPE(BIGNUM) B	!The worker.
         INTEGER N	!A computer number, not a multi-digit number.
         INTEGER D	!Must be able to hold (BIGBASE - 1)*N + C
         INTEGER C	!The carry to the next digit.
         INTEGER I	!A stepper.
          C = 0		!No previous digit to carry from.
          DO I = 1,B.LAST	!Step through the digits, upwards powers.
            D = B.DIGIT(I)		!Grab a digit.
            D = D*N + C			!Apply the multiply.
            B.DIGIT(I) = MOD(D,BIGBASE)	!Place the resulting digit.
            C = D/BIGBASE		!Agony! TWO divisions per step!!
          END DO		!On to the next digit up.
          DO WHILE(C .GT. 0)	!Now spread the last carry to further digits.
            B.LAST = B.LAST + 1		!Up one more.
            IF (B.LAST .GT. BIGLIMIT) STOP "Overflow by multiply!"	!Perhaps not.
            B.DIGIT(B.LAST) = MOD(C,BIGBASE)	!The digit.
            C = C/BIGBASE		!The carry may be large, if N is large.
          END DO		!So slog on until it is gone.
        END SUBROUTINE BIGMULT	!Primary school stuff.
      END MODULE BIGNUMBERS	!No fancy tricks.

      MODULE ERATOSTHENES	!Prepare an array of prime numbers.
Considers odd numbers only as the pattern is very simple. Some trickery as a consequence.
       INTEGER NP,LASTP		!Counters.
       PARAMETER (LASTP = 1000000)	!The specified need.
       INTEGER PRIME(0:LASTP),PREZAP	!Initialisation is rather messy.
       PARAMETER (PREZAP = 6)		!Up to PRIME(6) = 13.
       DATA NP/PREZAP/, PRIME(0:PREZAP)/1,2,3,5,7,11,13/	!Not counting the "zeroth" prime, 1.
       CONTAINS	!Some tricky stuff/
        SUBROUTINE PREPARE PRIMES	!Fetch a limited copy of the Platonic ideal.
         INTEGER SURGE,LB		!A sieve has a certain rather special size.
         PARAMETER (SURGE = 30030, LB = SURGE/2 - 1)	!= 2*3*5*7*11*13.
         LOGICAL*1 BIT(0:LB),START(0:LB)!Two such arrays, thanks.
         INTEGER N0,NN		!Bounds for the current sieve span.
         INTEGER I,P,IP		!Assistants.
C  The scheme for a cycle of 2*3*5 = 30, remembering that even numbers are not involved so BIT(0:14).
C             |         surge 1             |         surge 2             |         surge 3             |
C        N =  |          1 1 1 1 1 2 2 2 2 2|3 3 3 3 3 4 4 4 4 4 5 5 5 5 5|6 6 6 6 6 7 7 7 7 7 8 8 8 8 8|9 9 9 9 9...
C             |1 3 5 7 9 1 3 5 7 9 1 3 5 7 9|1 3 5 7 9 1 3 5 7 9 1 3 5 7 9|1 3 5 7 9 1 3 5 7 9 1 3 5 7 9|1 3 5 7 9...
C  BIT(index) |                    1 1 1 1 1|                    1 1 1 1 1|                    1 1 1 1 1|
C             |0 1 2 3 4 5 6 7 8 9 0 1 2 3 4|0 1 2 3 4 5 6 7 8 9 0 1 2 3 4|0 1 2 3 4 5 6 7 8 9 0 1 2 3 4|0 1 2 3 4...
c     3 step  |  *     *     *     *     *  |  *     *     *     *     *  |  *     *     *     *     *  |  *     *
c     5 step  |    *         *         *    |    *         *         *    |    *         *         *    |    *
c     7 step  |      x             x        |    x             *          |  *             *            |*

Concoct the initial state, once only, that repeats every SURGE.
          START = .TRUE.	!Prepare the field.
          DO I = 2,PREZAP	!Only odd numbers are represented, so no PRIME(1) = 2..
            P = PRIME(I)	!Select a step.
            START(P/2:LB:P) = .FALSE.	!Knock out multiples of P.
          END DO		!This pattern is palindromic.
          NN = 0	!Syncopation. Where the previous surge ended.
Commence a pass through the BIT sieve.
   10     N0 = NN		!BIT(0) corresponds to N0 + 1, BIT(i) to N0 + 1 + 2i.
          NN = NN + SURGE	!BIT(LB) to NN - 1.
          BIT = START		!Pre-zapped for lesser primes.
          IP = PREZAP		!Syncopation. The last pre-zapped prime.
   11     IP = IP + 1		!The next prime to sieve with.
          IF (IP.GT.NP) CALL SCANFOR(.TRUE.)	!Whoops, not yet to hand!
          P = PRIME(IP)		!Now grab it.
          IF (P*P.GE.NN) GO TO 12	!If P*P exceeds the end, so will larger P.
          I = N0/P + 1			!First multiple of P past N0.
          IF (I.LT.P) I = P		!Less than P is superfluous: the position was zapped by earlier action.
          IF (MOD(I,2).EQ.0) I = I + 1	!If even, advance to the next odd multiple. Such as P.
          I = I*P			!The first number to zap. It will always be odd.
          IF (I.LT.NN) THEN		!Within the span?
            I = (I - N0 - 1)/2		!Yes. Its offset into the current span.
            BIT(I:LB:P) = .FALSE.	!Zap every P'th position.
          END IF			!So much for that P.
          GO TO 11		!On to the next.
Completed the passes. Scan for survivors.
   12     CALL SCANFOR(.FALSE.)		!All, not just the first new prime.
          IF (NP.LT.LASTP) GO TO 10	!Another batch?
          RETURN		!Done.
         CONTAINS	!Fold two usages into one routine.
          SUBROUTINE SCANFOR(ONE)	!Finds survivors.
           LOGICAL ONE		!Perhaps only the first is desired.
           INTEGER I,P		!Assistants.
            DO I = 0,LB		!Scan the current state.
              IF (BIT(I)) THEN		!Is this one unsullied?
                P = N0 + 1 + 2*I	!Yes! This is its value.
                IF (P.LE.PRIME(NP)) CYCLE	!But we may have it already.
                IF (NP.GE.LASTP) RETURN		!Whoops, perhaps too many!
                NP = NP + 1		!But if not, another new prime!
                PRIME(NP) = P		!So, stash it. Extract now just this one.
                IF (ONE) RETURN		!Later candidates may yet be unzapped.
              END IF			!So much for that value.
            END DO			!On to the next.
          END SUBROUTINE SCANFOR	!An odd IF allows for two usages in one routine.
        END SUBROUTINE PREPARE PRIMES	!Faster than reading from a disc file?
      END MODULE ERATOSTHENES	!Certainly, less storage is required this way.

      PROGRAM PRIMORIAL	!Simple enough, with some assistants.
      USE ERATOSTHENES	!Though probably not as he expected.
      USE BIGNUMBERS	!Just so.
      TYPE(BIGNUM) B	!I'll have one.
      INTEGER P,MARK	!Step stuff.
      INTEGER E,D	!Assistants for the floating-point analogue...
      INTEGER TASTE,IT	!Additional stuff for its rounding.
      PARAMETER (TASTE = 8/BIGORDER)	!Sufficient digits to show.
      INTEGER LEAD(TASTE)		!With a struggle.
      REAL T0,T1	!Some CPU time attempts.
      REAL*4 F4		!I'll also have a go via logs.
      REAL*8 F8		!In two precisions.
      INTEGER I4,I8	!Not much hope for single precision, though.

      WRITE (6,1) LASTP,BIGBASE	!Announce.
    1 FORMAT ("Calculates primorial numbers up to prime ",I0,
     1 ", working in base ",I0)
      CALL PREPARE PRIMES	!First, catch your rabbit.

Commence prime mashing.
  100 B.LAST = 1	!Begin at the beginning.
      B.DIGIT(1) = 1	!With one.
      DO P = 0,9	!Step up to the ninth prime, thus the first ten values as specified.
        CALL BIGMULT(B,PRIME(P))	!Multiply by a possibly large integer.
        WRITE (6,101) P,PRIME(P),P,B.DIGIT(B.LAST:1:-1)	!Digits in Arabic/Hindu order.
  101   FORMAT ("Prime(",I0,") = ",I0,", Primorial(",I0,") = ",
     1   I0,9I<BIGORDER>.<BIGORDER>,/,(10I<BIGORDER>.<BIGORDER>))
      END DO		!On to the next prime.

Convert to logarithmic striders.
      CALL CPU_TIME(T0)	!Start the clock.
      MARK = 10		!To be remarked upon in passing.
      DO P = 10,LASTP	!Step through additional primes.
        CALL BIGMULT(B,PRIME(P))	!Bigger, ever bigger the big number grows.
        IF (P.EQ.MARK) THEN		!A report point?
          MARK = MARK*10		!Yes. Prepare to note the next.
          CALL CPU_TIME(T1)		!Where are we at?
          E = (B.LAST - 1)*BIGORDER	!Convert from 10**BIGORDER to base 10.
          D = B.DIGIT(B.LAST)		!Grab the high-order digit.
          DO WHILE(D.GT.0)		!It is not zero..
            E = E + 1			!So it is at least one base ten digit.
            D = D/10			!Snip.
          END DO			!And perhaps there will be more.
Contemplate the rounding of the floating-point analogue.
          I4 = MIN(TASTE,B.LAST)	!I'm looking to taste the top digits.
          LEAD(1:I4) = B.DIGIT(B.LAST:B.LAST - I4 + 1:-1)	!Reverse, to have normal order.
          IF (B.LAST.GT.TASTE) THEN	!Are there even more digits?
            IT = I4			!Yes. This is now the low-order digit tasted.
            D = 0			!We should consider rounding up.
            IF (B.DIGIT(B.LAST - I4).GE.BIGBASE/2) D = 1	!If the next digit is big enough.
            DO WHILE (D.GT.0)		!Spread the carry.
              D = 0				!This one is used up.
              LEAD(IT) = LEAD(IT) + 1		!Thusly.
              IF (LEAD(IT).GT.BIGBASE) THEN	!But, maybe, overflow!
                IF (IT.GT.1) THEN		!Is there a higher-order to carry to?
                  LEAD(IT) = LEAD(IT) - BIGBASE		!Yes!
                  IT = IT - 1				!Step back to it,
                  D = 1					!Reassert a carry.
                END IF				!But only if there was a recipient available.
              END IF			!If not, the carry will still be zero.
            END DO			!And the loop won't continue.
          END IF			!So, no test for IT > 0 in a compound "while".
Cast forth the results.
          WRITE (6,102) P,PRIME(P),	!Name the step and its prime.
     1     P,LEAD(1:I4),E,		!The step and the leading few DIGIT of its primorial.
     2     T1 - T0			!CPU advance.
  102     FORMAT ("Prime(",I0,") = ",I0,", Primorial(",I0,") ~ 0."	!Approximately.
     1     I0,<I4 - 1>I<BIGORDER>.<BIGORDER>,"E+",I0,	!No lead zero digits, then with lead zero digits.
     2     T80,F12.3," seconds.")	!Append some CPU time information.
          T0 = T1			!Ready for the next popup.
        END IF				!So much for a report.
      END DO		!On to the next prime.

Chew some logarithms.
  110 WRITE (6,111)	!Some explanation.
  111 FORMAT (/,"Via summing logarithms: Single             Double")	!Ah, layout.
      MARK = 10		!Start somewhere interesting.
  112 F4 = SUM(LOG10( FLOAT(PRIME(1:MARK))))	!Whee!
      F8 = SUM(LOG10(DFLOAT(PRIME(1:MARK))))	!Generic function names too.
      I4 = F4		!Grab the integer part.
      I8 = F8		!The idea being to isolate the fractional part.
      WRITE (6,113) MARK,"10",10**(F4 - I4),I4 + 1,10**(F8 - I8),I8 + 1	!Reconstitute the number in extended E-format.
  113 FORMAT (I8,"#...in base ",A2,-1PF9.5,"E+",I0,T40,-1PF13.7,"E+",I0)	!As if via E-format.
      F4 = SUM(LOG( FLOAT(PRIME(1:MARK))))/LOG(10.0)	!Do it again in Naperian logs.
      F8 = SUM(LOG(DFLOAT(PRIME(1:MARK))))/LOG(10D0)	!Perhaps more accurately?
      I4 = F4
      I8 = F8
      WRITE (6,113) MARK,"e ",10**(F4 - I4),I4 + 1,10**(F8 - I8),I8 + 1	!We'll see.
      MARK = MARK*10	!The next reporting point.
      IF (MARK.LE.LASTP) GO TO 112	!Are we there yet?
      END	!So much for that.
