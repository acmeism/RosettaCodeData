        SUBROUTINE BRAINFORT(PROG,N,INF,OUF,F)	!Stand strong!
Converts the Brain*uck in PROG into the equivalent furrytran source...
         CHARACTER*(*) PROG	!The Brain*uck source.
         INTEGER N		!A size for the STORE.
         INTEGER INF,OUF,F	!I/O unit numbers.
         INTEGER L		!A stepper.
         INTEGER LABEL,NLABEL,INDEEP,STACK(66)	!Labels cause difficulty.
         CHARACTER*1 C		!The operation of the moment.
         CHARACTER*36 SOURCE	!A scratchpad.
          WRITE (F,1) PROG,N	!The programme heading.
    1     FORMAT (6X,"PROGRAM BRAINFORT",/,	!Name it.
     1     "Code: ",A,/				!Show the provenance.
     2     6X,"CHARACTER*1 STORE(",I0,")",/	!Declare the working memory.
     3     6X,"INTEGER D",/			!The finger to the cell of the moment.
     4     6X,"STORE = CHAR(0)",/		!Clear to nulls, not spaces.
     5     6X,"D = 1",/)			!Start the data finger at the first cell.
          NLABEL = 0		!No labels seen.
          INDEEP = 0		!So, the stack is empty.
          LABEL = 0		!And the current label is absent.
          L = 1			!Start at the start.
Chug through the PROG.
          DO WHILE(L.LE.LEN(PROG))	!And step through to the end.
            C = PROG(L:L)		!The code of the moment.
            SELECT CASE(C)		!What to do?
             CASE(">")			!Move the data finger forwards one.
              WRITE (SOURCE,2) "D = D + ",RATTLE(">")	!But, catch multiple steps.
             CASE("<")			!Move the data finger back one.
              WRITE (SOURCE,2) "D = D - ",RATTLE("<")	!Rather than a sequence of one steps.
             CASE("+")			!Increment the fingered datum by one.
              WRITE (SOURCE,2) "STORE(D) = CHAR(ICHAR(STORE(D)) + ",	!Catching multiple increments.
     1         RATTLE("+"),")"						!And being careful over the placement of brackets.
             CASE("-")			!Decrement the fingered datum by one.
              WRITE (SOURCE,2) "STORE(D) = CHAR(ICHAR(STORE(D)) - ",	!Catching multiple decrements.
     1         RATTLE("-"),")"						!And closing brackets.
             CASE(".")			!Write a character.
              WRITE (SOURCE,2) "WRITE (",OUF,",'(A1,$)') STORE(D)"	!Using the given output unit.
             CASE(",")			!Read a charactger.
              WRITE (SOURCE,2) "READ (",INF,",'(A1)') STORE(D)"		!And the input unit.
             CASE("[")			!A label!
              NLABEL = NLABEL + 1		!Labels come in pairs due to [...]
              LABEL = 2*NLABEL - 1		!So this belongs to the [.
              INDEEP = INDEEP + 1		!I need to remember when later the ] is encountered.
              STACK(INDEEP) = LABEL + 1		!This will be the other label.
              WRITE (SOURCE,2) "IF (ICHAR(STORE(D)).EQ.0) GO TO ",	!So, go thee, therefore.
     1         STACK(INDEEP)			!Its placement will come, all going well.
             CASE("]")			!The end of a [...] pair.
              LABEL = STACK(INDEEP)		!This was the value of the label to be, now to be placed.
              WRITE (SOURCE,2) "IF (ICHAR(STORE(D)).NE.0) GO TO ",	!The conditional part
     1         LABEL - 1			!The branch back destination is known by construction.
              INDEEP = INDEEP - 1		!And we're out of the [...] sequence's consequences.
             CASE DEFAULT		!All others are ignored.
              SOURCE = "CONTINUE"		!So, just carry on.
            END SELECT			!Enough of all that.
    2       FORMAT (A,I0,A)	!Text, an integer, text.
Cast forth the statement.
            IF (LABEL.LE.0) THEN	!Is a label waiting?
              WRITE (F,3) SOURCE		!No. Just roll the source.
    3         FORMAT (<6 + 2*MIN(12,INDEEP)>X,A)!With indentation.
             ELSE			!But if there is a label,
              WRITE (F,4) LABEL,SOURCE		!Slightly more complicated.
    4         FORMAT (I5,<1 + 2*MIN(12,INDEEP)>X,A)	!I align my labels rightwards...
              LABEL = 0				!It is used.
            END IF			!So much for that statement.
            L = L + 1		!Advance to the next command.
          END DO		!And perhaps we're finished.

Closedown.
          WRITE (F,100)		!No more source.
  100     FORMAT (6X,"END")	!So, this is the end.
         CONTAINS	!A function with odd effects.
          INTEGER FUNCTION RATTLE(C)	!Advances thrugh multiple C, counting them.
           CHARACTER*1 C	!The symbol.
            RATTLE = 1		!We have one to start with.
    1       IF (L.LT.LEN(PROG)) THEN	!Further text to look at?
              IF (PROG(L + 1:L + 1).EQ.C) THEN	!Yes. The same again?
              	L = L + 1		!Yes. Advance the finger to it.
                RATTLE = RATTLE + 1	!Count another.
                GO TO 1			!And try again.
              END IF			!Rather than just one at a time.
            END IF			!Curse the double evaluation of WHILE(L < LEN(PROG) & ...)
          END FUNCTION RATTLE	!Computers excel at counting.
        END SUBROUTINE BRAINFORT!Their only need be direction as to what to count...
      END MODULE BRAIN	!Simple in itself.

      PROGRAM POKE	!A tester.
      USE BRAIN		!In a rather bad way.
      CHARACTER*1 STORE(30000)	!Probably rather more than is needed.
      CHARACTER*(*) HELLOWORLD	!Believe it or not...
      PARAMETER (HELLOWORLD = "++++++++[>++++[>++>+++>+++>+<<<<-]"
     1 //" >+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------"
     2 //".--------.>>+.>++.")
      INTEGER F
      KBD = 5		!Standard input.
      MSG = 6		!Standard output.
      F = 10

      STORE = CHAR(0)	!Scrub.

c      CALL RUN(HELLOWORLD,STORE)	!Have a go.

      OPEN (F,FILE="BrainFort.for",STATUS="REPLACE",ACTION="WRITE")
      CALL BRAINFORT(HELLOWORLD,30000,KBD,MSG,F)
      END	!Enough.
