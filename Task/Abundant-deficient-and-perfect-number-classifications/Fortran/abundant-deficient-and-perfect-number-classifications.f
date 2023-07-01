      MODULE FACTORSTUFF	!This protocol evades the need for multiple parameters, or COMMON, or one shapeless main line...
Concocted by R.N.McLean, MMXV.
       INTEGER LOTS		!The span..
       PARAMETER (LOTS = 20000)!Nor is computer storage infinite.
       INTEGER KNOWNSUM(LOTS)	!Calculate these once.
       CONTAINS		!Assistants.
        SUBROUTINE PREPARESUMF	!Initialise the KNOWNSUM array.
Convert the Sieve of Eratoshenes to have each slot contain the sum of the proper divisors of its slot number.
Changes to instead count the number of factors, or prime factors, etc. would be simple enough.
         INTEGER F		!A factor for numbers such as 2F, 3F, 4F, 5F, ...
          KNOWNSUM(1) = 0		!Proper divisors of N do not include N.
          KNOWNSUM(2:LOTS) = 1		!So, although 1 divides all N without remainder, 1 is excluded for itself.
          DO F = 2,LOTS/2		!Step through all the possible divisors of numbers not exceeding LOTS.
            FORALL(I = F + F:LOTS:F) KNOWNSUM(I) = KNOWNSUM(I) + F	!And augment each corresponding slot.
          END DO			!Different divisors can hit the same slot. For instance, 6 by 2 and also by 3.
        END SUBROUTINE PREPARESUMF	!Could alternatively generate all products of prime numbers.
         PURE INTEGER FUNCTION SIGN3(N)	!Returns -1, 0, +1 according to the sign of N.
Confounded by the intrinsic function SIGN distinguishing only two states: < 0 from >= 0. NOT three-way.
         INTEGER, INTENT(IN):: N	!The number.
          IF (N) 1,2,3	!A three-way result calls for a three-way test.
    1     SIGN3 = -1	!Negative.
          RETURN
    2     SIGN3 = 0	!Zero.
          RETURN
    3     SIGN3 = +1	!Positive.
        END FUNCTION SIGN3	!Rather basic.
      END MODULE FACTORSTUFF	!Enough assistants.
       PROGRAM THREEWAYS	!Classify N against the sum of proper divisors of N, for N up to 20,000.
       USE FACTORSTUFF		!This should help.
       INTEGER I		!Stepper.
       INTEGER TEST(LOTS)	!Assesses the three states in one pass.
        WRITE (6,*) "Inspecting sums of proper divisors for 1 to",LOTS
        CALL PREPARESUMF		!Values for every N up to the search limit will be called for at least once.
        FORALL(I = 1:LOTS) TEST(I) = SIGN3(KNOWNSUM(I) - I)	!How does KnownSum(i) compare to i?
        WRITE (6,*) "Deficient",COUNT(TEST .LT. 0)	!This means one pass through the array
        WRITE (6,*) "Perfect! ",COUNT(TEST .EQ. 0)	!For each of three types.
        WRITE (6,*) "Abundant ",COUNT(TEST .GT. 0)	!Alternatively, make one pass with three counts.
      END			!Done.
