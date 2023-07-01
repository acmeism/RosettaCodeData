      MODULE COMPILER	!At least of arithmetic expressions.
       INTEGER KBD,MSG		!I/O units.

       INTEGER ENUFF		!How long s a piece of string?
       PARAMETER (ENUFF = 66)	!This long.
       CHARACTER*(ENUFF) RP	!Holds the Reverse Polish Notation.
       INTEGER LR		!And this is its length.

       INTEGER		OPSYMBOLS		!Recognised operator symbols.
       PARAMETER	(OPSYMBOLS = 11)	!There are also some associates.
       TYPE SYMB		!To recognise symbols and carry associated information.
        CHARACTER*1	IS		!Its text. Careful with the trailing space and comparisons.
        INTEGER*1	PRECEDENCE	!Controls the order of evaluation.
        CHARACTER*48	USAGE		!Description.
       END TYPE SYMB		!The cross-linkage of precedences is tricky.
       TYPE(SYMB) SYMBOL(0:OPSYMBOLS)	!Righto, I'll have some.
       PARAMETER (SYMBOL =(/	!Note that "*" is not to be seen as a match to "**".
     o  SYMB(" ", 0,"Not recognised as an operator's symbol."),
     1  SYMB(" ", 1,"separates symbols and aids legibility."),
     2  SYMB(")", 4,"opened with ( to bracket a sub-expression."),
     3  SYMB("]", 4,"opened with [ to bracket a sub-expression."),
     4  SYMB("}", 4,"opened with { to bracket a sub-expression."),
     5  SYMB("+",11,"addition, and unary + to no effect."),
     6  SYMB("-",11,"subtraction, and unary - for neg. numbers."),
     7  SYMB("*",12,"multiplication."),
     8  SYMB("×",12,"multiplication, if you can find this."),
     9  SYMB("/",12,"division."),
     o  SYMB("÷",12,"division for those with a fancy keyboard."),
C                13 is used so that stacked ^ will have lower priority than incoming ^, thus delivering right-to-left evaluation.
     1  SYMB("^",14,"raise to power. Not recognised is **.")/))
       CHARACTER*3	BRAOPEN,BRACLOSE	!Three types are allowed.
       PARAMETER	(BRAOPEN = "([{", BRACLOSE = ")]}")	!These.
       INTEGER		BRALEVEL		!In and out, in and out. That's the game.
       INTEGER		PRBRA,PRPOW		!Special double values.
       PARAMETER (PRBRA = SYMBOL( 3).PRECEDENCE)	!Bracketing
       PARAMETER (PRPOW = SYMBOL(11).PRECEDENCE)	!And powers refer leftwards.

       CHARACTER*10 DIGIT		!Numberish is a bit more complex.
       PARAMETER (DIGIT = "0123456789")	!But this will do for integers.

       INTEGER STACKLIMIT		!How high is a stack?
       PARAMETER (STACKLIMIT = 66)	!This should suffice.
       TYPE DEFERRED			!I need a siding for lower-precedence operations.
        CHARACTER*1	OPC		!The operation code.
        INTEGER*1	PRECEDENCE	!Its precedence in the siding may differ.
       END TYPE DEFERRED		!Anyway, that's enough.
       TYPE(DEFERRED) OPSTACK(0:STACKLIMIT)	!One siding, please.
       INTEGER OSP			!The operation stack pointer.

       INTEGER INCOMING,TOKENTYPE,NOTHING,ANUMBER,OPENBRA,HUH		!Some mnemonics.
       PARAMETER (NOTHING = 0, ANUMBER = -1, OPENBRA = -2, HUH = -3)	!The ordering is not arbitrary.
       CONTAINS	!Now to mess about.
        SUBROUTINE EMIT(STUFF)	!The objective is to produce some RPN text.
         CHARACTER*(*) STUFF	!The term of the moment.
         INTEGER L		!A length.
          WRITE (MSG,1) STUFF	!Announce.
    1     FORMAT ("Emit  ",A)	!Whatever it is.
          IF (STUFF.EQ."") RETURN	!Ha ha.
          L = LEN(STUFF)	!So, how much is there to append?
          IF (LR + L.GE.ENUFF) STOP "Too much RPN for RP!"	!Perhaps too much.
          IF (LR.GT.0) THEN	!Is there existing stuff?
            LR = LR + 1			!Yes. Advance one,
            RP(LR:LR) = " "		!And place a space.
          END IF		!So much for separators.
          RP(LR + 1:LR + L) = STUFF	!Place the stuff.
          LR = LR + L			!Count it in.
        END SUBROUTINE EMIT	!Simple enough, if a bit finicky.

        SUBROUTINE STACKOP(C,P)	!Push an item into the siding.
         CHARACTER*1 C	!The operation code.
         INTEGER P	!Its precedence.
          OSP = OSP + 1		!Stacking up...
          IF (OSP.GT.STACKLIMIT) STOP "OSP overtopped!"	!Perhaps not.
          OPSTACK(OSP).OPC = C		!Righto,
          OPSTACK(OSP).PRECEDENCE = P	!The deed is simple.
          WRITE (MSG,1) C,OPSTACK(1:OSP)	!Announce.
    1     FORMAT ("Stack ",A1,9X,",OpStk=",33(A1,I2:","))
        END SUBROUTINE STACKOP	!So this is more for mnemonic ease.

        LOGICAL FUNCTION COMPILE(TEXT)	!A compiler confronts a compiler!
         CHARACTER*(*) TEXT	!To be inspected.
         INTEGER L1,L2		!Fingers for the scan.
         CHARACTER*1 C		!Character of the moment.
         INTEGER HAPPY		!Ah, shades of mood.
          LR = 0		!No output yet.
          OSP = 0		!Nothing stacked.
          OPSTACK(0).OPC = ""		!Prepare a bouncer.
          OPSTACK(0).PRECEDENCE = 0	!So that loops won't go past.
          BRALEVEL = 0		!None seen.
          HAPPY = +1		!Nor any problems.
          L2 = 1		!Syncopation: one past the end of the previous token.
Chew into an operand, possibly obstructed by an open bracket.
  100     CALL FORASIGN		!Find something to inspect.
          IF (TOKENTYPE.EQ.NOTHING) THEN	!Run off the end?
            IF (OSP.GT.0) CALL GRUMP("Another operand or one of "	!E.g. "1 +".
     1       //BRAOPEN//" is expected.")				!Give a hint, because stacked stuff awaits.
          ELSE IF (TOKENTYPE.EQ.ANUMBER) THEN	!If a number,
            CALL EMIT(TEXT(L1:L2 - 1))			!Roll all its digits.
          ELSE IF (TOKENTYPE.EQ.OPENBRA) THEN	!Starting a sub-expression?
            CALL STACKOP(C,PRBRA - 1)			!Thus ( has less precedence than ).
            GO TO 100					!And I still want an operand.
C         ELSE IF (TOKENTYPE.EQ.ANAME) THEN	!Name of something?
C           CALL EMIT(TEXT(L1:L2 - 1))			!Roll it.
          ELSE					!No further options.
            CALL GRUMP("Huh? Unexpected "//C)		!Probably something like "1 + +"
          END IF				!Righto, finished with operands.
Chase after an operator, possibly interrupted by a close bracket,.
  200     CALL FORASIGN		!Find something to inspect.
          IF (TOKENTYPE.LT.0) THEN	!But, have I an operand-like token instead?
            CALL GRUMP("Operator expected, not "//C)	!It seems so.
           ELSE			!Normally, an operator is to hand. Possibly a NOTHING, though.
            WRITE (MSG,201) C,INCOMING,OPSTACK(1:OSP)	!Document it.
  201       FORMAT ("Oprn=>",A1,"< Prec=",I2,		!Try to align with other output.
     1       ",OpStk=",33(A1,I2:","))			!So as not to clutter the display.
            DO WHILE(OPSTACK(OSP).PRECEDENCE .GE. INCOMING)	!Shunt higher-precedence stuff out.
              IF (OPSTACK(OSP).PRECEDENCE .EQ. PRBRA - 1)		!Only opening brackets have this  precedence.
     1         CALL GRUMP("Unbalanced "//OPSTACK(OSP).OPC)		!And they vanish only when meeting their closing bracket.
              CALL EMIT(OPSTACK(OSP).OPC)				!Otherwise we have an operator.
              OSP = OSP - 1						!It has gone forth.
            END DO						!On to the next.
            IF (TOKENTYPE.GT.NOTHING) THEN	!Now, only lower-precedence items are still in the stack.
              IF (INCOMING.EQ.PRBRA) THEN		!And this is a special arrival.
                CALL BALANCEBRA(C)			!It should match an earlier entry.
                BRALEVEL = BRALEVEL - 1			!Count it out.
                GO TO 200				!And I still haven't got an operator.
               ELSE				!All others are normal operators.
                IF (C.EQ."^") INCOMING = PRPOW - 1	!Special trick to cause leftwards association of x^2^3.
                CALL STACKOP(C,INCOMING)		!Shunt aside, to await the next arrival.
              END IF			!So much for that operator.
            END IF			!Providing it was not just an end-of-input flusher.
          END IF		!And not a misplaced operand.
Carry on?
          IF (HAPPY .GT. 0) GO TO 100 	!No problems, and not a nothing from the end of the text.
Completed.
          COMPILE = HAPPY.GE.0	!One hopes so.
         CONTAINS	!Now for some assistants.
          SUBROUTINE GRUMP(GROWL)	!There might be a problem.
           CHARACTER*(*) GROWL	!The fault.
            WRITE (MSG,1) GROWL	!Say it.
            IF (L1.GT. 1)        WRITE (MSG,1) "Tasty:",TEXT( 1:L1 - 1)	!Now explain the context.
            IF (L2.GT.L1)        WRITE (MSG,1) "Nasty:",TEXT(L1:L2 - 1)	!This is the token when trouble was found.
            IF (L2.LE.LEN(TEXT)) WRITE (MSG,1) "Misty:",TEXT(L2:)	!And this remains to be seen.
    1       FORMAT (4X,A,1X,A)	!A simple layout works nicely for reasonable-length texts.
            HAPPY = -1	.	!Just so.
          END SUBROUTINE GRUMP	!Enuogh said.

          SUBROUTINE BALANCEBRA(B)	!Perhaps a happy meeting.
           CHARACTER*1 B	!The closer.
           CHARACTER*1 O	!The putative opener.
           INTEGER IT,L		!Fingers.
           CHARACTER*88 GROWL	!A scratchpad.
            O = OPSTACK(OSP).OPC	!This should match B.
            WRITE (MSG,1) O,B		!Perhaps.
    1       FORMAT ("Match ",2A)	!Show what I've got, anyway.
            IT = INDEX(BRAOPEN,O)	!So, what sort did I save?
            IF (IT .EQ. INDEX(BRACLOSE,B)) THEN	!A friend?
              OSP = OSP - 1			!Yes. They vanish together.
             ELSE	!Otherwise, something is out of place.
              GROWL = "Unbalanced {[(...)]} bracketing! The closing "	!Alas.
     1         //B//" is unmatched."				!So, a mess.
              IF (IT.GT.0) GROWL(62:) =  "A "//BRACLOSE(IT:IT)	!Perhaps there had been no opening bracket.
     1         //" would be better."		!But if there had, this would be its friend.
              CALL GRUMP(GROWL)		!Take that!
            END IF			!So much for discrepancies.
          END SUBROUTINE BALANCEBRA	!But, hopefully, amity prevails.

          SUBROUTINE FORASIGN	!See what comes next.
           INTEGER I	!A stepper.
            L1 = L2		!Pick up where the previous scan left off.
   10       IF (L1.GT.LEN(TEXT)) THEN	!Are we off the end yet?
              C = ""			!Yes. Scrub the marker.
              L2 = L1			!TEXT(L1:L2 - 1) will be null.
              TOKENTYPE = NOTHING	!But this is to be checked first.
              INCOMING = SYMBOL(1).PRECEDENCE	!For flushing sidetracked operators.
              HAPPY = 0			!Fading away.
             ELSE	!Otherwise, there is grist.
Check for spaces and move past them.
              C = TEXT(L1:L1)	!Grab the first character of the prospective token.
              IF (C.LE." ") THEN	!Boring?
                L1 = L1 + 1		!Yes. Step past it.
                GO TO 10		!And look afresh.
              END IF		!Otherwise, L1 now fingers the start.
Caught something to inspect.
              L2 = L1 + 1		!This is one beyond. Just for digit strings.
              IF (INDEX(DIGIT,C).GT.0) THEN	!So, has one started?
                TOKENTYPE = ANUMBER 		!Yep.
   20           IF (L2.LE.LEN(TEXT)) THEN	!Probe ahead.
                  IF (INDEX(DIGIT,TEXT(L2:L2)).GT.0) THEN	!Another digit?
                    L2 = L2 + 1			!Yes. Leaving L1 fingering its start,
                    GO TO 20			!Chase its end.
                  END IF			!So much for another digit.
                END IF			!And checking against the end.
C             ELSE IF (INDEX(LETTERS,C).GT.0) THEN	!Some sort of name?
C               advance L2 while in NAMEISH.
              ELSE IF (INDEX(BRAOPEN,C).GT.0) THEN	!An open bracket?
                TOKENTYPE = OPENBRA			!Yep.
              ELSE			!Otherwise, anything else.
                DO I = OPSYMBOLS,1,-1	!Scan backwards, to find ** before *, if present.
                  IF (SYMBOL(I).IS .EQ. C) EXIT	!Found?
                END DO			!On to the next. A linear search will do.
                IF (I.LE.0) THEN	!Is it identified?
                  TOKENTYPE = HUH		!No.
                  INCOMING = SYMBOL(0).PRECEDENCE	!And this might provoke a flush.
                 ELSE			!If it is identified,
                  TOKENTYPE = I			!Then this is a positive number.
                  INCOMING = SYMBOL(I).PRECEDENCE	!And this is of interest.
                END IF			!Righto, anything has been identified, possibly as HUH.
              END IF		!So much for classification.
            END IF	!If there is something to see.
            WRITE (MSG,30) C,INCOMING,TOKENTYPE		!Announce.
   30       FORMAT ("Next=>",A1,"< Prec=",I2,",Ttype=",I2)	!C might be blank.
          END SUBROUTINE FORASIGN	!I call for a sign, and I see what?
        END FUNCTION COMPILE	!That's the main activity.
      END MODULE COMPILER	!So, enough of this.

      PROGRAM POKE
      USE COMPILER
      CHARACTER*66 TEXT
      LOGICAL HIC
      MSG = 6
      KBD = 5
      WRITE (MSG,1)
    1 FORMAT ("Produce RPN from infix...",/)

   10 WRITE (MSG,11)
   11 FORMAT("Infix: ",$)
      READ(KBD,12) TEXT
   12 FORMAT (A)
      IF (TEXT.EQ."") STOP "Enough."
      HIC = COMPILE(TEXT)
      WRITE (MSG,13) HIC,RP(1:LR)
   13 FORMAT (L6," RPN: >",A,"<")
      GO TO 10
      END
