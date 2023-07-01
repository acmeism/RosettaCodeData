      MODULE RIVERRUN   !Schemes for re-flowing wads of text to a specified line length.
       INTEGER BL,BLIMIT,BM !Fingers for the scratchpad.
       PARAMETER (BLIMIT = 222) !This should be enough for normal widths.
       CHARACTER*(BLIMIT) BUMF  !The scratchpad, accumulating text.
       INTEGER OUTBUMF      !Output unit number.
       DATA OUTBUMF/0/      !Thus detect inadequate initialisation.
       PRIVATE BL,BLIMIT,BM !These names are not so unusual
       PRIVATE BUMF,OUTBUMF !That no other routine will use them.
       CONTAINS
       INTEGER FUNCTION LSTNB(TEXT)  !Sigh. Last Not Blank.
Concocted yet again by R.N.McLean (whom God preserve) December MM.
Code checking reveals that the Compaq compiler generates a copy of the string and then finds the length of that when using the latter-day intrinsic LEN_TRIM. Madness!
Can't   DO WHILE (L.GT.0 .AND. TEXT(L:L).LE.' ')    !Control chars. regarded as spaces.
Curse the morons who think it good that the compiler MIGHT evaluate logical expressions fully.
Crude GO TO rather than a DO-loop, because compilers use a loop counter as well as updating the index variable.
Comparison runs of GNASH showed a saving of ~3% in its mass-data reading through the avoidance of DO in LSTNB alone.
Crappy code for character comparison of varying lengths is avoided by using ICHAR which is for single characters only.
Checking the indexing of CHARACTER variables for bounds evoked astounding stupidities, such as calculating the length of TEXT(L:L) by subtracting L from L!
Comparison runs of GNASH showed a saving of ~25-30% in its mass data scanning for this, involving all its two-dozen or so single-character comparisons, not just in LSTNB.
        CHARACTER*(*),INTENT(IN):: TEXT !The bumf. If there must be copy-in, at least there need not be copy back.
        INTEGER L       !The length of the bumf.
         L = LEN(TEXT)      !So, what is it?
    1    IF (L.LE.0) GO TO 2    !Are we there yet?
         IF (ICHAR(TEXT(L:L)).GT.ICHAR(" ")) GO TO 2    !Control chars are regarded as spaces also.
         L = L - 1      !Step back one.
         GO TO 1        !And try again.
    2    LSTNB = L      !The last non-blank, possibly zero.
        RETURN          !Unsafe to use LSTNB as a variable.
       END FUNCTION LSTNB   !Compilers can bungle it.

        SUBROUTINE STARTFLOW(OUT,WIDTH) !Preparation.
         INTEGER OUT    !Output device.
         INTEGER WIDTH  !Width limit.
          OUTBUMF = OUT     !Save these
          BM = WIDTH        !So that they don't have to be specified every time.
          IF (BM.GT.BLIMIT) STOP "Too wide!"    !Alas, can't show the values BLIMIT and WIDTH.
          BL = 0        !No text already waiting in BUMF
        END SUBROUTINE STARTFLOW!Simple enough.

        SUBROUTINE FLOW(TEXT)   !Add to the ongoing BUMF.
         CHARACTER*(*) TEXT !The text to append.
         INTEGER TL     !Its last non-blank.
         INTEGER T1,T2      !Fingers to TEXT.
         INTEGER L      !A length.
          IF (OUTBUMF.LT.0) STOP "Call STARTFLOW first!"    !Paranoia.
          TL = LSTNB(TEXT)  !No trailing spaces, please.
          IF (TL.LE.0) THEN !A blank (or null) line?
            CALL FLUSH      !Thus end the paragraph.
            RETURN      !Perhaps more text will follow, later.
          END IF        !Curse the (possible) full evaluation of .OR. expressions!
          IF (TEXT(1:1).LE." ") CALL FLUSH  !This can't be checked above in case LEN(TEXT) = 0.
Chunks of TEXT are to be appended to BUMF.
          T1 = 1        !Start at the start, blank or not.
   10     IF (BL.GT.0) THEN !If there is text waiting in BUMF,
            BL = BL + 1     !Then this latest text is to be appended
            BUMF(BL:BL) = " "   !After one space.
          END IF        !So much for the join.
Consider the amount of text to be placed, TEXT(T1:TL)
          L = TL - T1 + 1   !Length of text to be placed.
          IF (BM - BL .GE. L) THEN  !Sufficient space available?
            BUMF(BL + 1:BM + L) = TEXT(T1:TL)   !Yes. Copy all the remaining text.
            BL = BL + L             !Advance the finger.
            IF (BL .GE. BM - 1) CALL FLUSH  !If there is no space for an addendum.
            RETURN              !Done.
          END IF        !Otherwise, there is an overhang.
Calculate the available space up to the end of a line. BUMF(BL + 1:BM)
          L = BM - BL       !The number of characters available in BUMF.
          T2 = T1 + L       !Finger the first character beyond the take.
          IF (TEXT(T2:T2) .LE. " ") GO TO 12    !A splitter character? Happy chance!
          T2 = T2 - 1       !Thus the last character of TEXT that could be placed in BUMF.
   11     IF (TEXT(T2:T2) .GT. " ") THEN    !Are we looking at a space yet?
            T2 = T2 - 1             !No. step back one.
            IF (T2 .GT. T1) GO TO 11        !And try again, if possible.
            IF (L .LE. 6) THEN  !No splitter found. For short appendage space,
              CALL FLUSH        !Starting a new line gives more scope.
              GO TO 10          !At the cost of spaces at the end.
            END IF      !But splitting words is unsavoury too.
            T2 = T1 + L - 1     !Alas, no split found.
          END IF        !So the end-of-line will force a split.
          L = T2 - T1 + 1   !The length I settle on.
   12     BUMF(BL + 1:BL + L) = TEXT(T1:T1 + L - 1) !I could add a hyphen at the arbitrary chop...
          BL = BL + L       !The last placed.
          CALL FLUSH        !The line being full.
Consider what the flushed line didn't take. TEXT(T1 + L:TL)
          T1 = T1 + L       !Advance to fresh grist.
   13     IF (T1.GT.TL) RETURN  !Perhaps there is no more. No compound testing, alas.
          IF (TEXT(T1:T1).LE." ") THEN  !Does a space follow a line split?
            T1 = T1 + 1     !Yes. It would appear as a leading space in the output.
            GO TO 13            !But the line split stands in for all that.
          END IF        !So, speed past all such.
          IF (T1.LE.TL) GO TO 10!Does anything remain?
          RETURN        !Nope.
         CONTAINS   !A convenience.
          SUBROUTINE FLUSH  !Save on repetition.
            IF (BL.GT.0) WRITE (OUTBUMF,"(A)") BUMF(1:BL)   !Roll the bumf, if any.
            BL = 0      !And be ready for more.
          END SUBROUTINE FLUSH  !Thus avoid the verbosity of repeated begin ... end blocks.
        END SUBROUTINE FLOW !Invoke with one large blob, or, pieces.
      END MODULE RIVERRUN   !Flush the tail end with a null text.

      PROGRAM TEST
      USE RIVERRUN
      INTEGER MSG,IN
      CHARACTER*222 BUMF
      MSG = 6
      IN = 10
      CALL STARTFLOW(MSG,36)
      CALL FLOW("Fifteen men on a dead man's chest!")
      CALL FLOW(" Yo ho ho and a bottle of rum!")
      CALL FLOW("Drink and the devil have done for the rest!")
      CALL FLOW(" Yo ho ho and a bottle of rum!")
      CALL FLOW("")
      WRITE (MSG,*)
Chew into my source file for a second example.
      OPEN (IN,FILE="TextFlow.for",ACTION = "READ")
    1 READ (IN,2) BUMF
    2 FORMAT (A)
      IF (BUMF(1:1).NE."C") GO TO 1 !No comment block yet.
      CALL STARTFLOW(MSG,66)        !Found it!
    3 CALL FLOW(BUMF)           !Roll its text.
      READ (IN,2) BUMF          !Grab another line.
      IF (BUMF(1:1).EQ."C") GO TO 3 !And if a comment, append.
      CALL FLOW("")
      CLOSE (IN)
      END
