      MODULE FACTORISE	!Produce a little list...
       USE PRIMEBAG		!This is a common need.
       INTEGER LASTP		!Some size allowances.
       PARAMETER (LASTP = 9)	!2*3*5*7*11*13*17*19*23*29 = 6,469,693,230, > 2,147,483,647.
       TYPE FACTORED		!Represent a number fully factored.
        INTEGER PVAL(0:LASTP)	!As a list of prime number indices with PVAL(0) the count.
        INTEGER PPOW(LASTP)	!And the powers. for the fingered primes.
       END TYPE FACTORED	!Rather than as a simple number multiplied out.

       CONTAINS		!Now for the details.
        SUBROUTINE SHOWFACTORS(N)	!First, to show an internal data structure.
         TYPE(FACTORED) N	!It is supplied as a list of prime factors.
         INTEGER I		!A stepper.
          DO I = 1,N.PVAL(0)	!Step along the list.
            IF (I.GT.1) WRITE (MSG,"('x',$)")	!Append a glyph for "multiply".
            WRITE (MSG,"(I0,$)") N.PVAL(I)	!The prime number's value.
            IF (N.PPOW(I).GT.1) WRITE (MSG,"('^',I0,$)") N.PPOW(I)	!With an interesting power?
          END DO		!On to the next element in the list.
          WRITE (MSG,1) N.PVAL(0)	!End the line
    1     FORMAT (": Factor count ",I0)	!With a count of prime factors.
        END SUBROUTINE SHOWFACTORS	!Hopefully, this will not be needed often.

        TYPE(FACTORED) FUNCTION FACTOR(IT)	!Into a list of primes and their powers.
Careful! 1 is not a factor of N, but if N is prime, N is. N = product of its prime factors.
         INTEGER IT,N	!The number and a similar style copy to damage.
         INTEGER F,FP	!A factor and a power.
          IF (IT.LE.0) STOP "Factor only positive numbers!"	!Or else...
          FACTOR.PVAL(0) = 0	!No prime factors have been found. One need not apply.
          F = 0			!NEXTPRIME(F) will return 2, the first factor to try.
          N = IT		!A copy I can damage.
Collapse N into its prime factors.
   10     DO WHILE(N.GT.1)	!Carthaga delenda est?
            IF (ISPRIME(N)) THEN!If the remnant is a prime number,
              F = N			!Then it is the last factor.
              FP = 1			!Its power is one.
              N = 1			!And the reduction is finished.
             ELSE		!Otherwise, continue trying larger factors.
              FP = 0			!It has no power yet.
   11         F = NEXTPRIME(F)		!Go for the next possible factor.
              DO WHILE(MOD(N,F).EQ.0)	!Well?
                FP = FP + 1			!Count a factor..
                N = N/F				!Reduce the number.
              END DO			!Until F's multiplicity is exhausted.
              IF (FP.LE.0) GO TO 11	!No presence? Try the next factor: N has some...
            END IF		!One way or another, F is a prime factor and FP its power.
            IF (FACTOR.PVAL(0).GE.LASTP) THEN	!Have I room in the list?
              WRITE (MSG,1) IT,LASTP		!Alas.
    1         FORMAT ("Factoring ",I0," but with provision for only ",	!This shouldn't happen,
     1         I0," distinct prime factors!")	!If LASTP is correct for the current INTEGER size.
              CALL SHOWFACTORS(FACTOR)		!Show what has been found so far.
              STOP "Not enough storage!"	!Quite.
            END IF			!But normally,
            FACTOR.PVAL(0) = FACTOR.PVAL(0) + 1	!Admit another factor.
            FACTOR.PVAL(FACTOR.PVAL(0)) = F	!The prime number found to be a factor.
            FACTOR.PPOW(FACTOR.PVAL(0)) = FP	!Place its power.
          END DO		!Now seee what has survived.
        END FUNCTION FACTOR	!Thus, a list of primes and their powers.
      END MODULE FACTORISE	!Careful! PVAL(0) is the number of prime factors.

      MODULE SMITHSTUFF	!Now for the strange stuff.
       CONTAINS		!The two special workers.
        INTEGER FUNCTION DIGITSUM(N,BASE)	!Sums the digits of N.
         INTEGER N,IT	!The number, and a copy I can damage.
         INTEGER BASE	!The base for arithmetic,
         IF (N.LT.0) STOP "DigitSum: negative numbers need not apply!"
          DIGITSUM = 0	!Here we go.
          IT = N	!This value will be damaged.
          DO WHILE(IT.GT.0)	!Something remains?
            DIGITSUM = MOD(IT,BASE) + DIGITSUM	!Yes. Grap the low-order digit.
            IT = IT/BASE			!And descend a power.
          END DO		!Perhaps something still remains.
        END FUNCTION DIGITSUM	!Numerology.

        LOGICAL FUNCTION SMITHNUM(N,BASE)	!Worse numerology.
         USE FACTORISE		!To find the prime factord of N.
         INTEGER N		!The number of interest.
         INTEGER BASE		!The base of the numerology.
         TYPE(FACTORED) F	!A list.
         INTEGER I,FD		!Assistants.
          F = FACTOR(N)		!Hopefully, LASTP is large enough for N.
c          write (6,"(a,I0,1x)",advance="no") "N=",N
c          call ShowFactors(F)
          FD = 0		!Attempts via the SUM facility involved too many requirements.
          DO I = 1,F.PVAL(0)	!For each of the prime factors found...
            FD = DIGITSUM(F.PVAL(I),BASE)*F.PPOW(I) + FD	!Not forgetting the multiplicity.
          END DO		!On to the next prime factor in the list.
          SMITHNUM = FD.EQ.DIGITSUM(N,BASE)	!This is the rule.
        END FUNCTION SMITHNUM	!So, is N a joker?
      END MODULE SMITHSTUFF	!Simple enough.

      USE PRIMEBAG	!Gain access to GRASPPRIMEBAG.
      USE SMITHSTUFF	!The special stuff.
      INTEGER LAST		!Might as well document this.
      PARAMETER (LAST = 9999)	!The specification is BELOW 10000...
      INTEGER I,N,BASE		!Workers.
      INTEGER NB,BAG(20)	!Prepare a line's worth of results.
      MSG = 6	!Standard output.

      WRITE (MSG,1) LAST	!Hello.
    1 FORMAT ('To find the "Smith" numbers up to ',I0)
      IF (.NOT.GRASPPRIMEBAG(66)) STOP "Gan't grab my file!"	!Attempt in hope.

   10 DO BASE = 2,12	!Flexible numerology.
        WRITE (MSG,11) BASE	!Here we go again.
   11   FORMAT (/,"Working in base ",I0)
        N = 0			!None found.
        NB = 0			!So, none are bagged.
        DO I = 1,LAST		!Step through the span.
          IF (ISPRIME(I)) CYCLE		!Prime numbers are boring Smith numbers. Skip them.
          IF (SMITHNUM(I,BASE)) THEN	!So?
            N = N + 1				!Count one in.
            IF (NB.GE.20) THEN			!A full line's worth with another to come?
              WRITE (MSG,12) BAG			!Yep. Roll the line to make space.
   12         FORMAT (20I6)				!This will do for a nice table.
              NB = 0					!The line is now ready.
            END IF				!So much for a line buffer.
            NB = NB + 1				!Count another entry.
            BAG(NB) = I				!Place it.
          END IF			!So much for a Smith style number.
        END DO			!On to the next candidate number.
        WRITE (MSG,12) BAG(1:NB)!Wave the tail end.
        WRITE (MSG,13) N	!Save the human some counting.
   13   FORMAT (I9," found.")	!Just in case.
      END DO		!On to the next base.
      END	!That was strange.
