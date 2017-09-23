      USE PRIMEBAG	!Gain access to NEXTPRIME and ISPRIME.
Calculates the largest "left-truncatable" digit sequence that is a prime number, in various bases.
      INTEGER LBASE,MANY,ENUFF	!Some sizes.
      PARAMETER (LBASE = 13, MANY = 66666, ENUFF = 66)
      INTEGER NS,START(LBASE)	!A list of single-digit prime numbers for starters.
      INTEGER NH,LH		!Counters for the horde.
      INTEGER N,HORDEN(MANY)		!Numerical value of a digit sequence.
      INTEGER*1 HORDED(ENUFF,MANY)	!Single-digit values only.
      INTEGER B,D,DB	!The base, a digit, some power of the base.
      INTEGER L		!The length of the digit sequence: DB = B**L.
      INTEGER P		!Possibly a prime number.
      INTEGER I		!A stepper.

      MSG = 6	!I/O unit number for "standard output".
      IF (.NOT.GRASPPRIMEBAG(66)) STOP "Gan't grab my file!"	!Attempt in hope.
      NS = 0	!No starters.
      P = 1	!Start looking for some primes.
    1 P = NEXTPRIME(P)	!Thus skipping non-primes.
      IF (P.LE.LBASE) THEN	!Beyond the limit?
        NS = NS + 1		!No. Count another starter.
        START(NS) = P		!Save its value.
        GO TO 1			!And seek further.
      END IF		!One could insted prepare some values, the primes being well-known.
      WRITE (MSG,2) LBASE,NS,START(1:NS)	!But, parameterisation is easy enough.
    2 FORMAT ("Working in bases 3 to ",I0," there are ",I0,	!Announce the known.
     * " single-digit primes: ",666(I0:", "))	!The : sez stop if the list is exhausted.
      WRITE (MSG,3)		!Produce a heading for the tabular output.
    3 FORMAT (/"Base Digits Count Max. Value = (in base)")

   10 DO B = 3,LBASE	!Work through the bases.
        NH = 0			!The horde is empty.
        DO I = 1,NS		!Prepare the starters for base B.
          IF (START(I).GE.B) EXIT	!Like, they're single-digits in base B.
          NH = NH + 1			!So, count another in.
          HORDEN(NH) = START(I)		!Its numerical value.
          HORDED(1,NH) = START(I)	!Its digits. Just one.
        END DO			!On to the next single-digit prime number.
        L = 0	!Syncopation. The length of the digit sequences.
        DB = 1	!The power for the incoming digit.

   20   L = L + 1	!We're about to add another digit.
        IF (L.GE.ENUFF) STOP "Too many digits!"	!Hopefully, there's room.
        DB = DB*B	!The new power of B.
        IF (DB.LE.0) GO TO 29	!Integer overflow?
        LH = NH		!The live ones, awaiting extension.
        DO I = 1,LH	!Step through each starter.
          N = HORDEN(I)	!Grab its numerical value.
          DO D = 1,B - 1	!Consider all possible lead digits.
            P = D*DB + N		!Place it at the start of the number.
            IF (P.LE.0) GO TO 29	!Oh for IF OVERFLOW ...
            IF (ISPRIME(P)) THEN	!And if it is a prime,
              IF (NH.GE.MANY) STOP "Too many sequences!"	!Add a sequence.
              NH = NH + 1			!Count in a survivor.
              HORDEN(NH) = P			!The numerical value.
              HORDED(1:L,NH) = HORDED(1:L,I)	!The digits.
              HORDED(L + 1,NH) = D		!Plus the added high-order digit.
            END IF			!So much for persistent primality.
          END DO		!On to the next lead digit.
        END DO	!On to the next starter.

        N = NH - LH		!The number of entries added to the horde.
        IF (N.GT.0) THEN	!Were there any?
          DO I = 1,MIN(LH,N)		!Yes. Overwrite the starters.
            HORDEN(I) = HORDEN(NH)		!From the tail end of the horde.
            HORDED(1:L + 1,I) = HORDED(1:L + 1,NH)	!Digit sequences as well.
            NH = NH - 1				!One snipped off.
          END DO			!Thus fill the gap at the start.
          NH = N			!The new horde count.
          LH = NH			!All are starters for the next level.
          GO TO 20			!See how it goes.
        END IF			!So much for further progress.
        GO TO 30		!But if none, done.
   29   WRITE (MSG,28) B,L,NH,DB,P	!Curses. Offer some details.
   28   FORMAT (I4,I7,I6,28X,"Integer overflow!",2I12)
        CYCLE			!Or, GO TO the end of the loop.

   30   I = MAXLOC(HORDEN(1:NH),DIM = 1)	!Finger the mostest number.
        WRITE (MSG,31) B,L,NH,HORDEN(I),HORDED(L:1:-1,I)	!Results!
   31   FORMAT (I4,I7,I6,I11," = "666(I0:"."))	!See Format 3.

      END DO		!On to the next base.
      END	!Simple enough.
