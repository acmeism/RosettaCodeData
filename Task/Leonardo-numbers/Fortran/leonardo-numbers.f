      SUBROUTINE LEONARDO(LAST,L0,L1,AF)	!Show the first LAST values of the sequence.
       INTEGER LAST	!Limit to show.
       INTEGER L0,L1	!Starting values.
       INTEGER AF	!The "Add factor" to deviate from Fibonacci numbers.
       OPTIONAL AF	!Indicate that this parameter may be omitted.
       INTEGER EMBOLISM	!The bloat to employ.
       INTEGER N,LN,LNL1,LNL2	!Assistants to the calculation.
        IF (PRESENT(AF)) THEN	!Perhaps the last parameter has not been given.
          EMBOLISM = AF			!It has. Take its value.
         ELSE			!But if not,
          EMBOLISM = 1			!This is the specified default.
        END IF			!Perhaps there should be some report on this?
        WRITE (6,1) LAST,L0,L1,EMBOLISM	!Announce.
    1   FORMAT ("The first ",I0,	!The I0 format code avoids excessive spacing.
     1   " numbers in the Leonardo sequence defined by L(0) = ",I0,
     2   " and L(1) = ",I0," with L(n) = L(n - 1) + L(n - 2) + ",I0)
        IF (LAST .GE. 1) WRITE (6,2) L0	!In principle, LAST may be small.
        IF (LAST .GE. 2) WRITE (6,2) L1	!!So, suspicion rules.
    2   FORMAT (I0,", ",$)	!Obviously, the $ sez "don't finish the line".
        LNL1 = L0	!Syncopation for the sequence's initial values.
        LN = L1		!Since the parameters ought not be damaged.
        DO N = 3,LAST	!Step away.
          LNL2 = LNL1		!Advance the two state variables one step.
          LNL1 = LN		!Ready to make a step forward.
          LN = LNL1 + LNL2 + EMBOLISM	!Thus.
          WRITE (6,2) LN	!Reveal the value. Overflow is distant...
        END DO		!On to the next step.
        WRITE (6,*)	!Finish the line.
      END SUBROUTINE LEONARDO	!Only speedy for the sequential production of values.

      PROGRAM POKE

      CALL LEONARDO(25,1,1,1)	!The first 25 Leonardo numbers.
      CALL LEONARDO(25,0,1,0)	!Deviates to give the Fibonacci sequence.
      END
