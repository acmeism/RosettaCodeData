      PROGRAM SUBLEQ0	!Simulates a One-Instruction computer, with Subtract and Branch if <= 0.
      INTEGER LOTS,LOAD		!Document some bounds.
      PARAMETER (LOTS = 36, LOAD = 31)	!Sufficient for the example.
      INTEGER IAR, MEM(0:LOTS)		!The basic storage of a computer. IAR could be in memory too.
      INTEGER ABC(3),A,B,C		!A hardware register. Could use INTEGER*1 for everything...
      EQUIVALENCE (ABC(1),A),(ABC(2),B),(ABC(3),C)	!It has components.
      INTEGER INITIAL(0:LOAD)		!There is no sign of a bootstrap loader sequence!
      DATA INITIAL/15,17,-1,17,-1,-1,16,1,-1,16,3,-1,15,15,0,0,-1,	!These are operations, it so happens.
     1          72,101,108,108,111,44,32,119,111,114,108,100,33,10,0/	!And these happen to be ASCII character code numbers.
Core memory initialisation.
      MEM = -66			!Accessing uninitialised memory is improper. This might cause hiccoughs..
      MEM(0:LOAD) = INITIAL	!No bootstrap!
      IAR = 0			!The Instruction Address Register starts at the start.
Commence execution of the current instruction.
  100 ABC = MEM(IAR:IAR + 2)	!Load the three-word instruction.
      IAR = IAR + 3		!Advance IAR accordingly.
      IF (A .EQ. -1) THEN	!Decode the instruction as per the design.
        WRITE (6,102)			!Supply a prompt, otherwise, obscurity results.
  102   FORMAT (" A number:",$)		!But, that will make a mess of the layout.
        READ (5,*) MEM(B)		!The specified action is to read as a number.
      ELSE IF (B .EQ. -1) THEN	!This is for output.
        WRITE (6,103) CHAR(MEM(A))	!As specified, interpret a number as a character.
  103   FORMAT (A1,$)			!The $, obviously, states: do not end the line and start the next.
      ELSE			!And this is a two-part action.
        MEM(B) = MEM(B) - MEM(A)	!Perform arithmetic.
        IF (MEM(B).LE.0) IAR = C	!And based on the result, maybe a GO TO.
      END IF			!So much for decoding.
      IF (IAR.GE.0) GO TO 100	!Keep at it.
      END	!That was simple.
