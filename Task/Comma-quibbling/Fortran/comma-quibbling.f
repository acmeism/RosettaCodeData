      SUBROUTINE QUIBBLE(TEXT,OXFORDIAN)	!Punctuates a list with commas and stuff.
       CHARACTER*(*) TEXT	!The text, delimited by spaces.
       LOGICAL OXFORDIAN	!Just so.
       INTEGER IST(6),LST(6)	!Start and stop positions.
       INTEGER N,L,I		!Counters.
       INTEGER L1,L2		!Fingers for the scan.
       INTEGER MSG		!Output unit.
       COMMON /IODEV/MSG	!Share.
Chop the text into words.
        N = 0		!No words found.
        L = LEN(TEXT)	!Multiple trailing spaces - no worries.
        L2 = 0		!Syncopation: where the previous chomp ended.
   10   L1 = L2		!Thus, where a fresh scan should follow.
   11   L1 = L1 + 1		!Advance one.
        IF (L1.GT.L) GO TO 20		!Finished yet?
        IF (TEXT(L1:L1).LE." ") GO TO 11	!No. Skip leading spaces.
        L2 = L1			!Righto, L1 is the first non-blank.
   12   L2 = L2 + 1		!Scan through the non-blanks.
        IF (L2.GT.L) GO TO 13	!Is it safe to look?
        IF (TEXT(L2:L2).GT." ") GO TO 12	!Yes. Speed through non-blanks.
   13   N = N + 1			!Righto, a word is found in TEXT(L1:L2 - 1)
        IST(N) = L1		!So, recall its first character.
        LST(N) = L2 - 1		!And its last.
        IF (L2.LT.L) GO TO 10	!Perhaps more text follows.
Comma time...
   20   WRITE (MSG,21) "{"	!Start the output.
   21   FORMAT (A,$)		!The $, obviously, specifies that the line is not finished.
        DO I = 1,N		!Step through the texts, there possibly being none.
          IF (I.GT.1) THEN		!If there has been a predecessor, supply separators.
            IF (I.LT.N) THEN			!Up to the last two, it's easy.
              WRITE (MSG,21) ", "			!Always just a comma.
            ELSE IF (OXFORDIAN) THEN		!But after the penultimate item, what?
              WRITE (MSG,21) ", and "			!Supply the comma omitted above: a double-power separator.
            ELSE				!One fewer comma, with possible ambiguity arising.
              WRITE (MSG,21) " and "			!A single separator.
            END IF				!So much for the style.
          END IF			!Enough with the separation.
          WRITE (MSG,21) TEXT(IST(I):LST(I))	!The text at last!
        END DO			!On to the next text.
        WRITE (MSG,"('}')")	!End the line, marking the end of the text.
      END		!That was fun.

      PROGRAM ENCOMMA	!Punctuate a list with commas.
      CHARACTER*(666) TEXT	!Holds the text. Easily long enough.
      INTEGER KBD,MSG,INF	!Now for some messing.
      COMMON /IODEV/MSG,KBD	!Pass the word.
      KBD = 5	!Standard input.
      MSG = 6	!Standard output.
      INF = 10	!Suitable for a disc file.
      OPEN (INF,FILE="List.txt",ACTION = "READ")	!Attach one.

   10 WRITE (MSG,11) "To insert commas into lists..."	!Announce.
   11 FORMAT (A)			!Just the text.
   12 READ (INF,11,END = 20) TEXT	!Grab the text, with trailing spaces to fill out TEXT.
      CALL QUIBBLE(TEXT,.FALSE.)	!One way to quibble.
      GO TO 12				!Try for another.

   20 REWIND (INF)			!Back to the start of the file.
      WRITE (MSG,11)			!Set off a bit.
      WRITE (MSG,11) "Oxford style..."	!Announce the proper style.
   21 READ (INF,11,END = 30) TEXT	!Grab the text.
      CALL QUIBBLE(TEXT,.TRUE.)		!The other way to quibble.
      GO TO 21				!Have another try.

Closedown
   30 END	!All files are closed by exiting.
