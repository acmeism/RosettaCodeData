      PROGRAM REVERSER	!Just fooling around.
      CHARACTER*(66) TEXT	!Holds the text. Easily long enough.
      CHARACTER*1 ATXT(66)	!But this is what I play with.
      EQUIVALENCE (TEXT,ATXT)	!Same storage, different access abilities..
      DATA TEXT/"Rosetta Code Phrase Reversal"/	!Easier to specify this for TEXT.
      INTEGER IST(6),LST(6)	!Start and stop positions.
      INTEGER N,L,I		!Counters.
      INTEGER L1,L2		!Fingers for the scan.
      CHARACTER*(*) AS,RW,FW,RO,FO			!Now for some cramming.
      PARAMETER (AS = "Words ordered as supplied")	!So that some statements can fit on a line.
      PARAMETER (RW = "Reversed words, ", FW = "Forward words, ")
      PARAMETER (RO = "reverse order",    FO = "forward order")

Chop the text into words.
      N = 0		!No words found.
      L = LEN(TEXT)	!Multiple trailing spaces - no worries.
      L2 = 0		!Syncopation: where the previous chomp ended.
   10 L1 = L2		!Thus, where a fresh scan should follow.
   11 L1 = L1 + 1		!Advance one.
      IF (L1.GT.L) GO TO 20		!Finished yet?
      IF (ATXT(L1).LE." ") GO TO 11	!No. Skip leading spaces.
      L2 = L1			!Righto, L1 is the first non-blank.
   12 L2 = L2 + 1		!Scan through the non-blanks.
      IF (L2.GT.L) GO TO 13	!Is it safe to look?
      IF (ATXT(L2).GT." ") GO TO 12	!Yes. Speed through non-blanks.
   13 N = N + 1			!Righto, a word is found in TEXT(L1:L2 - 1)
      IST(N) = L1		!So, recall its first character.
      LST(N) = L2 - 1		!And its last.
      IF (L2.LT.L) GO TO 10	!Perhaps more text follows.

Chuck the words around.
   20 WRITE (6,21) N,TEXT	!First, say what has been discovered.
   21 FORMAT (I4," words have been isolated from the text ",A,/)

      WRITE (6,22) AS,    (" ",ATXT(IST(I):LST(I):+1), I = 1,N,+1)
      WRITE (6,22) RW//RO,(" ",ATXT(LST(I):IST(I):-1), I = N,1,-1)
      WRITE (6,22) FW//RO,(" ",ATXT(IST(I):LST(I):+1), I = N,1,-1)
      WRITE (6,22) RW//FO,(" ",ATXT(LST(I):IST(I):-1), I = 1,N,+1)

   22 FORMAT (A36,":",66A1)
      END
