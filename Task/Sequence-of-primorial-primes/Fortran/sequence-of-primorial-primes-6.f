      PROGRAM PRIMORIALP	!Simple enough, with some assistants.
      USE PRIMEBAG		!Some prime numbers are wanted.
      USE BIGNUMBERS		!Just so.
      TYPE(BIGNUM) B		!I'll have one.
      INTEGER MAXF		!Largest factor to consider by direct division.
      PARAMETER (MAXF = 1000000)	!Some determination.
      INTEGER I,L,P			!Step stuff.
      INTEGER FU,FD,FUD(2)	!Found factors.
      EQUIVALENCE (FUD(1),FD),(FUD(2),FU)	!A struggle to prepare an array.
      INTEGER NHIT,HIT(666)	!A little list.
      CHARACTER*4 WOT		!A remark.
      CHARACTER*66 ALINE	!A scratchpad.
      REAL T0,T1		!In memory of lost time.
      MSG = 6	!Standard output.
      WRITE (MSG,1) BIGLIMIT,BIGBASE,HUGE(P),HUGE(INT8(P)),MAXF	!Announce.
    1 FORMAT ('Calculates primorial "primes"',/,
     1 "A primorial prime is a value N such that",/,
     2 "    Primorial(N) - 1 is prime, OR",/,
     3 "    Primorial(N) + 1 is prime, or both.",/,
     4 "and Primorial(N) is the product of the first N prime numbers.",/
     5 "Working with up to ",I0," digits in base ",I0,"."/
     6 "Integer limits are ",I0," and ",I0/
     7 "Primes up to ",I0," are tried as possible factors.")

      IF (.NOT.GRASPPRIMEBAG(66)) STOP "Gan't grab my file!"	!Attempt in hope.
      WRITE (MSG,2)
    2 FORMAT (34X,"First     First"/,
     1 "Primorial#",5X,"Approx.",7X," -1 Factor +1 Factor Hit")

Commence prime mashing.
  100 NHIT = 0		!My list is empty.
      B.LAST = 1	!Begin at the beginning.
      B.DIGIT(1) = 1	!With one. The same, whatever BIGBASE.
      CALL CPU_TIME(T0)	!Start the timing.
      DO P = 1,80 !460	!Step along the primorials. 457 is the 20'th.
        CALL BIGMULTN(B,PRIME(P))	!Multiply by the next prime.
c        WRITE (MSG,101) P,PRIME(P),P,B.DIGIT(B.LAST:1:-1)	!Digits in Arabic/Hindu order.
  101   FORMAT ("Prime(",I0,") = ",I0,", Primorial(",I0,") = ",	!For a possibly multi-BIGBASE sequence.
     1   I0,29I<BIGORDER>.<BIGORDER>,/,(10I<BIGORDER>.<BIGORDER>))	!The first without leading zero digits.
        FU = 0		!No factor for up one.
        FD = 0		!No factor for down one.
        CALL BIGADDN(B,+1)	!Go up one.
        FU = BIGFACTOR(B,MAXF)	!Find a factor, maybe.
        CALL BIGADDN(B,-2)	!Now test down one.
        IF (ABS(FU).NE.1) FD = BIGFACTOR(B,MAXF)	!But only if FU didn't report "prime".
        IF (ABS(FU).EQ.1 .OR. ABS(FD).EQ.1) THEN	!Since if either candidate is a prime,
          WOT = "Yes!"				!Then a hit.
          NHIT = NHIT + 1			!So count up a success.
          HIT(NHIT) = P				!And append to my list.
        ELSE IF (ABS(FU).GT.1 .AND. ABS(FD).GT.1) THEN	!But if both have factors,
          WOT = "No."				!Then definitely not a hit.
        ELSE				!Otherwise,
          WOT = "?"				!I can't decide.
        END IF				!So much for that candidate.
        CALL BIGADDN(B,1)	!Recover the original primorial value.
        CALL BIGTASTE(B)	!Prepare an approximate value in BIGLEAD.
        WRITE (ALINE,102) P,BIGLEAD,FD,FU,WOT	!Prepare a report.
  102   FORMAT (I10,"  0.",<BIGLEADN>I0,T24,"E+",I0,T30,I10,I10,1X,A)	!A table.
        DO I = 1,2	!Two columns to the table.
          L = 20 + I*10		!Each with the same interpretation.
          SELECT CASE(FUD(I))	!So, one set of code.
           CASE(-2); ALINE(L:L+9) = " Composite"
           CASE(-1); ALINE(L:L+9) = "  MR prime"
           CASE( 0); ALINE(L+9:L+9) = "?"     	!Don't know. Didn't look.
           CASE DEFAULT		!All other values stay. The first factor.
          END SELECT		!So much for re-interpretation.
        END DO		!On to the next column.
        WRITE (MSG,"(A)") ALINE		!Show the report.
      END DO		!On to the next prime.
      CALL CPU_TIME(T1)	!Completed the run.

Cast forth some pearls.
  200 WRITE (MSG,201)	!First, some statistics.
  201 FORMAT (/,"The MR prime test makes a series of trials, "
     1 "stopping early",/'only when a "definitely composite" ',
     2 "result is encountered.")
      WRITE (MSG,202) "Trial",(I,I = 1,BIGMRTRIALS)	!Roll the trial number.
      WRITE (MSG,202) "Count",BIGMRCOUNT		!Now the counts.
  202 FORMAT (A6,": ",666I6)	!This should do.
      WRITE (MSG,203) NHIT,HIT(1:NHIT)	!The list of primorial "primes"..
  203 FORMAT (/,I0," in the hit list: ",I0,666(",",I0:))	!Don't actually expect so many.
      WRITE (MSG,*) "CPU time:",T1 - T0	!The cost.
      END	!So much for that.
