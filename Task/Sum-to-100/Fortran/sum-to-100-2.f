      INTEGER NDIGITS,TARGET	!Document the shape.
      PARAMETER (NDIGITS = 9, TARGET = 100)
      INTEGER*1 OP(NDIGITS)	!A set of operation codes, associated with each digit.
      INTEGER N,D,P		!Number, digit, power.
      CHARACTER*1 OPNAME(-1:+1)	!Encodement of the operations.
      PARAMETER (OPNAME = (/"-"," ","+"/))	!These will look nice.
      CHARACTER*20 TEXT		!A scratchpad for the expression. Single digits only.
      INTEGER I,L,H,ME		!Assistants.
      LOGICAL CURSE		!Needed for a Comb Sort.
      INTEGER LOOP,NHIT		!Some counters.
      INTEGER ENUFF		!Collect the results.
      PARAMETER (ENUFF = 20000)	!Surely big enough...
      INTEGER VALUE(ENUFF)	!A table.
      INTEGER V,VV,PV,VE	!For scanning the table.
      INTEGER MSG		!I/O unit number.

      MSG = 6		!Standard output.
      WRITE(MSG,1) NDIGITS,TARGET	!Announce.
    1 FORMAT ("To find expressions of ",I0," digits in order, "
     1 "interspersed with + or -, adding to ",I0,/)
      NHIT = 0		!No matches to TARGET.
      LOOP = 0		!Because none have been made.
      OP = -1		!Start the expression sequence.

Calculate the value of the expression given by OP(i) i pairs.
  100 LOOP = LOOP + 1		!Here we go again.
      N = 0			!Clear the number.
      D = 0			!No previous digits have been seen.
      P = 1			!The power for the first digit.
      DO I = NDIGITS,1,-1	!Going backwards sees the digits before the sign.
        D = D + I*P			!Assimilate the digit string backwards.
        IF (OP(I).EQ.0) THEN		!A no-operation?
          P = P*10				!Yes. Prepare the power for the next digit leftwards.
         ELSE     			!Otherwise, add or subtract the digit string's value.
          N = N + SIGN(D,OP(I))			!By transferring the sign to D..
          D = 0					!Clear, ready for the next digit string.
          P = 1					!The starting power, again.
        END IF				!So much for that step.
      END DO			!On to the next.
      IF (OP(1).EQ.0) N = N + D	!Provide an implicit add for an unsigned start.
      VALUE(LOOP) = N		!Save the value for later...
      IF (N.EQ.TARGET) THEN	!Well then?
        NHIT = NHIT + 1			!Yay!
        WRITE (TEXT,101) (OPNAME(OP(I)),I, I = 1,NDIGITS)	!Translate the expression.
  101   FORMAT (10(A1,I1))		!Single-character operation codes, single-digit number parts.
        CALL DEBLANK(TEXT,L)		!Squeeze out the no-operations, so numbers are together.
        WRITE (MSG,102) N,TEXT(1:L)	!Result!
  102   FORMAT (I5,": ",A)		!This should do.
      END IF			!So much for that.

Concoct the next expression, working as if with a bignumber in base three, though offset.
  200 P = NDIGITS		!Start with the low-order digit.
  201 OP(P) = OP(P) + 1		!Add one to it.
      IF (OP(P).GT.1) THEN	!Is a carry needed?
        OP(P) = -1			!Yes. Set the digit back to the start.
        P = P - 1			!Go up a power.
        IF (P.GT.0) GO TO 201		!And augment the next digit up.
      END IF			!Once the carry fizzles, the increment is complete.
      IF (OP(1).LE.0) GO TO 100	!A leading + is equivalent to a leading no-op.

Contemplate the collection.
  300 WRITE (6,301) LOOP,NHIT
  301 FORMAT (/,I0," evaluations, ",I0," hit the target.")
Crank up a comb sort.
      H = LOOP - 1		!Last - First, and not +1.
      IF (H.LE.0) STOP "Huh?"	!Ha ha.
  310 H = MAX(1,H*10/13)	!The special feature.
      IF (H.EQ.9 .OR. H.EQ.10) H = 11	!A twiddle.
      CURSE = .FALSE.		!So far, so good.
      DO I = LOOP - H,1,-1	!If H = 1, this is a BubbleSort.
        IF (VALUE(I) .GT. VALUE(I + H)) THEN	!One compare.
          N = VALUE(I);VALUE(I)=VALUE(I+H);VALUE(I+H)=N	!One swap.
          CURSE = .TRUE.			!One curse.
        END IF				!One test.
      END DO			!One loop.
      IF (CURSE .OR. H.GT.1) GO TO 310	!Work remains?
Chase after some results.
      H = 0		!Hunt the first omitted positive number.
      VE = 0		!No equal values have been seen.
      ME = 0		!So, their maximum run length is short.
      PV = VALUE(1)	!Grab the first value,
      DO I = 2,LOOP	!And scan the successors.
        V = VALUE(I)		!The value of the moment.
        IF (V.LE.0) CYCLE	!Only positive numbers are of interest.
        IF (V.GT.PV + 1) THEN	!Is there a gap?
          IF (H.LE.0) H = PV + 1	!Recall the first such.
        END IF			!Perhaps a list of the first dew?
        IF (V.EQ.PV) THEN	!Is it the same as the one before?
          VE = VE + 1			!Yes. Count up the length of the run.
          IF (VE.GT.ME) THEN		!Is this a longer run?
            ME = VE				!Yes. Remember its length.
            VV = V 				!And its value.
          END IF			!So much for runs of equal values.
         ELSE			!But if it is not the same,
          VE = 0			!A fresh count awaits.
        END IF			!So much for comparing one value to its predecessor.
        PV = V			!Be ready for the next time around.
      END DO		!On to the next.

Cast forth the results.
      IF (ME.GT.1) WRITE (MSG,320) VV,ME + 1	!Counting started with the second occurrence.
  320 FORMAT (I0," has the maximum number of attainments:",I0)
      IF (H.GT.0) WRITE (MSG,321) H		!Surely there will be one.
  321 FORMAT ("The lowest positive sum that can't be expressed is ",I0)
      WRITE (MSG,322) VALUE(LOOP - 9:LOOP)	!Surely LOOP > 9.
  322 FORMAT ("The ten highest sums: ",10(I0:","))
      END	!That was fun!
