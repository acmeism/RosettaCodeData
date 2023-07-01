      PROGRAM INHERIT	!Last digit persistence in successive prime numbers.
      USE PRIMEBAG	!Inherit this also.
      INTEGER MBASE,P0,NHIC	!Problem bounds.
      PARAMETER (MBASE = 13, P0 = 2, NHIC = 100000000)	!This should do.
      INTEGER N(0:MBASE - 1,0:MBASE - 1,2:MBASE)	!The counts. A triangular shape would be better.
      INTEGER I,B,D1,D2	!Assistants.
      INTEGER P,PP	!Prime, and Previous Prime.

      MSG = 6		!Standard output.
      WRITE (MSG,1) MBASE,P0,NHIC	!Announce intent.
    1 FORMAT ("Working in base 2 to ",I0," count the transitions "
     1 "from the low-order digit of one prime number ",/,
     2 "to the low-order digit of its successor. Starting with ",I0,
     3 " and making ",I0," advances.")
      IF (.NOT.GRASPPRIMEBAG(66)) STOP "Gan't grab my file!"	!Attempt in hope.

Chug through the primes.
   10 N = 0	!Clear all my counts!
      P = P0	!Start with the starting prime.
      DO I = 1,NHIC	!Make the specified number of advances.
        PP = P			!Thus, remember the previous prime.
        P = NEXTPRIME(P)	!And obtain the current prime.
        DO B = 2,MBASE		!For these, step through the relevant bases.
          D1 = MOD(PP,B)		!Last digit of the previous prime.
          D2 = MOD(P,B)			!In the base of the moment.
          N(D1,D2,B) = N(D1,D2,B) + 1	!Whee!
        END DO			!On to the next base.
      END DO		!And the next advance.
      WRITE (MSG,11) P	!Might as well announce where we got to.
   11 FORMAT ("Ending with ",I0)	!Hopefully, no overflow.

Cast forth the results.
   20 DO B = 2,MBASE	!Present results for each base.
        WRITE (MSG,21) B		!Announce it.
   21   FORMAT (/,"For base ",I0)	!Set off with a blank line.
        WRITE (MSG,22) (D1, D1 = 0,B - 1)	!The heading.
   22   FORMAT (" Last digit ending  ",I2,66I9)	!Alignment to match FORMAT 23.
        DO D2 = 0,B - 1		!For a given base, these are the possible ending digits of the successor.
          IF (ALL(N(0:B - 1,D2,B).EQ.0)) CYCLE	!No progenitor advanced to this successor digit?
          WRITE (MSG,23) D2,N(0:B - 1,D2,B)	!Otherwise, show the counts for the progenitor's digits.
   23     FORMAT (" next prime ends",I3,":",I2,66I9)	!Ah, layout.
        END DO			!On to the next successor digit.
      END DO		!On to the next base.
      END	!That was easy.
