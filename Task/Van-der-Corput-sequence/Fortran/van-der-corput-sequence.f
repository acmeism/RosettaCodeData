      FUNCTION VDC(N,BASE)	!Calculates a Van der Corput number...
Converts 1234 in decimal to 4321 in V, and P = 10000.
       INTEGER N	!For this integer,
       INTEGER BASE	!In this base.
       INTEGER I	!A copy of N that can be damaged.
       INTEGER P	!Successive powers of BASE.
       INTEGER V	!Accumulates digits.
        P = 1		! = BASE**0
        V = 0		!Start with no digits, as if N = 0.
        I = N		!Here we go.
        DO WHILE (I .NE. 0)	!While something remains,
          V = V*BASE + MOD(I,BASE)	!Extract its low-order digit.
          I = I/BASE			!Reduce it by a power.
          P = P*BASE			!And track the power.
        END DO			!Thus extract the digits in reverse order: right-to-left.
        VDC = V/FLOAT(P)	!The power is one above the highest digit.
      END FUNCTION VDC	!Numerology is weird.

      PROGRAM POKE
      INTEGER FIRST,LAST	!Might as well document some constants.
      PARAMETER (FIRST = 0,LAST = 9)	!Thus, the first ten values.
      INTEGER I,BASE		!Steppers.
      REAL VDC			!Stop the compiler moaning about undeclared items.

      WRITE (6,1) FIRST,LAST,(I, I = FIRST,LAST)	!Announce.
    1 FORMAT ("Calculates values ",I0," to ",I0," of the ",
     1 "Van der Corput sequence, in various bases."/
     2 "Base",666I9)

      DO BASE = 2,13	!A selection of bases.
        WRITE (6,2) BASE,(VDC(I,BASE), I = FIRST,LAST)	!Show the specified span.
    2   FORMAT (I4,666F9.6)	!Aligns with FORMAT 1.
      END DO		!On to the next base.

      END
