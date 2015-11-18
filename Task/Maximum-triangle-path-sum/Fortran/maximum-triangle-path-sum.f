      MODULE PYRAMIDS	!Produces a pyramid of numbers in 1-D array.
       INTEGER MANY		!The usual storage issues.
       PARAMETER (MANY = 666)	!This should suffice.
       INTEGER BRICK(MANY),IN,LAYERS	!Defines a pyramid.
       CONTAINS
        SUBROUTINE IMHOTEP(PLAN)!The architect.
Counting is from the apex down, the Erich von Daniken construction.
         CHARACTER*(*) PLAN	!The instruction file.
         INTEGER I,IT		!Steppers.
         CHARACTER*666 ALINE	!A scratchpad for input.
          IN = 0		!No bricks.
          LAYERS = 0		!In no courses.
          WRITE (6,*) "Reading from ",PLAN	!Here we go.
          OPEN(10,FILE=PLAN,FORM="FORMATTED",ACTION="READ",ERR=6)	!I hope.
          GO TO 10		!Why can't OPEN be a function?@*&%#^%!
    6     STOP "Can't grab the file!"
Chew into the plan.
   10     READ (10,11,END = 20) ALINE	!Get the whole line in one piece.
   11     FORMAT (A)			!As plain text.
          IF (ALINE .EQ. "") GO TO 10	!Ignoring any blank lines.
          IF (ALINE(1:1).EQ."%") GO TO 10	!A comment opportunity.
          LAYERS = LAYERS + 1		!Righto, this should be the next layer.
          IF (IN + LAYERS.GT.MANY) STOP "Too many bricks!"	!Perhaps not.
          READ (ALINE,*,END = 15,ERR = 15) BRICK(IN + 1:IN + LAYERS)	!Free format.
          IN = IN + LAYERS		!Insufficient numbers will provoke trouble.
          GO TO 10			!Extra numbers/stuff will be ignored.
Caught a crab? A bad number, or too few numbers on a line? No read-next-record antics, thanks.
   15     WRITE (6,16) LAYERS,ALINE	!Just complain.
   16     FORMAT ("Bad layer ",I0,": ",A)
Completed the plan.
   20     WRITE (6,21) IN,LAYERS	!Announce some details.
   21     FORMAT (I0," bricks in ",I0," layers.")
          CLOSE(10)			!Finished with input.
Cast forth the numbers in a nice pyramid.
   30     IT = 0		!For traversing the pyramid.
          DO I = 1,LAYERS	!Each course has one more number than the one before.
            WRITE (6,31) BRICK(IT + 1:IT + I)	!Sweep along the layer.
   31       FORMAT (<LAYERS*2 - 2*I>X,666I4)	!Leading spaces may be zero in number.
            IT = IT + I				!Thus finger the last of a layer.
          END DO		!On to the start of the next layer.
        END SUBROUTINE IMHOTEP	!The pyramid's plan is ready.

        SUBROUTINE TRAVERSE	!Clamber around the pyramid. Thoroughly.
C   The idea is that a pyramid of numbers is provided, and then, starting at the peak,
c work down to the base summing the numbers at each step to find the maximum value path.
c The constraint is that from a particular brick, only the two numbers below left and below right
c may be reached in stepping to that lower layer.
c   Since that is a 0/1 choice, recorded in MOVE, a base-two scan searches the possibilities.
         INTEGER MOVE(LAYERS)		!Choices are made at the various positions.
         INTEGER STEP(LAYERS),WALK(LAYERS)	!Thus determining the path.
         INTEGER I,L,IT		!Steppers.
         INTEGER PS,WS		!Scores.
          WRITE (6,1) LAYERS		!Announce the intention.
    1     FORMAT (//,"Find the highest score path across a pyramid of ",
     1     I0," layers."/)	!I'm not worrying over singular/plural.
          MOVE = 0	!All 0/1 values to zero.
          MOVE(1) = 1	!Except the first.
          STEP(1) = 1	!Every path starts here, without option.
          WS = -666	!The best score so far.
Commence a multi-level loop, using the values of MOVE as the digits, one digit per level.
   10       IT = 1		!All paths start with the first step.
            PS = BRICK(1)	!The starting score,.
c            write (6,8) "Move",MOVE,WS
            DO L = 2,LAYERS	!Deal with the subsequent layers.
              IT = IT + L - 1 + MOVE(L)	!Choose a brick.
              STEP(L) = IT		!Remember this step.
              PS = PS + BRICK(IT)	!Count its score.
c              WRITE (6,6) L,IT,BRICK(IT),PS
    6         FORMAT ("Layer ",I0,",Brick(",I0,")=",I0,",Sum=",I0)
            END DO		!Thus is the path determined.
            IF (PS .GT. WS) THEN	!An improvement?
              IF (WS.GT.0) WRITE (6,7) WS,PS	!Yes! Announce.
    7         FORMAT ("Improved path score: ",I0," to ",I0)
              WRITE (6,8) "Moves",MOVE		!Show the choices at each layer..
              WRITE (6,8) "Steps",STEP		!That resulted in this path.
              WRITE (6,8) "Score",BRICK(STEP)	!Whose steps were scored thus.
    8         FORMAT (A8,666I4)			!This should suffice.
              WS = PS				!Record the new best value.
              WALK = STEP			!And the path thereby.
            END IF			!So much for an improvement.
            DO L = LAYERS,1,-1		!Now add one to the number in MOVE.
              IF (MOVE(L).EQ.0) THEN	!By finding the lowest order zero.
                MOVE(L) = 1		!Making it one,
                MOVE(L + 1:LAYERS) = 0	!And setting still lower orders back to zero.
                GO TO 10		!And if we did, there's more to do!
              END IF		!But if that bit wasn't zero,
            END DO		!Perhaps the next one up will be.
          WRITE (6,*) WS," is the highest score."	!So much for that.
        END SUBROUTINE TRAVERSE	!All paths considered...

        SUBROUTINE REFINE	!Ascertain the highest score without searching.
         INTEGER BEST(LAYERS)	!A scratchpad.
         INTEGER I,L		!Steppers.
          L = LAYERS*(LAYERS - 1)/2 + 1	!Finger the first brick of the lowest layer.
          BEST = BRICK(L:L + LAYERS - 1)!Syncopation. Copy the lowest layer.
          DO L = LAYERS - 1,1,-1	!Work towards the peak.
            FORALL (I = 1:L) BEST(I) = BRICK(L*(L - 1)/2 + I)	!Add to each brick's value
     1                               + MAXVAL(BEST(I:I + 1))	!The better of its two possibles.
          END DO			!On to the next layer.
          WRITE (6,*) BEST(1)," is the highest score. By some path."
        END SUBROUTINE REFINE	!Who knows how we get there.
      END MODULE PYRAMIDS

      PROGRAM TRICKLE
      USE PYRAMIDS
c      CALL IMHOTEP("Sakkara.txt")
      CALL IMHOTEP("Cheops.txt")
      CALL TRAVERSE			!Do this the definite way.
      CALL REFINE			!Only the result by more cunning.
      END
