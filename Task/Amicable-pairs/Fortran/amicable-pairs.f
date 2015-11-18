      MODULE FACTORSTUFF	!This protocol evades the need for multiple parameters, or COMMON, or one shapeless main line...
Concocted by R.N.McLean, MMXV.
       INTEGER LOTS,ILIMIT		!Some bounds.
       PARAMETER (ILIMIT = 2147483647)	!Computer arithmetic is not with real numbers.
       PARAMETER (LOTS = 22000)	!Nor is computer storage infinite.
       INTEGER KNOWNSUM(LOTS)		!Calculate these once as multiple references are expected.
       CONTAINS			!Assistants.
        INTEGER FUNCTION SUMF(N)	!Sum of the proper divisors of N.
         INTEGER N			!The number in question.
         INTEGER S,F,F2,INC,BOOST	!Assistants.
          IF (N.LE.LOTS) THEN		!If we're within reach,
            SUMF = KNOWNSUM(N)			!The result is to hand.
           ELSE			!Otherwise, some on-the-spot effort ensues.
Could use SUMF in place of S, but some compilers have been confused by such usage.
            S = 1			!1 is always a factor of N, but N is deemed not.
            F = 1			!Prepare a crude search for factors.
            INC = 1			!One by plodding one.
            IF (MOD(N,2) .EQ. 1) INC = 2!Ah, but an odd number cannot have an even number as a divisor.
    1       F = F + INC			!So half the time we can doubleplod.
            F2 = F*F				!Up to F2 < N rather than F < SQRT(N) and worries over inexact arithmetic.
            IF (F2 .LT. N) THEN			!F2 = N handled below.
              IF (MOD(N,F) .EQ. 0) THEN		!Does F divide N?
                BOOST = F + N/F			!Yes. The divisor and its counterpart.
                IF (S .GT. ILIMIT - BOOST) GO TO 666	!Would their augmentation cause an overflow?
                S = S + BOOST			!No, so count in the two divisors just discovered.
              END IF				!So much for a divisor discovered.
              GO TO 1				!Try for another.
            END IF			!So much for the horde.
            IF (F2 .EQ. N) THEN	!Special case: N may be a perfect square, not necessarily of a prime number.
              IF (S .GT. ILIMIT - F) GO TO 666	!It is. And it too might cause overflow.
              S = S + F			!But if not, count F once only.
            END IF			!All done.
            SUMF = S			!This is the result.
          END IF			!Whichever way obtained,
         RETURN			!Done.
Cannot calculate the sum, because it exceeds the integer limit.
  666     SUMF = -666		!An expression of dismay that the caller will notice.
        END FUNCTION SUMF	!Alternatively, find the prime factors, and combine them...
         SUBROUTINE PREPARESUMF	!Initialise the KNOWNSUM array.
Convert the Sieve of Eratoshenes to have each slot contain the sum of the proper divisors of its slot number.
Changes to instead count the number of factors, or prime factors, etc. would be simple enough.
         INTEGER F		!A factor for numbers such as 2F, 3F, 4F, 5F, ...
          KNOWNSUM(1) = 0		!Proper divisors of N do not include N.
          KNOWNSUM(2:LOTS) = 1		!So, although 1 is a proper divisor of all N, 1 is excluded for itself.
          DO F = 2,LOTS/2		!Step through all the possible divisors of numbers not exceeding LOTS.
            FOR ALL(I = F + F:LOTS:F) KNOWNSUM(I) = KNOWNSUM(I) + F	!And augment each corresponding slot.
          END DO			!Different divisors can hit the same slot. For instance, 6 by 2 and also by 3.
        END SUBROUTINE PREPARESUMF	!Could alternatively generate all products of prime numbers.
      END MODULE FACTORSTUFF	!Enough assistants.
       PROGRAM AMICABLE		!Seek N such that SumF(SumF(N)) = N, for N up to 20,000.
       USE FACTORSTUFF		!This should help.
       INTEGER I,N		!Steppers.
       INTEGER S1,S2		!Sums of factors.
        CALL PREPARESUMF		!Values for every N up to the search limit will be called for at least once.
c        WRITE (6,66) (I,KNOWNSUM(I), I = 1,48)
c   66   FORMAT (10(I3,":",I5,"|"))
        DO N = 2,20000		!Step through the specified search space.
          S1 = SUMF(N)			!Only even numbers appear in the results, but check every one anyway.
          IF (S1 .EQ. N) THEN		!Catch a tight loop.
            WRITE (6,*) "Perfect!!",N	!Self amicable! Would otherwise appear as Amicable! n,n.
          ELSE IF (S1 .GT. N) THEN	!Look for a pair going upwards only.
            S2 = SUMF(S1)		!Since otherwise each would appear twice.
            IF (S2.EQ.N) WRITE (6,*) "Amicable!",N,S1	!Aha!
          END IF			!So much for that candidate.
        END DO			!On to the next.
      END			!Done.
