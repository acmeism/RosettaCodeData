      SUBROUTINE SWAP(I,J)	!Alas, furrytran does not provide this.
       INTEGER I,J,T		!So, we're stuck with supplying the obvious.
        T = I			!And, only for one type at a go.
        I = J			!One could define a MODULE containing a collection
        J = T			!And thence a "generic" routine,
      END SUBROUTINE SWAP	!But this will do for now.

      SUBROUTINE SHOW(NR,NC,BOARD)	!The layout won't work for NC > 99...
       INTEGER NR,NC		!Number of rows and columns.
       INTEGER BOARD(NC,NR)	!The board is stored transposed!
       INTEGER I		!A stepper.
       COMMON/IODEV/ MSG	!I talk to the trees...
        WRITE (MSG,1) (I,I = 1,NC)	!Prepare a heading.
    1   FORMAT ("Row|",9("__",I1,:),90("_",I2,:))	!This should suffice.
        DO I = 1,NR		!Chug down the rows.
          WRITE (MSG,2) I,BOARD(1:NC,I)	!The columns of the row. Usage is BOARD(column,row).
    2     FORMAT (I3,"|",99I3)	!Could use parameters, but enough.
        END DO			!On to the next row.
      END SUBROUTINE SHOW	!That was nice.

      PROGRAM PUZZLE
      INTEGER LOCN(2),NR,NC,N	!Describes the shape of the board.
      INTEGER LOCZ(2),ZC,ZR	!Fingers the location of the "blank" square.
      INTEGER LOCI(2),IC,IR	!Fingers a location.
Can't EQUIVALENCE (LOCN(1),NC),(LOCN(2),NR)	!This usage and a PARAMETER statement is too scary.
      EQUIVALENCE (LOCZ(1),ZC),(LOCZ(2),ZR)	!Annotate my (column,row) usage.
      EQUIVALENCE (LOCI(1),IC),(LOCI(2),IR)	!Rather than the displayed (row,column) style.
      PARAMETER (NR = 4, NC = 4, N = NR*NC)	!Determine the shape of the board.
      INTEGER BOARD(NC,NR)		!Thus transpose furrytran's column-major usage. Beware!!!
      INTEGER BORED(N)			!This allows for consecutive comparisons.
      EQUIVALENCE (BOARD,BORED)		!Because the arrays are in the same place.
      INTEGER WAYS			!Now define adjacency.
      PARAMETER (WAYS = 4)		!Just orthogonal neghbours.
      INTEGER WAY(2,WAYS)		!Now list the allowed adjacencies.
      PARAMETER (WAY = (/1,0, 0,1, -1,0, 0,-1/))	!W(1,1), W(2,1), W(1,2), W(2,2), W(1,3), ...
      INTEGER M,MOVE(WAYS),LOCM(2,WAYS)	!Move possibilities.
      INTEGER SPACE			!Document the empty square's code number.
      PARAMETER (SPACE = 0)		!Zero will do.
      INTEGER I,IT,PARITY,TRY		!Odds and ends.
      REAL VALUE			!Humph. Yet another interface to a "random" number generator.
      COMMON/IODEV/ MSG,KBD	!Pass the word.

      KBD = 5	!Standard input. (Keyboard -> Display screen)
      MSG = 6	!Standard output. (Display screen)
      WRITE (MSG,1) NR,NC	!Announce.
    1 FORMAT ("To play 'slide-square' with ",I0," rows and ",
     1 I0," columns.",/,"The game is to slide a square into the space",/
     2 "(thus leaving a space behind) until you attain"/
     3 "the nice orderly layout as follows:",/)
Concoct a board layout.
   10 FOR ALL (I = 1:N - 1) BORED(I) = I	!Prepare the board. Definitely unique values.
      BORED(N) = SPACE	        !The empty square is not at the start! Oh well.
      CALL SHOW(NR,NC,BOARD)	!Reveal the nice layout.
   11 DO I = 1,N - 1		!Now shuffle the squares a bit.
        CALL RANDOM(VALUE)		!0 <= VALUE < 1.
        IT = VALUE*(N - 1) + 1		!1 <= IT < N. Don't round up!
        IF (I.NE.IT) CALL SWAP(BORED(I),BORED(IT))	!Whee!
      END DO			!On to the next victim, leaving the last cell alone.
Calculate the parity, knowing the space is at the end. The target state has even parity, with zero inversions.
      PARITY = 0	!There are two classes of arrangements, that can't mix.
      DO I = 1,N - 2	!Skipping the blank cell still at BORED(N).
        PARITY = PARITY + COUNT(BORED(I) > BORED(I + 1:N - 1))	!For each square,
      END DO		!Count the inversions following.
      IF (MOD(PARITY,2).NE.0) GO TO 11	!No transition can change the parity, so, try for another arrangement.
Choose a new position for the space. Using approved moves will not change the parity.
      CALL RANDOM(VALUE)		!0 <= VALUE < 1.
      ZC = VALUE*(NC - 2) + 1		!1 <= ZC < NC: Choose a random column other than the last.
      BOARD(ZC + 1:NC,NR) = BOARD(ZC:NC - 1,NR)	!Shift the end of the last row back one place.
      BOARD(ZC,NR) = SPACE			!Put the space in the hole.
      CALL RANDOM(VALUE)			!So the parity doesn't change.
      ZR = VALUE*(NR - 2) + 1		!1 <= ZR < NR: Choose a random row, other than the last.
      BOARD(ZC,ZR + 1:NR) = BOARD(ZC,ZR:NR - 1)	!Shift the end of column ZC up one.
      BOARD(ZC,ZR) = SPACE			!Revive the space again.
Cast forth the starting position.
      WRITE (MSG,12)		!Announce the result.
   12 FORMAT (/,"But, your board looks like this...")	!Alas. Almost certainly not in order.
      CALL SHOW(NR,NC,BOARD)	!Just so.
      TRY = 0		!No moves made yet.

Consider possible moves.
   20 TRY = TRY + 1	!Here we go again.
      M = 0		!No moveable pieces are known.
      DO I = 1,WAYS	!So scan the possible ways away from LOCZ.
        LOCI = LOCZ + WAY(1:2,I)	!Finger an adjacent location, via the adjacency offsets in array WAY.
        IF (ALL(LOCI > 0) .AND. ALL(LOCI <= (/NC,NR/))) THEN	!Within bounds?
          M = M + 1			!Yes. We have a candidate.
          MOVE(M) = BOARD(IC,IR)	!Record the piece's name.
          LOCM(:,M) = LOCI		!And, remember where it is...
        END IF			!So much for that location.
      END DO		!Try another offset.
   21 WRITE (MSG,22,ADVANCE="no") MOVE(1:M)	!Two-stage output.
   22 FORMAT ("Moveable pieces: ",<WAYS>(I0:","))	!Since M is not necessarily WAYS, a trailing $ may not be reached..
      WRITE (MSG,23)		!Now for the question. Always at least two moveable squares.
   23 FORMAT(". Choose one: ",$)	!Continue the line, presuming screen and keyboard->screen.
      READ (KBD,*) IT		!Now request the answer. Rather doggedly: blank lines won't do.
      DO I = M,1,-1		!There are at least two possible moves.
        IF (MOVE(I) .EQ. IT) EXIT	!Perhaps this piece was selected.
      END DO			!The INDEX function is alas, only for CHARACTER variables. Grr.
      IF (I .LE. 0) THEN	!I'm suspicious.
        WRITE (MSG,*) "Huh? That is not a moveable piece!"	!Justified!
        IF (IT.GT.0) GO TO 21		!Try again.
        STOP "Oh well."			!Or quit, on negative vibrations.
      END IF			!So much for selecting a piece.
Complete the selected move.
   30 BOARD(ZC,ZR) = IT		!Place the named piece where the space was.
      LOCZ = LOCM(:,I)		!The space is now where that piece came from.
      BOARD(ZC,ZR) = SPACE		!And now holds a space.
c      write (6,*)
c     1 "disorder=",COUNT(BORED(1:N - 2) + 1 .NE. BORED(2:N - 1))
      IF (TRY.LE.6) WRITE (MSG,31)	!Set off with a nice heading.
   31 FORMAT (/"The new layout...")	!Just for clarity.
      CALL SHOW(NR,NC,BOARD)		!Perhaps it will be good.
Check for success.
      IF (BORED(N).NE.SPACE) GO TO 20	!Is the space at the end?
      IF (ANY(BORED(1:N - 2) + 1 .NE. BORED(2:N - 1))) GO TO 20	!Are we there yet?
      WRITE (MSG,*) TRY,"Steps to success!"	!Yes!
      END	!That was fun.
