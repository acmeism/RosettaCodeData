      PROGRAM LANGTONSANT
C   Langton's ant wanders across an initially all-white board, stepping one cell at a go.
C   If the current cell is white, it becomes black and the ant turns right.
C   If the current cell is black, it becomes white and the ant turns left.
C   The ant advances one cell in its latest direction, and reconsiders.
      INTEGER ENUFF
      PARAMETER (ENUFF = 100)		!Said to be so.
      CHARACTER*1 CELL(ENUFF,ENUFF)	!The work area.
      COMPLEX WAY,PLACE		!A direction and a position.
      INTEGER X,Y,XN,Y1		!Integer versions.
      INTEGER STEP		!A counter.
      CELL = ""				!Clear for action.
      PLACE = CMPLX(ENUFF/2,ENUFF/2)	!Start at the middle.
      WAY = (1,0)		!Initial direction is +x.
Commence wandering.
      DO STEP = 1,20000	!Enough to be going on with.
        X = REAL(PLACE)		!Change languages.
        Y = AIMAG(PLACE)	!Could mess about with EQUIVALENCE...
        IF (X.LE.0 .OR. X.GT.ENUFF	!Are we still
     1  .OR.Y.LE.0 .OR. Y.GT.ENUFF) THEN!Within bounds?
          WRITE (6,1) STEP - 1,X,Y		!No! Offer details.
    1     FORMAT ("Step ",I0," to (",I0,",",I0,") is out of bounds!")
          EXIT					!And wander no further.
        END IF				!But, if we're within bounds,
        IF (CELL(X,Y).NE."#") THEN	!Consider our position.
          CELL(X,Y) = "#"		!A blank cell becomes black. Ish.
          WAY = WAY*(0,-1)		!Turn right.
         ELSE				!Otherwise,
          CELL(X,Y) = "+"		!A black cell becomes white. Ish.
          WAY = WAY*(0,+1)		!Turn left.
        END IF			!So much for changing direction.
        PLACE = PLACE + WAY	!Advance one step.
      END DO		!On to the next step.
Consider the bounds...
      DO Y1 = 1,ENUFF		!Work up from the bottom.
        IF (ANY(CELL(:,Y1).NE." ")) EXIT	!The last line with a splot.
      END DO			!Subsequent lines would be blank.
      DO XN = ENUFF,1,-1	!Work back from the right hand side.
        IF (ANY(CELL(XN,:).NE." ")) EXIT	!The last column with a splot.
      END DO			!Subsequent columns would be blank.
Cast forth the splotches.
      DO Y = ENUFF,Y1,-1	!The topmost y-coordinate first!
        WRITE (6,"(666A1)") CELL(1:XN,Y)	!Roll a line's worth.
      END DO			!On to the next line.
Completed.
      END
