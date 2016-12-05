      MODULE BRAIN	!It will suffer.
       INTEGER MSG,KBD
       CONTAINS		!A twisted interpreter.
        SUBROUTINE RUN(PROG,STORE)	!Code and data are separate!
         CHARACTER*(*) PROG	!So, this is the code.
         CHARACTER*(1) STORE(:)	!And this a work area.
         CHARACTER*1 C		!The code of the moment.
         INTEGER I,D		!Fingers to an instruction, and to data.
          D = 1		!First element of the store.
          I = 1		!First element of the prog.

          DO WHILE(I.LE.LEN(PROG))	!Off the end yet?
            C = PROG(I:I)		!Load the opcode fingered by I.
            I = I + 1			!Advance one. The classic.
            SELECT CASE(C)		!Now decode the instruction.
             CASE(">")			!Move the data finger one place right.
              D = D + 1
             CASE("<")			!Move the data finger one place left.
              D = D - 1
             CASE("+")			!Add one to the fingered datum.
              STORE(D) = CHAR(ICHAR(STORE(D)) + 1)
             CASE("-")			!Subtract one.
              STORE(D) = CHAR(ICHAR(STORE(D)) - 1)
             CASE(".")			!Write a character.
              WRITE (MSG,1) STORE(D)
             CASE(",")			!Read a character.
              READ (KBD,1) STORE(D)
             CASE("[")			!Conditionally, surge forward.
              IF (ICHAR(STORE(D)).EQ.0) CALL SEEK(+1)
             CASE("]")			!Conditionally, retreat.
              IF (ICHAR(STORE(D)).NE.0) CALL SEEK(-1)
             CASE DEFAULT		!For all others,
		  			!Do nothing.
            END SELECT			!That was simple.
          END DO		!See what comes next.

    1     FORMAT (A1,$)	!One character, no advance to the next line.
         CONTAINS	!Now for an assistant.
          SUBROUTINE SEEK(WAY)	!Look for the BA that matches the AB.
           INTEGER WAY		!Which direction: ±1.
           CHARACTER*1 AB,BA	!The dancers.
           INTEGER INDEEP	!Nested brackets are allowed.
            INDEEP = 0		!None have been counted.
            I = I - 1		!Back to where C came from PROG.
            AB = PROG(I:I)	!The starter.
            BA = "[ ]"(WAY + 2:WAY + 2)	!The stopper.
    1       IF (I.GT.LEN(PROG)) STOP "Out of code!"	!Perhaps not!
            IF (PROG(I:I).EQ.AB) THEN		!A starter? (Even if backwards)
              INDEEP = INDEEP + 1			!Yep.
            ELSE IF (PROG(I:I).EQ.BA) THEN	!A stopper?
              INDEEP = INDEEP - 1			!Yep.
            END IF				!A case statement requires constants.
            IF (INDEEP.GT.0) THEN	!Are we out of it yet?
              I = I + WAY			!No. Move.
              IF (I.GT.0) GO TO 1		!And try again.
              STOP "Back to 0!"			!Perhaps not.
            END IF			!But if we are out of the nest,
            I = I + 1			!Advance to the following instruction, either WAY.
          END SUBROUTINE SEEK	!Seek, and one shall surely find.
        END SUBROUTINE RUN	!So much for that.
      END MODULE BRAIN	!Simple in itself.

      PROGRAM POKE	!A tester.
      USE BRAIN		!In a rather bad way.
      CHARACTER*1 STORE(30000)	!Probably rather more than is needed.
      CHARACTER*(*) HELLOWORLD	!Believe it or not...
      PARAMETER (HELLOWORLD = "++++++++[>++++[>++>+++>+++>+<<<<-]"
     1 //" >+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------"
     2 //".--------.>>+.>++.")
      KBD = 5		!Standard input.
      MSG = 6		!Standard output.
      STORE = CHAR(0)	!Scrub.

      CALL RUN(HELLOWORLD,STORE)	!Have a go.

      END	!Enough.
