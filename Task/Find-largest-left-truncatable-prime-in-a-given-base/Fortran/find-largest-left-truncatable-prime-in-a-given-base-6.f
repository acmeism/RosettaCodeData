      USE PRIMEBAG	!Gain access to NEXTPRIME and ISPRIME.
      USE BIGNUMBERVB	!Alas, INTEGER*600 is not available.
Calculates the largest "left-truncatable" digit sequence that is a prime number, in various bases.
      INTEGER LBASE,MANY	!Some sizes.
      PARAMETER (LBASE = 17, MANY = 66666)
      INTEGER NS,START(LBASE)	!A list of single-digit prime numbers for starters.
      TYPE(BIGNUM) HORDE(MANY)	!A collection.
      INTEGER N,NH,LH		!Counters for the horde.
      INTEGER L		!The length of the digit sequence.
      INTEGER I,D	!Steppers.
      CHARACTER*42 TEXT	!A scratchpad, for decimal values.
      REAL T0,T1	!In memory of lost time.

      MSG = 6	!I/O unit number for "standard output".
      IF (.NOT.GRASPPRIMEBAG(66)) STOP "Gan't grab my file!"	!Attempt in hope.
      NS = 0	!No starters.
      N = 1	!Start looking for some primes.
    1 N = NEXTPRIME(N)	!Thus skipping non-primes.
      IF (N.LE.LBASE) THEN	!Beyond the limit?
        NS = NS + 1		!No. Count another starter.
        START(NS) = N		!Save its value.
        GO TO 1			!And seek further.
      END IF		!One could insted prepare some values, the primes being well-known.
      WRITE (MSG,2) LBASE,NS,START(1:NS)	!But, parameterisation is easy enough.
    2 FORMAT ("Working in bases 3 to ",I0," there are ",I0,	!Announce the known.
     * " single-digit primes: ",666(I0:", "))	!The : sez stop if the list is exhausted.
      WRITE (MSG,3)		!Produce a heading for the tabular output.
    3 FORMAT (/"Base Digits Count",29X," Maximum Value = (in base)")	!See Format 31.

Chug through the various bases to be used for the numerology.
      CALL CPU_TIME(T0)	!Start the timing.
   10 DO BIGBASE = 3,LBASE	!Not really very BIG bases.
        NH = 0			!The horde is empty.
        DO I = 1,NS		!Prepare the starters for base BIGBASE.
          IF (START(I).GE.BIGBASE) EXIT	!Like, they're single-digits in base BIGBASE which may exceed ten...
          NH = NH + 1			!So, count another in.
          HORDE(NH).DIGIT(1) = START(I)		!Its numerical value.
          HORDE(NH).LAST = 1			!Its digit count. Just one.
        END DO			!On to the next single-digit prime number in BIGBASE.
        L = 1		!The numbers all have one digit.
Consider each starter for extension via another high-order digit, to be placed at DIGIT(L + 1).
   20   L = L + 1	!We're about to add another digit, now at DIGIT(L).
        IF (L.GT.BIGLIMIT) STOP "Too many digits!"	!Hopefully, there's room.
        HORDE(1:NH).LAST = L	!There is. Advise the BIGNUM horde of this.
        LH = NH		!The live ones, awaiting extension.
        DO I = 1,LH	!Step through each starter.
          DO D = 1,BIGBASE - 1	!Consider all possible lead digits.
            HORDE(I).DIGIT(L) = D	!Place it at the start of the number.
            IF (BIGISPRIME(HORDE(I))) THEN	!And if it is a prime, or seems likely to be ...
              IF (NH.GE.MANY) STOP "Too many sequences!"	!Add a sequence.
              NH = NH + 1			!Count in a survivor.
              HORDE(NH).LAST = L		!Its digit count.
              HORDE(NH).DIGIT(1:L) = HORDE(I).DIGIT(1:L)	!Its digits.
            END IF			!So much for persistent primality.
          END DO		!On to the next lead digit.
        END DO		!On to the next starter.
Check for added entries and compact the collection if there are some.
        N = NH - LH		!The number of entries added to the horde.
        IF (N.GT.0) THEN	!Were there any?
          DO I = 1,MIN(LH,N)		!Yes. Overwrite the starters.
            HORDE(I).LAST = HORDE(NH).LAST	!From the tail end of the horde.
            HORDE(I).DIGIT(1:L) = HORDE(NH).DIGIT(1:L)	!Copying only the live digits.
            NH = NH - 1				!One snipped off.
          END DO			!Thus fill the gap at the start.
          NH = N			!The new horde count.
          GO TO 20			!See how it goes.
        END IF			!So much for further progress.
Cast forth the mostest of the starters.
   30   HORDE(1:NH).LAST = L - 1	!The testing involved an extra digit, which was not accepted.
        L = 1		!Now go looking for the mostest of the survivors.
        DO I = 2,NH	!By comparing all the rest.
          IF (BIGSIGN(HORDE(L),HORDE(I)).LT.0) L = I	!Consider A - B.
        END DO		!On to the next.
        CALL BIGTEN(HORDE(L),TEXT)	!Get a decimal digit string.
        WRITE (MSG,31) BIGBASE,HORDE(L).LAST,NH,TEXT	!Some auxiliary details.
   31   FORMAT (I4,I7,I6,1X,A," = ",$)			!See Format 3.
        CALL BIGWRITE(MSG,HORDE(L))		!The number at last!
        WRITE (MSG,*)				!Finish the line.
      END DO		!On to the next base.
      CALL CPU_TIME(T1)	!Completed the run.

Closedown.
  200 WRITE (MSG,201)	!First, some statistics.
  201 FORMAT (/,"The MR prime test makes a series of trials, "
     1 "stopping early",/'only when a "definitely composite" ',
     2 "result is encountered.")
      WRITE (MSG,202) "Trial",(I,I = 1,BIGMRTRIALS)	!Roll the trial number.
      WRITE (MSG,202) "Count",BIGMRCOUNT		!Now the counts.
  202 FORMAT (A6,": ",666I8)	!This should do.
      WRITE (MSG,*) "CPU time:",T1 - T0	!The cost.
      END	!Simple enough.
