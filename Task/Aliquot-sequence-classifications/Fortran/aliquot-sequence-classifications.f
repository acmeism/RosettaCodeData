      MODULE FACTORSTUFF	!This protocol evades the need for multiple parameters, or COMMON, or one shapeless main line...
Concocted by R.N.McLean, MMXV.
c       INTEGER*4 I4LIMIT
c       PARAMETER (I4LIMIT = 2147483647)
       INTEGER*8 TOOBIG		!Some bounds.
       PARAMETER (TOOBIG = 2**47)	!Computer arithmetic is not with real numbers.
       INTEGER LOTS			!Nor is computer storage infinite.
       PARAMETER (LOTS = 10000)	!So there can't be all that many of these.
       INTEGER*8 KNOWNSUM(LOTS)	!If multiple references are expected, it is worthwhile calculating these.
       CONTAINS			!Assistants.
        INTEGER*8 FUNCTION SUMF(N)	!Sum of the proper divisors of N.
         INTEGER*8 N			!The number in question.
         INTEGER*8 F,F2		!Candidate factor, and its square.
         INTEGER*8 S,INC,BOOST		!Assistants.
          IF (N.LE.LOTS) THEN		!If we're within reach,
            SUMF = KNOWNSUM(N)			!The result is to hand.
           ELSE			!Otherwise, some on-the-spot effort ensues.
Could use SUMF in place of S, but some compilers have been confused by such usage.
            S = 1			!1 is always a factor of N, but N is deemed not proper.
            F = 1			!Prepare a crude search for factors.
            INC = 1			!One by plodding one.
            IF (MOD(N,2) .EQ. 1) INC = 2!Ah, but an odd number cannot have an even number as a divisor.
    1       F = F + INC			!So half the time we can doubleplod.
            F2 = F*F				!Up to F2 < N rather than F < SQRT(N) and worries over inexact arithmetic.
            IF (F2 .LT. N) THEN			!F2 = N handled below.
              IF (MOD(N,F) .EQ. 0) THEN		!Does F divide N?
                BOOST = F + N/F			!Yes. The divisor and its counterpart.
                IF (S .GT. TOOBIG - BOOST) GO TO 666	!Would their augmentation cause an overflow?
                S = S + BOOST			!No, so count in the two divisors just discovered.
              END IF				!So much for a divisor discovered.
              GO TO 1				!Try for another.
            END IF			!So much for N = p*q style factors.
            IF (F2 .EQ. N) THEN	!Special case: N may be a perfect square, not necessarily of a prime number.
              IF (S .GT. TOOBIG - F) GO TO 666	!It is. And it too might cause overflow.
              S = S + F			!But if not, count F once only.
            END IF			!All done.
            SUMF = S			!This is the result.
          END IF			!Whichever way obtained,
         RETURN			!Done.
Cannot calculate the sum, because it exceeds the INTEGER*8 limit.
  666     SUMF = -666		!An expression of dismay that the caller will notice.
        END FUNCTION SUMF	!Alternatively, find the prime factors, and combine them...
         SUBROUTINE PREPARESUMF	!Initialise the KNOWNSUM array.
Convert the Sieve of Eratoshenes to have each slot contain the sum of the proper divisors of its slot number.
Changes to instead count the number of factors, or prime factors, etc. would be simple enough.
         INTEGER*8 F		!A factor for numbers such as 2F, 3F, 4F, 5F, ...
          KNOWNSUM(1) = 0		!Proper divisors of N do not include N.
          KNOWNSUM(2:LOTS) = 1		!So, although 1 divides all N without remainder, 1 is excluded for itself.
          DO F = 2,LOTS/2		!Step through all the possible divisors of numbers not exceeding LOTS.
            FORALL(I = F + F:LOTS:F) KNOWNSUM(I) = KNOWNSUM(I) + F	!And augment each corresponding slot.
          END DO			!Different divisors can hit the same slot. For instance, 6 by 2 and also by 3.
        END SUBROUTINE PREPARESUMF	!Could alternatively generate all products of prime numbers.
         SUBROUTINE CLASSIFY(N)	!Traipse along the SumF trail.
         INTEGER*8 N		!The starter.
         INTEGER ROPE		!The size of my memory is not so great..
         PARAMETER(ROPE = 16)	!Indeed, this is strictly limited.
         INTEGER*8 TRAIL(ROPE)	!But the numbers can be large.
         INTEGER*8 SF		!The working sum of proper divisors.
         INTEGER I,L		!Indices, merely.
         CHARACTER*28 THIS	!A perfect scratchpad for remarks.
          L = 1		!Every journey starts with its first step.
          TRAIL(1) = N		!Which is this.
          SF = N		!Syncopation.
   10     SF = SUMF(SF)		!Step onwards.
          IF (SF .LT. 0) THEN		!Trouble?
            WRITE (THIS,11) L,"overflows!"	!Yes. Too big a number.
   11       FORMAT ("After ",I0,", ",A)		!Describe the situation.
            CALL REPORT(ADJUSTR(THIS))		!And give the report.
          ELSE IF (SF .EQ. 0) THEN		!Otherwise, a finish?
            WRITE (THIS,11) L,"terminates!"	!Yay!
            CALL REPORT(ADJUSTR(THIS))		!This sequence is finished.
          ELSE IF (ANY(TRAIL(1:L) .EQ. SF)) THEN	!Otherwise, is there an echo somewhere?
            IF (L .EQ. 1) THEN				!Yes!
              CALL REPORT("Perfect!")			!Are we at the start?
            ELSE IF (L .EQ. 2) THEN			!Or perhaps not far along.
              CALL REPORT("Amicable:")			!These are held special.
            ELSE					!Otherwise, we've wandered further along.
              I = MINLOC(ABS(TRAIL(1:L) - SF),DIM=1)	!Damnit, re-scan the array to finger the first matching element.
              IF (I .EQ. 1) THEN		!If all the way back to the start,
                WRITE (THIS,12) L		!Then there are this many elements in the sociable ring.
   12           FORMAT ("Sociable ",I0,":")	!Computers are good at counting.
                CALL REPORT(ADJUSTR(THIS))	!So, perform an added service.
              ELSE IF (I .EQ. L) THEN		!Perhaps we've hit a perfect number!
                CALL REPORT("Aspiring:")	!A cycle of length one.
              ELSE				!But otherwise,
                WRITE (THIS,13) L - I + 1,SF	!A longer cycle. Amicable, or sociable.
   13           FORMAT ("Cyclic end ",I0,", to ",I0,":")	!Name the flashback value too.
                CALL REPORT(ADJUSTR(THIS))	!Thus.
              END IF				!So much for cycles.
            END IF			!So much for finding an echo.
          ELSE				!Otherwise, nothing special has happened.
            IF (L .GE. ROPE) THEN		!So, how long is a piece of string?
              WRITE (THIS,11) L,"non-terminating?"	!Not long enough!
              CALL REPORT(ADJUSTR(THIS))		!So we give up.
             ELSE				!But if there is more scope,
              L = L + 1			!Advance one more step.
              TRAIL(L) = SF			!Save the latest result.
              GO TO 10				!And try for the next.
            END IF			!So much for continuing.
          END IF		!So much for the classification.
         RETURN		!Finished.
         CONTAINS		!Not quite.
          SUBROUTINE REPORT(WHAT)	!There is this service routine.
           CHARACTER*(*) WHAT		!Whatever the length of the text, the FORMAT's A28 shows 28 characters, right-aligned.
            WRITE (6,1) WHAT,TRAIL(1:L)!Mysteriously, a fresh line after every twelve elements.
    1       FORMAT (A28,1X,12(I0:","))	!And obviously, the : signifies "do not print what follows unless there is another number to go.
          END SUBROUTINE REPORT	!That was easy.
        END SUBROUTINE CLASSIFY	!Enough.
       END MODULE FACTORSTUFF	!Enough assistants.
       PROGRAM CLASSIFYTHEM	!Report on the nature of the sequence N, Sumf(N), Sumf(Sumf(N)), etc.
       USE FACTORSTUFF		!This should help.
       INTEGER*8 I,N		!Steppers.
       INTEGER*8 THIS(14)	!A testing collection.
       DATA THIS/11,12,28,496,220,1184,12496,1264460,790,909,     !Old-style continuation character in column six.
     1  562,1064,1488,15355717786080/	!Monster value far exceeds the INTEGER*4 limit
         CALL PREPARESUMF		!Prepare for 1:LOTS, even though this test run will use only a few.
         DO I = 1,10			!As specified, the first ten integers.
          CALL CLASSIFY(I)
        END DO
         DO I = 1,SIZE(THIS)		!Now for the specified list.
          CALL CLASSIFY(THIS(I))
        END DO
       END			!Done.
