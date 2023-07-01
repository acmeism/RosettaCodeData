      PROGRAM U		!Reads a specification of a Turing machine, and executes it.
Careful! Reserves a symbol #0 to represent blank tape as a blank.
      INTEGER MANY,FIRST,LAST	!Some sizes must be decided upon.
      PARAMETER (MANY = 66, FIRST = 1, LAST = 666)	!These should do.
      INTEGER HERE(MANY)
      CHARACTER*1	MARK(MANY)	!The transition table.
      INTEGER*1		MOVE(MANY)	!Three related arrays.
      CHARACTER*1	NEXT(MANY)	!All with the same indexing.
      CHARACTER*1	TAPE(FIRST:LAST)!Notionally, no final bound, in both directions - a potential infinity..
      INTEGER 		STATE		!Execution starts with state 1.
      INTEGER		HEAD		!And the tape read/write head at position 1.
      INTEGER STEP			!And we might as well keep count.
      INTEGER OFFSET			!An affine shift.
      INTEGER NSTATE			!Counts can be helpful.
      INTEGER NSYMBOL			!The count of recognised symbols.
      INTEGER S,S1			!Symbol numbers.
      CHARACTER*1 RS,WS			!Input scanning: read symbol, write symbol.
      CHARACTER*1 SYMBOL(0:MANY)	!I reserve SYMBOL(0).
      CHARACTER*(MANY) SYMBOLS		!Up to 255, for single character variables.
      EQUIVALENCE (SYMBOL(1),SYMBOLS)	!Individually or collectively.
      INTEGER I,J,K,L,IT	!Assistants.
      INTEGER LONG		!Now for some text scanning.
      PARAMETER (LONG = 80)	!This should suffice.
      CHARACTER*(LONG) ALINE	!A scratchpad.
      REAL T0,T1		!Some CPU time attempts.
      INTEGER KBD,MSG,INF	!Some I/O unit numbers.

      KBD = 5	!Standard input.
      MSG = 6	!Standard output
      INF = 10	!Suitable for a disc file.
      OPEN (INF,FILE = "TestAdd1.dat",ACTION="READ")	!Go for one.
      READ (INF,1) ALINE	!The first line is to be a heding.
    1 FORMAT (A)		!Just plain text.
      WRITE (MSG,2) ALINE	!Reveal it.
    2 FORMAT ("Turing machine simulation for... ",A)	!Announce the plan.
      READ (INF,*) SYMBOLS	!Allows a quoted string.
      NSYMBOL = LEN_TRIM(SYMBOLS)	!How many symbols? (Trailing spaces will be lost)
      WRITE (MSG,3) NSYMBOL,SYMBOLS(1:NSYMBOL)	!They will be symbol number 0, 1, ..., NSYMBOL - 1.
    3 FORMAT (I0," symbols: >",A,"<")	!And this is their count.
      IF (NSYMBOL.LE.1) STOP "Expect at least two symbols!"
      SYMBOL(0) = " "		!My special state meaning "never before seen".
      NSYMBOL = NSYMBOL + 1	!So, one more is in actual use.
      NSTATE = 0		!As for states, I haven't seen any.
      MOVE = -66		!This should cause trouble and be noticed!
      MARK = CHAR(0)		!In case a state is omitted.
      NEXT = CHAR(0)		!Like, mention state seven, but omit mention of state six.
      HERE = 0			!Clear the counts.

Collate the transition table.
   10 READ (INF,*) STATE	!Read this once, rather than for every transition.
      IF (STATE.LE.0) GO TO 20	!Ah, finished.
      WRITE (MSG,11) STATE	!But they can come in any order.
      NSTATE = MAX(STATE,NSTATE)!And I'd like to know how many.
   11 FORMAT ("Entry: Read Write Move Next. For state ",I0)	!Prepare a nice heading.
      IF (STATE.LE.0) STOP "Positive STATE numbers only!"	!It may not be followed.
      IF (STATE*NSYMBOL.GT.MANY) STOP"My transition table is too small!"	!But the value of STATE is shown.
      DO S = 0,NSYMBOL - 1	!Initialise the transitions for STATE.
        IT = STATE*NSYMBOL - S		!Finger the one for S.
        MARK(IT) = CHAR(S)		!No change to what's under the head.
        NEXT(IT) = CHAR(0)		!And this stops the run.
      END DO			!Just in case a symbol's number is omitted.
      DO S = 1,NSYMBOL - 1	!A transition for every symbol must be given or the read process will get out of step.
        READ(INF,*) RS,WS,K,L		!Read symbol, write symbol, move, next.
        I = INDEX(SYMBOLS(1:NSYMBOL - 1),RS)	!Convert the character to a symbol number.
        J = INDEX(SYMBOLS(1:NSYMBOL - 1),WS)	!To enable decorative glyphs, not just digits.
        IF (I.LE.0) STOP "Unrecognised read symbol!"	!This really should be more helpful.
        IF (J.LE.0) STOP "Unrecognised write symbol!"	!By reading into ALINE and showing it, etc.
        IT = STATE*NSYMBOL - I		!Locate the entry for the state x symbol pair.
        MARK(IT) = CHAR(J)		!The value to be written.
        MOVE(IT) = K			!The movement of the tape head.
        NEXT(IT) = CHAR(L)		!The next state.
        IF (I.EQ.1) S1 = IT		!This transition will be duplicated. SYMBOL(1) is for blank tape.
      END DO			!On to the next symbol's transition.
Copy SYMBOL(1)'s transition to the transition for the secret extra, SYMBOL(0).
      IT = STATE*NSYMBOL	!Finger the interpolated entry for SYMBOL(0).
      MARK(IT) = MARK(S1)	!Thus will SYMBOL(0), shown as a space, be overwritten.
      MOVE(IT) = MOVE(S1)	!And SYMBOL(0) treated
      NEXT(IT) = NEXT(S1)	!Exactly as if it were SYMBOL(1).
Cast forth the transition table for STATE, not mentioning SYMBOL(0) - but see label 911.
      DO S = 1,NSYMBOL - 1	!Roll them out in the order as given in SYMBOL.
        IT = STATE*NSYMBOL - S		!But the entry number will be odd.
        WRITE (ALINE,12) IT,SYMBOL(S),		!The character's code value is irrelevant.
     1   SYMBOL(ICHAR(MARK(IT))),MOVE(IT),ICHAR(NEXT(IT))	!Append the details just read.
   12   FORMAT (I5,":",2X,'"',A1,'"',3X'"',A1,'"',I5,I5,I13)	!Revealing the symbols, not their number.
        IF (MOVE(IT).GT.0) ALINE(21:21) = "+"	!I want a leading + for positive, not zero.
        WRITE (MSG,1) ALINE(1:27)	!The SP format code is unhelpful for zero.
      END DO			!Hopefully, I'm still in sync with the input.
      GO TO 10		!Perhaps another state follows.

Chew tape. The initial state is some sequence of symbols, starting at TAPE(1).
   20 TAPE = CHAR(0)		!Set every cell to zero. Not blank.
      OFFSET = 12		!Affine shift. The numerical value of HEAD is not seen.
      READ (INF,1) ALINE	!Get text, for the tape's initial state.
      L = LEN_TRIM(ALINE)	!Last non-blank. Flexible format this isn't.
      DO I = 1,L		!Step through cells 1 to L.
        TAPE(I + OFFSET - 1) = CHAR(INDEX(SYMBOLS,ALINE(I:I)))	!Character code to symbol number.
      END DO			!Rather than reading as I1.
      CLOSE (INF)		!Finished with the input, and not much checking either.
      WRITE (MSG,*)		!Take a breath.
Cast forth a heading..
      WRITE (MSG,99)		!Announce.
   99 FORMAT ("Starts with State 1 and the tape head at 1.")	!Positioned for OFFSET = 12.
      ALINE = " Step: Head State|Tape..."	!Prepare a heading for the trace.
      L = 18 + OFFSET*2		!Locate the start position.
      ALINE(L - 1:L + 1) = "<H>"!No underlining, no overprinting, no colour (neither background nor foreground). Sigh.
      WRITE (MSG,1) ALINE	!Take that!
      CALL CPU_TIME(T0)		!Start the clock.
      HEAD = OFFSET		!This is counted as position one.
      STATE = 1			!The initial state.
      STEP = 0			!No steps yet.

Chase through the transitions. Could check that HEAD is within bounds FIRST:LAST.
  100 IF (STEP.GE.200) GO TO 200	!Perhaps an extended campaign.
      STEP = STEP + 1			!Otherwise, here we go.
      DO I = 1,LONG/2		!Scan TAPE(1:LONG/2).
        IT = 2*I - 1			!Allowing two positions each.
        ALINE(IT:IT) = " "		!So a leading space.
        ALINE(IT + 1:IT + 1) = SYMBOL(ICHAR(TAPE(I)))	!And the indicated symbol.
      END DO				!On to the enxt.
      I = HEAD*2		!The head's location in the display span.
      IF (I.GT.1 .AND. I.LT.LONG) THEN	!Within range?
        IF (ALINE(I:I).EQ.SYMBOL(0)) ALINE(I:I) = SYMBOL(1)	!Yes. Am I looking at a new cell?
        ALINE(I - 1:I - 1) = "<"		!Bracket the head's cell.
        ALINE(I + 1:I + 1) = ">"		!In ALINE.
      END IF				!So much for showing the head's position.
      WRITE (MSG,102) STEP,HEAD - OFFSET + 1,STATE,ALINE	!Splot the state.
  102 FORMAT (I5,":",I5,I6,"|",A)	!Aligns with FORMAT 99.
      I = STATE*NSYMBOL - ICHAR(TAPE(HEAD))	!For this STATE and the symbol under TAPE(HEAD)
      HERE(I) = HERE(I) + 1			!Count my visits.
      TAPE(HEAD) = MARK(I)			!Place the new symbol.
      HEAD = HEAD + MOVE(I)			!Move the head.
      IF (HEAD.LT.FIRST .OR. HEAD.GT.LAST) GO TO 110	!Check the bounds.
      STATE = ICHAR(NEXT(I))			!The new state.
      IF (STATE.GT.0) GO TO 100			!Go to it.
Cease.
      I = HEAD*2			!Locate HEAD within ALINE.
      IF (I.GT.1 .AND. I.LT.LONG) ALINE(I:I) = SYMBOL(ICHAR(TAPE(HEAD)))	!The only change.
      WRITE (MSG,103) HEAD - OFFSET + 1,STATE,ALINE	!Show.
  103 FORMAT ("HALT!",I6,I6,"|",A)	!But, no step count to start with. See FORMAT 102.
      GO TO 900			!Done.
Can't continue! Insufficient tape, alas.
  110 WRITE (MSG,*) "Insufficient tape!"	!Oh dear.
      GO TO 900					!Give in.

Change into high gear: no trace and no test thereof neither.
  200 STEP = STEP + 1		!So, advance.
      IF (MOD(STEP,10000000).EQ.0) WRITE (MSG,201) STEP	!Ah, still some timewasting.
  201 FORMAT ("Step ",I0)				!No screen action is rather discouraging.
      I = STATE*NSYMBOL - ICHAR(TAPE(HEAD))	!Index the transition.
      HERE(I) = HERE(I) + 1			!Another visit.
      TAPE(HEAD) = MARK(I)			!Do it. Possibly not changing the symbol.
      HEAD = HEAD + MOVE(I)			!Possibly not moving the head.
      IF (HEAD.LT.FIRST .OR. HEAD.GT.LAST) GO TO 110	!But checking the bounds just in case.
      STATE = ICHAR(NEXT(I))			!Hopefully, something has changed!
      IF (STATE.GT.0) GO TO 200			!Otherwise, we might loop forever...

Closedown.
  900 CALL CPU_TIME(T1)		!Where did it all go?
      WRITE (MSG,901) STEP,STATE	!Announce the ending.
  901 FORMAT ("After step ",I0,", state = ",I0,".")	!Thus.
      DO I = FIRST,LAST		!Scan the tape.
        IF (ICHAR(TAPE(I)).NE.0) EXIT	!This is the whole point of SYMBOL(0).
      END DO				!So that the bounds
      DO J = LAST,FIRST,-1		!Of tape access
        IF (ICHAR(TAPE(J)).NE.0) EXIT	!(and placement of the initial state)
      END DO				!Can be found without tedious ongoing MIN and MAX.
      WRITE (MSG,902) HEAD - OFFSET + 1,	!Tediously,
     1                I - OFFSET + 1,		!Reverse the offset
     2                J - OFFSET + 1		!So as to seem that HEAD = 1, to start with.
  902 FORMAT ("The head is at position ",I0,	!Now announce the results.
     1 " and wandered over ",I0," to ",I0)	!This will affect the dimension chosen for TAPE.
      T1 = T1 - T0				!Some time may have been accurately measured.
      IF (T1.GT.0.1) WRITE (MSG,903) T1		!And this may be sort of correct.
  903 FORMAT ("CPU time",F9.3)			!Though distinct from elapsed time.
Curious about the usage of the transition table?
  910 WRITE (MSG,911)		!Possibly not,
  911 FORMAT (/,35X,"Usage.")	!But here it comes.
      DO STATE = 1,NSTATE	!For every state
        WRITE (MSG,11) STATE		!Name the state, as before.
        DO S = 0,NSYMBOL - 1		!But this time, roll every symbol.
          IT = STATE*NSYMBOL - S		!Including my "secret" symbol.
          WRITE (ALINE,12) IT,SYMBOL(S),		!The same sequence,
     1   SYMBOL(ICHAR(MARK(IT))),MOVE(IT),ICHAR(NEXT(IT)),HERE(IT)	!But with an addendum here.
        IF (MOVE(IT).GT.0) ALINE(21:21) = "+"	!SIGN(i,i) gives -1, 0, +1 but -60 for -60.
        WRITE (MSG,1) ALINE(1:40)		!When what I want is -1. SIGN(1,i) doesn't give zero.
        END DO				!On to the next symbol in the order as supplied.
      END DO			!And the next state, in numbers order.
      END	!That was fun.
