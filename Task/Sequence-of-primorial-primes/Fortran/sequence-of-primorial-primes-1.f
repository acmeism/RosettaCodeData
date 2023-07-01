      PROGRAM PRIMORIALP	!Simple enough, with some assistants.
      USE PRIMEBAG		!Some prime numbers are wanted.
      USE BIGNUMBERS		!Just so.
      TYPE(BIGNUM) B		!I'll have one.
      INTEGER MAXF		!Largest factor to consider by direct division.
      PARAMETER (MAXF = 18000000)	!Some determination.
      INTEGER I			!Step stuff.
      INTEGER FU,FD		!Found factors.
      INTEGER NHIT,HIT(666)	!A little list.
      CHARACTER*4 WOT		!A remark.
      CHARACTER*66 ALINE	!A scratchpad.
      REAL T0,T1		!In memory of lost time.
      MSG = 6	!Standard output.
      WRITE (MSG,1) BIGLIMIT,BIGBASE,HUGE(I)	!Announce.
    1 FORMAT ('Calculates primorial "primes"',/,
     1 "A primorial prime is a value N such that",/,
     2 "    Primorial(N) - 1 is prime, OR",/,
     3 "    Primorial(N) + 1 is prime, or both.",/,
     4 "and Primorial(N) is the product of the first N prime numbers.",/
     5 "Working with up to ",I0," digits in base ",I0,"."/
     6 "The integer limit is ",I0,/)

c      CALL PREPARE PRIMES	!First, catch your rabbit. Via ERATOSTHENES.
      IF (.NOT.GRASPPRIMEBAG(66)) STOP "Gan't grab my file!"	!Attempt in hope.
      WRITE (MSG,2)
    2 FORMAT ("Primorial#",3X,"Approx.",8X," -1 Factor +1 Factor Hit")

Commence prime mashing.
  100 NHIT = 0		!My list is empty.
      B.LAST = 1	!Begin at the beginning.
      B.DIGIT(1) = 1	!With one. The same, whatever BIGBASE.
      CALL CPU_TIME(T0)	!Start the timing.
      DO I = 1,30	!69	!Step along the primorials.
        CALL BIGMULTN(B,PRIME(I))	!Multiply by the next prime.
c        WRITE (MSG,101) I,PRIME(I),I,B.DIGIT(B.LAST:1:-1)	!Digits in Arabic/Hindu order.
  101   FORMAT ("Prime(",I0,") = ",I0,", Primorial(",I0,") = ",	!For a possibly multi-BIGBASE sequence.
     1   I0,9I<BIGORDER>.<BIGORDER>,/,(10I<BIGORDER>.<BIGORDER>))	!The first without leading zero digits.
        FU = -1		!No factor for up one.
        FD = -1		!No factor for down one.
        CALL BIGADDN(B,+1)	!Go up one.
        FU = BIGFACTOR(B,MAXF)	!Find a factor, maybe.
        CALL BIGADDN(B,-2)	!Now test down one.
        IF (FU.NE.1) FD = BIGFACTOR(B,MAXF)	!But only if FU didn't report "prime".
        IF (FU.EQ.1 .OR. FD.EQ.1) THEN	!Since if either candidate is a prime,
          WOT = "Yes!"				!Then a hit.
          NHIT = NHIT + 1			!So count up a success.
          HIT(NHIT) = I				!And append to my list.
        ELSE IF (FU.GT.1 .AND. FD.GT.1) THEN	!But if both have factors,
          WOT = "No."				!Then definitely not a hit.
        ELSE				!Otherwise,
          WOT = "?"				!I can't decide.
        END IF				!So much for that candidate.
        CALL BIGADDN(B,1)		!Recover the original primorial value.
        WRITE (ALINE,102) I,BIGVALUE(B),FD,FU,WOT	!Prepare a report.
  102   FORMAT (I10,1PE18.10,I10,I10,1X,A)	!A table.
        IF (FD.EQ.-1) ALINE(37:38) = ""		!Wasn't looked for, so no remark.
        IF (FD.EQ. 0) ALINE(38:38) = "?"	!Recode a zero.
        IF (FU.EQ. 0) ALINE(48:48) = "?"	!Since it represents "Don't know".
        WRITE (MSG,"(A)") ALINE		!Show the report.
      END DO		!On to the next prime.
      CALL CPU_TIME(T1)	!Completed the run.

Cast forth some pearls.
      WRITE (MSG,201) HIT(1:NHIT)	!The list.
  201 FORMAT (/,"Hit list: ",I0,666(",",I0:))	!Don't actually expect so many.
      WRITE (MSG,*) "CPU time:",T1 - T0	!The cost.
      END	!So much for that.
