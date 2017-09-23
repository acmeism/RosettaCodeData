      MODULE LAIROTCAF	!Calculates "left factorials".
       CONTAINS		!The usual suspects.
        INTEGER*8 FUNCTION FACT(N)	!Factorial, the ordinary.
         INTEGER N	!The number won't ever get far.
         INTEGER I	!The stepper.
          FACT = 1	!Here we go.
          DO I = 2,N		!Does nothing for N < 2.
            FACT = FACT*I		!Perhaps this overflows.
            IF (FACT.LE.0) STOP "Factorial: Overflow!"	!Two's complement arithmetic.
          END DO		!No longer any IF OVERFLOW tests.
        END FUNCTION FACT	!Simple enough.

        INTEGER*8 FUNCTION LFACT(N)	!Left factorial.
         INTEGER N	!This number won't get far either.
         INTEGER K	!A stepper.
          LFACT = 0	!Here we go.
          DO K = 0,N - 1	!Apply the definition.
            LFACT = LFACT + FACT(K)	!Perhaps this overflows.
            IF (LFACT.LE.0) STOP "Lfact: Overflow!"	!Unreliable test.
          END DO		!On to the next step in the summation.
        END FUNCTION LFACT	!No attempts at saving effort.
      END MODULE LAIROTCAF	!Just the minimum.

      PROGRAM POKE
      USE LAIROTCAF
      INTEGER I

      WRITE (6,*) "Left factorials, from 0 to 10..."
      DO I = 0,10
        WRITE (6,1) I,LFACT(I)
    1   FORMAT ("!",I0,T6,I0)
      END DO

      WRITE (6,*) "Left factorials, from 20 to 110 by tens..."
      DO I = 20,110,10
        WRITE (6,1) I,LFACT(I)
      END DO
      END
