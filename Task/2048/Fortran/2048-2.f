      SUBROUTINE SHOW(NR,NC,BOARD)	!Mess about.
       INTEGER NR,NC		!Number of rows and columns.
       INTEGER BOARD(NR,NC)	!The board. Actual storage is transposed!
       INTEGER R,C 		!Steppers.
       INTEGER L,L1		!Fingers.
       INTEGER W		!A width.
       PARAMETER (W = 6)	!Six will suffice for 2048, even 524288.
       CHARACTER*(NC*(W + 1) + 1) ALINE
       CHARACTER*1 TL,TR,BL,BR	!Corner characters: top left, etc. Code page 850, and 437?
       CHARACTER*1 LR,RL,TD,BU	!Side joining: Left rightwards, right leftwards, top downwards, bottom upwards.
       CHARACTER*1 VL,HL,XX	!Vertical and horizontal lines, line crossing.
       PARAMETER (TL=CHAR(218),TR=CHAR(191),BL=CHAR(192),BR=CHAR(217))	!Works for the "code page" 437, and 850.
       PARAMETER (LR=CHAR(195),RL=CHAR(180),TD=CHAR(194),BU=CHAR(193))	!Try the DOS command CHCP to see which is in use.
       PARAMETER (VL=CHAR(179),HL=CHAR(196),XX=CHAR(197))		!Attempts to change the code page no longer work...
       INTEGER MSG		!I/O unit number.
       COMMON/IODEV/ MSG	!I talk to the trees...
        WRITE (MSG,1) TL,((HL,L = 1,W),TD,C = 1,NC - 1),(HL,L = 1,W),TR	!Write the top edge, with downwards ticks.
    1   FORMAT (666A1)		!Surely long enough.
        DO R = 1,NR		!Chug down the rows.
          WRITE (MSG,1) VL,((" ",L=1,W),VL,C = 1,NC - 1),(" ",L=1,W),VL	!Space vertically to make the tile look less rectangular.
          WRITE (ALINE,3) (VL,BOARD(R,C),C = 1,NC),VL	!The columns of the row. Usage is BOARD(row,col) despite storage adjacency.
    3     FORMAT (<NC>(A1,I<W>),A1)	!Fixed sizes might suffice.
          DO C = 1,NC			!Now inspect each cell along the line.
            L1  = 1 + (C - 1)*(W + 1) + 1	!Locate the first interior character.
            IF (BOARD(R,C).LE.0) THEN		!Should this one be blank?
              ALINE(L1 + W - 1:L1 + W - 1) = " "	!Yes. Scrub the lone zero at the end of the span.
             ELSE				!Non blank, but, aligned right.
              L = L1					!So, look for the first digit.
              DO WHILE(ALINE(L:L).EQ." ")		!There is surely one digit to be found.
                L = L + 1					!Not yet. Advance.
              END DO					!End with L fingering the first digit.
              IF (L.GT.L1) ALINE(L1 + (L - L1 + 1)/2:L1 + W - 1) =	!Halve (approx.) the spare space at the start.
     &                     ALINE(L:L1 + W - 1)		!The first digit to the last digit.
            END IF				!So much for that line segment.
          END DO			!On to the next column.
          WRITE (MSG,"(A)") ALINE	!Roll the fancy line, all in one go.
          WRITE (MSG,1) VL,((" ",L=1,W),VL,C = 1,NC - 1),(" ",L=1,W),VL	!More vertical space.
          IF (R.LT.NR) WRITE (MSG,1) LR,((HL,L = 1,W),XX,C = 1,NC - 1),	!Write an internal horizontal seam.
     &                                   (HL,L = 1,W),RL		!Starting and ending with a horizontal tick.
        END DO			!On to the next row.
        WRITE (MSG,1) BL,((HL,L = 1,W),BU,C = 1,NC - 1),(HL,L = 1,W),BR	!Write the bottom edge, witrh upwards ticks.
      END SUBROUTINE SHOW	!That was nice.

      PROGRAM PUZZLE	!Some severe array juggling may indeed cause puzzlement.
      INTEGER NR,NC,N			!Describes the shape of the board.
      PARAMETER (NR = 4, NC = 4, N = NR*NC)	!Determines the shape of the board.
      INTEGER BOARD(NR,NC)		!Thus transpose furrytran's column-major usage. Beware!!!
      INTEGER BORED(N)			!This allows for consecutive comparisons.
      EQUIVALENCE (BOARD,BORED)		!Because the arrays are in the same place.
      INTEGER BIJ,PB,CB			!Juggles with the values of some  squares.
      INTEGER STARTVALUE,STARTTILES,TARGET	!Document the starting value.
      PARAMETER (TARGET = 2048,STARTVALUE = 2,STARTTILES = 2)	!Why not start with one?
      INTEGER SCORE			!Count them all.
      INTEGER I,IT,TRY			!Odds and ends.
      INTEGER LIST(N)			!A list.
      CHARACTER*1 WAYS(4),WAYC(4)	!In two dimensions, there are four possible ways to move.
      CHARACTER*4 WAYI			!There is no equivalent of INDEX for searching arrays.
      EQUIVALENCE (WAYS,WAYI)		!But this enables two interpretations of the same storage.
      PARAMETER (WAYC = (/"R","U","L","D"/))	!These are the names for the available directions.
      INTEGER W,M,RC,CR,CIJ(2),PIJ(2),WAY(4,2),YAW(4,2)	!Directions in array index terms.
      INTEGER RC1(4),RCN(4),RCI(4), CR1(4),CRN(4),CRI(4)	!Loop control for the directions..
      PARAMETER (RC1 = (/ 1, 1,NR,NC/), CR1 = (/ 1,NR,NC, 1/))	!Start values of the first and second loops.
      PARAMETER (RCN = (/NR,NC, 1, 1/), CRN = (/NC, 1, 1,NR/))	!End values.
      PARAMETER (RCI = (/+1,+1,-1,-1/), CRI = (/+1,-1,-1,+1/))	!Incrementing or decrementing accordingly.
      PARAMETER (WAY = (/ 1, 0, 1, 0,            0, 1, 0, 1/))	!The first loop is either the row, or the column.
      PARAMETER (YAW = (/ 0, 1, 0, 1,            1, 0, 1, 0/))	!The second loop is the other way around.
      REAL VALUE			!Humph. Yet another interface to a "random" number generator.
      CHARACTER*1 C		!A monocharacter response is anticipated.
      INTEGER MSG,KBD		!I/O unit numbers.
      COMMON/IODEV/ MSG,KBD	!Pass the word.

      KBD = 5	!Standard input. (Keyboard -> Display screen)
      MSG = 6	!Standard output. (Display screen)
      WRITE (MSG,1) TARGET,NR,NC,STARTVALUE	!Announce.
    1 FORMAT ("To play '",I0,"' with ",I0," rows and ",I0," columns.",/,
     1"On each move, choose a direction (Up, Down, Left, Right)",/
     2 "by typing the single letter U, D, L, R, or, a space to quit."/
     3 "All squares will be pushed as far as possible that way.",/
     4 "Those meeting with the same number will form one square",/
     5 "with the sum of the numbers, and one becomes blank.",/
     6 "After each move, a random blank square becomes ",I0,/)
      WRITE (MSG,2)	!Now for some annoyance.
    2 FORMAT ("An integer to start the 'random' number generator: ",$)	!Not starting a new line.
      READ (KBD,*) TRY	!Could use a time-of-day in microseconds, or similar.
      CALL SEED(TRY)	!But this enables reproducibility. And cheating.

Concoct a board layout.
   10 BOARD = 0			!Clear for action.
      DO I = 1,STARTTILES	!Place the initial tiles, with their starting values.
   11   CALL RANDOM(VALUE)		!0 <= VALUE < 1.
        IT = VALUE*N + 1		!1 <= IT <= N. Don't round up!
        IF (BORED(IT).NE.0) GO TO 11	!Oops! Flounder towards another tile.
        BORED(IT) = STARTVALUE		!The beginning.
      END DO			!On to the next.
      SCORE = STARTVALUE*STARTTILES	!Save some mental arithmetic.
      TRY = 0		!No moves made yet.

Consider possible moves. Think in (x,y) but convert those thimks to (row,column). Eurghf.
   20 TRY = TRY + 1		!Here we go again.
      CALL SHOW(NR,NC,BOARD)	!The current state.
      WAYS = ""			!No moveable directions are known.
      DO 21 W = 1,4		!One way or another, consider each possible direction.
        DO RC = RC1(W),RCN(W),RCI(W)	!W = 1 = +x: consider each successive row.
          CIJ = RC*WAY(W,1:2) + CR1(W)*YAW(W,1:2)	!Finger the first position.
          DO CR = CR1(W) + CRI(W),CRN(W),CRI(W)		!W = 1; along the columns of the row.
            PIJ = CIJ					!Retain the previous position.
            CIJ = RC*WAY(W,1:2) + CR*YAW(W,1:2)		!Convert (RC,CR) to either (RC,CR) or (CR,RC).
            BIJ = BOARD(CIJ(1),CIJ(2))			!Grab the current position's board state.
            IF ((BOARD(PIJ(1),PIJ(2)).GT.0   .AND. BIJ.EQ.0)		!A non-empty tile to move to an empty one?
     1      .OR.(BOARD(PIJ(1),PIJ(2)).EQ.BIJ .AND. BIJ.GT.0)) THEN	!Or, there is a pair, BOARD(CIJ) = BOARD(PIJ),
              WAYS(W) = WAYC(W)					!Then this direction is available.
              GO TO 21						!No need to seek further opportunities for its use.
            END IF					!So much for the current position.
          END DO				!Advance the scan along direction W.
        END DO				!Advance to the next (row or column) at right angles to W.
   21 CONTINUE			!Try another way.

Cast forth an invitation, and obtain a choice.
   30 WRITE (MSG,31) TRY,SCORE,WAYS	!Summary.
   31 FORMAT ("Move",I4,", score ",I0,". Moves ",4A1,$)	!The $, of course, says "don't end the line".
      IF (ALL(WAYS.EQ." ")) GO TO 600	!A gridlock?
      WRITE (MSG,32)			!Nope. Invite a selection.
   32 FORMAT (" ... Your move: ",$)	!Awaits input, with a new line after pressing "enter".
      IF (COUNT(WAYS.NE." ").EQ.1) THEN	!Or, perhaps it is a choice you can't refuse.
        W = MAXLOC(ABS(ICHAR(WAYS) - ICHAR(" ")),DIM = 1)	!One element's value differes from " "...
        WRITE (MSG,33) WAYS(W)			!Sieze control!
   33   FORMAT (A1," is the only possibility!")	!Just don't ask for input.
       ELSE				!But often, the human can decide.
        READ (KBD,"(A)") C			!Just one character. The first one typed.
        IF (C.LE." ") STOP "Oh well."		!Bored, already?
        I = INDEX("ruld",C)			!A lowercase letter may be presented.
        IF (I.GT.0) C = "RULD"(I:I)		!So, convert to uppercase, if worthy.
        W = INDEX(WAYI,C)			!What is it? There is no search of elements of the array WAYS.
        IF (W.LE.0) THEN			!Perhaps it is blocked.
          WRITE (MSG,34) C				!Alas.
   34     FORMAT ("Not a possible move! ",A)		!Just so.
          GO TO 30					!Try again.
        END IF					!So much for suspicion.
      END IF				!A move has been chosen.

Complete the selected move. Carefully avoid enabling cascades, so 1122 is pulled right to ..24, not .222 then ..42.
   40 M = MOD(W + 1,4) + 1		!W is the direction of movement, its inverse, M, faces arrivals.
      DO RC = RC1(M),RCN(M),RCI(M)	!Loop through the (rows/columns) at right angles to the selected anti-way.
        PIJ = RC*WAY(M,1:2) + CR1(M)*YAW(M,1:2)	!Finger the first square, which may be empty.
        PB = BOARD(PIJ(1),PIJ(2))		!Load it into my two-element buffer: PB and CB.
        IF (PB.NE.0) BOARD(PIJ(1),PIJ(2)) = 0	!It may be returned to the board somewhere else.
        DO CR = CR1(M) + CRI(M),CRN(M),CRI(M)	!Step along the (column/row) of the selected anti-direction.
          CIJ = RC*WAY(M,1:2) + CR*YAW(M,1:2)		!Convert (RC,CR) to either CIJ = (RC,CR) or CIJ = (CR,RC).
          CB = BOARD(CIJ(1),CIJ(2))			!Inspect this square.
          IF (CB.EQ.0) CYCLE				!From nothing comes nothing.
          BOARD(CIJ(1),CIJ(2)) = 0			!The board's value now lives precariously in CB.
          IF (PB.EQ.0) THEN				!A waiting hole? (And, CB is not empty)
            PB = CB						!Yes. Fill it. More may follow, after spaces.
          ELSE						!Otherwise, two non-zero values are in hand.
            IF (PB.EQ.CB) THEN					!If they match,
              PB = PB + CB						!Combine the new with the old.
              CB = 0							!The new one is gone.
            END IF						!So much for matches.
            BOARD(PIJ(1),PIJ(2)) = PB				!Roll the trailing value.
            PIJ = PIJ + CRI(M)*YAW(M,1:2)			!Advance the finger.
            PB = CB						!Shuffle along one.
          END IF					!So much for that square.
        END DO					!On to the next one along.
        IF (PB.GT.0) BOARD(PIJ(1),PIJ(2)) = PB	!A tail end value?
      END DO				!On to the next set.

Choose a random blank square.
   50 IT = 0		!None have been located. (There is surely one, as a move was possible)
      DO I = 1,N	!Step through all the possible squares.
        IF (BORED(I).LE.0) THEN	!Empty?
          IT = IT + 1			!Yes. Augment my list.
          LIST(IT) = I			!Recording available squares.
        END IF			!So much for that square.
      END DO		!On to the next.
      IF (IT.GT.1) THEN	!If a choice s available,
        CALL RANDOM(VALUE)	!Concoct another: 0 <= VALUE < 1.
        IT = VALUE*IT + 1	!And thus with integer truncation, choose an empty square.
      END IF		!So much for choices.
      BORED(LIST(IT)) = STARTVALUE	!Fill the square.
      SCORE = SCORE + STARTVALUE	!Might as well keep count.
Check for success.
   60 IF (ALL(BORED.LT.TARGET)) GO TO 20!Hi ho.
      WRITE (MSG,61)			!A success message.
   61 FORMAT (I0," has been reached!")	!No fancy colours nor flashing lights, nor even bells.
      GO TO 20				!Carry on, anyway.

Curses!
  600 WRITE (MSG,601)		!Alas.
  601 FORMAT ("None! Oh dear.")	!Nothing more can be done.
      END	!That was fun.
