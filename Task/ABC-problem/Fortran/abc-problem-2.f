      MODULE PLAYPEN	!Messes with a set of alphabet blocks.
       INTEGER MSG		!Output unit number.
       PARAMETER (MSG = 6)	!Standard output.
       INTEGER MS		!I dislike unidentified constants...
       PARAMETER (MS = 2)	!So this is the maximum number of lettered sides.
       INTEGER LETTER(26),SUPPLY(26)	!For counting the alphabet.
       CONTAINS
        SUBROUTINE SWAP(I,J)	!This really should be known to the compiler.
         INTEGER I,J,K		!Which could generate in-place code,
          K = I			!Using registers, maybe.
          I = J			!Or maybe, there are special op-codes.
          J = K			!Rather than this clunkiness.
        END SUBROUTINE SWAP	!And it should be for any type of thingy.

        INTEGER FUNCTION LSTNB(TEXT)  !Sigh. Last Not Blank.
Concocted yet again by R.N.McLean (whom God preserve) December MM.
Code checking reveals that the Compaq compiler generates a copy of the string and then finds the length of that when using the latter-day intrinsic LEN_TRIM. Madness!
Can't   DO WHILE (L.GT.0 .AND. TEXT(L:L).LE.' ')	!Control chars. regarded as spaces.
Curse the morons who think it good that the compiler MIGHT evaluate logical expressions fully.
Crude GO TO rather than a DO-loop, because compilers use a loop counter as well as updating the index variable.
Comparison runs of GNASH showed a saving of ~3% in its mass-data reading through the avoidance of DO in LSTNB alone.
Crappy code for character comparison of varying lengths is avoided by using ICHAR which is for single characters only.
Checking the indexing of CHARACTER variables for bounds evoked astounding stupidities, such as calculating the length of TEXT(L:L) by subtracting L from L!
Comparison runs of GNASH showed a saving of ~25-30% in its mass data scanning for this, involving all its two-dozen or so single-character comparisons, not just in LSTNB.
         CHARACTER*(*),INTENT(IN):: TEXT	!The bumf. If there must be copy-in, at least there need not be copy back.
         INTEGER L		!The length of the bumf.
          L = LEN(TEXT)		!So, what is it?
    1     IF (L.LE.0) GO TO 2	!Are we there yet?
          IF (ICHAR(TEXT(L:L)).GT.ICHAR(" ")) GO TO 2	!Control chars are regarded as spaces also.
          L = L - 1		!Step back one.
          GO TO 1		!And try again.
    2     LSTNB = L		!The last non-blank, possibly zero.
         RETURN			!Unsafe to use LSTNB as a variable.
        END FUNCTION LSTNB	!Compilers can bungle it.

        SUBROUTINE LETTERCOUNT(TEXT)	!Count the occurrences of A-Z.
         CHARACTER*(*) TEXT	!The text to inspect.
         INTEGER I,K		!Assistants.
          DO I = 1,LEN(TEXT)		!Step through the text.
            K = ICHAR(TEXT(I:I)) - ICHAR("A") + 1	!This presumes that A-Z have contiguous codes!
            IF (K.GE.1 .AND. K.LE.26) LETTER(K) = LETTER(K) + 1	!Not so with EBCDIC!!
          END DO			!On to the next letter.
        END SUBROUTINE LETTERCOUNT	!Be careful with LETTER.

        SUBROUTINE UPCASE(TEXT)	!In the absence of an intrinsic...
Converts any lower case letters in TEXT to upper case...
Concocted yet again by R.N.McLean (whom God preserve) December MM.
Converting from a DO loop evades having both an iteration counter to decrement and an index variable to adjust.
         CHARACTER*(*) TEXT	!The stuff to be modified.
c        CHARACTER*26 LOWER,UPPER	!Tables. a-z may not be contiguous codes.
c        PARAMETER (LOWER = "abcdefghijklmnopqrstuvwxyz")
c        PARAMETER (UPPER = "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
CAREFUL!! The below relies on a-z and A-Z being contiguous, as is NOT the case with EBCDIC.
         INTEGER I,L,IT		!Fingers.
          L = LEN(TEXT)		!Get a local value, in case LEN engages in oddities.
          I = L			!Start at the end and work back..
    1     IF (I.LE.0) RETURN 	!Are we there yet? Comparison against zero should not require a subtraction.
c         IT = INDEX(LOWER,TEXT(I:I))	!Well?
c         IF (IT .GT. 0) TEXT(I:I) = UPPER(IT:IT)	!One to convert?
          IT = ICHAR(TEXT(I:I)) - ICHAR("a")		!More symbols precede "a" than "A".
          IF (IT.GE.0 .AND. IT.LE.25) TEXT(I:I) = CHAR(IT + ICHAR("A"))	!In a-z? Convert!
          I = I - 1			!Back one.
          GO TO 1			!Inspect..
        END SUBROUTINE UPCASE	!Easy.

        SUBROUTINE ORDERSIDE(LETTER)	!Puts the letters into order.
         CHARACTER*(*) LETTER	!The letters.
         INTEGER I,N,H		!Assistants.
         CHARACTER*1 T		!A scratchpad.
         LOGICAL CURSE		!A bit.
          N = LEN(LETTER)	!So, how many letters?
          H = N - 1		!Last - First, and not +1.
          IF (H.LE.0) RETURN	!Ha ha.
    1     H = MAX(1,H*10/13)		!The special feature.
          IF (H.EQ.9 .OR. H.EQ.10) H = 11	!A twiddle.
          CURSE = .FALSE.		!So far, so good.
          DO I = N - H,1,-1		!If H = 1, this is a BubbleSort.
            IF (LETTER(I:I).LT.LETTER(I + H:I + H)) THEN	!One compare.
              T = LETTER(I:I)			!One swap.
              LETTER(I:I) = LETTER(I + H:I + H)	!Alas, no SWAP(A,B)
              LETTER(I + H:I + H) = T		!Is recognised by the compiler.
              CURSE = .TRUE.		!If once a tiger is seen...
            END IF			!So much for that comparison.
          END DO			!On to the next.
          IF (CURSE .OR. H.GT.1) GO TO 1!Another pass?
        END SUBROUTINE ORDERSIDE	!Simple enough.
        SUBROUTINE ORDERBLOCKS(N,SOME)	!Puts the collection of blocks into order.
         INTEGER N		!The number of blocks.
         CHARACTER*(*) SOME(:)	!Their lists of letters.
         INTEGER I,H		!Assistants.
         CHARACTER*(LEN(SOME(1))) T	!A scratchpad matching an element of SOME.
         LOGICAL CURSE			!Since there is still no SWAP(SOME(I),SOME(I + H)).
          H = N - 1		!So here comes another CombSort.
          IF (H.LE.0) RETURN	!With standard suspicion.
    1     H = MAX(1,H*10/13)		!This is the outer loop.
          IF (H.EQ.9 .OR. H.EQ.10) H = 11	!This is a fiddle.
          CURSE = .FALSE.		!Start the next pass in hope.
          DO I = N - H,1,-1		!Going backwards, just for fun.
            IF (SOME(I).LT.SOME(I + H)) THEN	!So then?
              T = SOME(I)		!Disorder.
              SOME(I) = SOME(I + H)	!So once again,
              SOME(I + H) = T		!Swap the two miscreants.
              CURSE = .TRUE.		!And remember.
            END IF			!So much for that comparison.
          END DO			!On to the next.
          IF (CURSE .OR. H.GT.1) GO TO 1!Are we there yet?
        END SUBROUTINE ORDERBLOCKS	!Not much code, but ringing the changes is still tedious.

        SUBROUTINE PLAY(N,SOME)	!Mess about with the collection of blocks.
         INTEGER N		!Their number.
         CHARACTER*(*) SOME(:)	!Their letters.
         INTEGER NH,HIT(N)	!A list of blocks.
         INTEGER B,I,J,K,L,M	!Assistants.
         CHARACTER*1 C		!A letter of the moment.
          L = LEN(SOME(1))	!The maximum number of letters to any block.
Cast the collection on to the floor.
          WRITE (MSG,1) N,L,SOME	!Announce the set as it is supplied.
    1     FORMAT (I7," blocks, with at most",I2," letters:",66(1X,A))
Change the "orientation" of some blocks.
          DO B = 1,N		!Step through each block.
            CALL UPCASE(SOME(B))	!Paranoia rules.
            CALL ORDERSIDE(SOME(B))	!Put its letter list into order.
          END DO		!On to the next block.
          WRITE (MSG,2) SOME	!Reveal the orderly array.
    2     FORMAT (6X,"... the letters in reverse order:",66(1X,A))
Collate the collection of blocks.
          CALL ORDERBLOCKS(N,SOME)	!Now order the blocks by their letters.
          WRITE (MSG,3) SOME		!Reveal them in neato order.
    3     FORMAT (7X,"... the blocks in reverse order:",66(1X,A))
Count the appearances of the letters of the alphabet.
          LETTER = 0		!Enough of shuffling blocks around.
          DO B = 1,N		!Now inspect their collective letters.
            CALL LETTERCOUNT(SOME(B))	!A block's worth at a go.
          END DO		!On to the next block.
          SUPPLY = LETTER	!Save the counts of supplied letters.
          WRITE (MSG,4) (CHAR(ICHAR("A") + I - 1),I = 1,26),SUPPLY	!Results.
    4     FORMAT (15X,"Letters of the alphabet:",26A<MS + 1>,/,	!First, a line with A ... Z.
     1     11X,"... number thereof supplied:",26I<MS + 1>)	!Then a line of the associated counts.
Check for blocks with duplicated letters.
          WRITE (MSG,5)		!Announce.
    5     FORMAT (8X,"Blocks with duplicated letters:",$)	!Further output impends.
          M = 0			!No duplication found.
          DO B = 1,N		!So step through each block.
         JJ:DO J = 2,L			!Inspecting successive letters of the block,
              IF (SOME(B)(J:J).LE." ") EXIT JJ	!Provided they've not run out.
              DO K = 1,J - 1			!To see if it has appeared earlier.
                IF (SOME(B)(K:K).LE." ") EXIT JJ!Reverse order means that spaces will be at the end!
                IF (SOME(B)(J:J).EQ.SOME(B)(K:K)) THEN	!Well?
                  M = M + 1		!A match!
                  WRITE (MSG,6) SOME(B)	!Name the block.
    6             FORMAT (1X,A,$)	!With further output still impending,
                  EXIT JJ		!And give up on this block.
                END IF			!One duplicated letter is sufficient for its downfall.
              END DO			!Next letter up.
            END DO JJ			!On to the next letter of the block.
          END DO		!On to the next block.
          CALL HIC(M)		!Show the count and end the line.
Check for duplicate blocks, knowing that the array of blocks is ordered.
          WRITE (MSG,7)		!Announce.
    7     FORMAT (21X,"Duplicated blocks:",$)	!Again, leave the line dangling.
          K = 0			!No duplication found.
          B = 1			!Syncopation.
   70     B = B + 1		!Advance one.
          IF (B.GT.N) GO TO 72	!Are we there yet?
          IF (SOME(B).NE.SOME(B - 1)) GO TO 70	!No match? Search on.
          K = K + 1		!A match is counted.
          WRITE (MSG,6) SOME(B)	!Name it.
   71     B = B + 1		!And speed through continued matching.
          IF (B.GT.N) GO TO 72	!Unless we're of the end.
          IF (SOME(B).EQ.SOME(B - 1)) GO TO 71	!Continued matching?
          GO TO 70		!Mismatch: resume the normal scan.
   72     CALL HIC(K)		!So much for that.
Check for duplicated letters across different blocks.
          IF (ALL(SUPPLY.LE.1)) RETURN	!Unless there are no duplicated letters.
          WRITE (MSG,8)		!Announce.
    8     FORMAT ("Duplicated letters on different blocks:",$)	!More to come.
          K = 0		!Start another count.
          DO I = 1,26		!A well-known span.
            IF (SUPPLY(I).LE.1) CYCLE	!Any duplicated letters?
            C = CHAR(ICHAR("A") + I - 1)!Yes. This is the character.
            NH = 0		!So, how many blocks contribute?
            DO B = 1,N		!Find out.
              IF (INDEX(SOME(B),C).GT.0) THEN	!On this block?
                NH = NH + 1		!Yes.
                HIT(NH) = B		!Keep track of which.
              END IF			!So much for that block.
            END DO		!On to the next.
            IF (ANY(SOME(HIT(2:NH)) .NE. SOME(HIT(1)))) THEN	!All have the same collection of letters?
              K = K + 1			!No!
              WRITE (MSG,9) C		!Name the heterogenously supported letter.
    9         FORMAT (A<MS + 1>,$)	!Use the same spacing even though one character only.
            END IF		!So much for that letter's search.
          END DO		!On to the next letter.
          CALL HIC(K)	!Finish the line with the count report.
         CONTAINS	!This is used often enough.
          SUBROUTINE HIC(N)	!But has very specific context.
           INTEGER N			!The count.
            IF (N.LE.0) WRITE (MSG,*) "None."	!Yes, we have no bananas.
            IF (N.GT.0) WRITE (MSG,*) N		!Either way, end the line.
          END SUBROUTINE HIC	!This service routine is not needed elsewhere.
        END SUBROUTINE PLAY	!Look mummy! All the blockses are neatened!

        LOGICAL FUNCTION CANBLOCK(WORD,N,SOME)	!Can the blocks spell out the word?
Creates a move tree based on the letters of WORD and for each, the blocks available.
         CHARACTER*(*) WORD	!The word to spell out.
         INTEGER N		!The number of blocks.
         CHARACTER*(*) SOME(:)	!The blocks and their letters.
         INTEGER NA,AVAIL(N)	!Say not the struggle naught availeth!
         INTEGER NMOVE(LEN(WORD))	!I need a list of acceptable blocks,
         INTEGER MOVE(LEN(WORD),N)	!One list for each letter of WORD.
         INTEGER I,L,S		!Assistants.
         CHARACTER*1 C		!The letter of the moment.
          CANBLOCK = .FALSE.		!Initial pessimism.
          L = LSTNB(WORD)		!Ignore trailing spaces.
          IF (L.GT.N) RETURN		!Enough blocks?
          LETTER = 0				!To make rabbit stew,
          CALL LETTERCOUNT(WORD(1:L))		!First catch your rabbit.
          IF (ANY(SUPPLY .LT. LETTER)) RETURN	!The larder is lacking.
          NA = N			!Prepare a list.
          FORALL (I = 1:N) AVAIL(I) = I	!That fingers every block.
          I = 0		!Step through the letters of the WORD.
Chug through the letters of the WORD.
    1     I = I + 1	!One letter after the other.
          IF (I.GT.L) GO TO 100	!Yay! We're through!
          C = WORD(I:I)		!The letter of the moment.
          NMOVE(I) = 0		!No moves known at this new level.
          DO S = 1,NA		!So, look for them amongst the available slots.
            IF (INDEX(SOME(AVAIL(S)),C) .GT. 0) THEN	!A hit?
              NMOVE(I) = NMOVE(I) + 1	!Yes! Count up another possible move.
              MOVE(I,NMOVE(I)) = S	!Remember its slot.
            END IF			!So much for that block.
          END DO		!On to the next.
    2     IF (NMOVE(I).GT.0) THEN	!Have we any moves?
            S = MOVE(I,NMOVE(I))	!Yes! Recover the last found.
            NMOVE(I) = NMOVE(I) - 1	!Uncount, as it is about to be used.
            IF (S.NE.NA) CALL SWAP(AVAIL(S),AVAIL(NA))	!This block is no longer available.
            NA = NA - 1			!Shift the boundary back.
            GO TO 1			!Try the next letter!
          END IF		!But if we can't find a move at that level...
          I = I - 1		!Retreat a level.
          IF (I.LE.0) RETURN	!Oh dear!
          S = MOVE(I,NMOVE(I) + 1)	!Undo the move that had been made at this level.
          NA = NA + 1			!And make its block is re-available.
          IF (S.NE.NA) CALL SWAP(AVAIL(S),AVAIL(NA))	!Move it back.
          GO TO 2		!See what moves remain at this level.
Completed!
  100     CANBLOCK = .TRUE.	!That's a relief.
        END FUNCTION CANBLOCK	!Some revisions might have been made.
      END MODULE PLAYPEN	!No sand here.

      USE PLAYPEN	!Just so.
      INTEGER HAVE,TESTS		!Parameters for the specified problem.
      PARAMETER (HAVE = 20, TESTS = 7)	!Number of blocks, number of tests.
      CHARACTER*(MS) BLOCKS(HAVE)	!Have blocks, will juggle.
      DATA BLOCKS/"BO","XK","DQ","CP","NA","GT","RE","TG","QD","FS",	!The specified set
     1            "JW","HU","VI","AN","OB","ER","FS","LY","PC","ZM"/	!Of letter blocks.
      CHARACTER*8 WORD(TESTS)		!Now for the specified test words.
      LOGICAL ANS(TESTS),T,F		!And the given results.
      PARAMETER (T = .TRUE., F = .FALSE.)	!Enable a more compact specification.
      DATA WORD/"A","BARK","BOOK","TREAT","COMMON","SQUAD","CONFUSE"/	!So that these
      DATA  ANS/ T ,    T ,    F ,     T ,      F ,     T ,       T /	!Can be aligned.
      LOGICAL YAY
      INTEGER I

      WRITE (MSG,1)
    1 FORMAT ("Arranges alphabet blocks, attending only to the ",
     1 "letters on the blocks, and ignoring case and orientation.",/)

      CALL PLAY(HAVE,BLOCKS)	!Some fun first.

      WRITE (MSG,'(/"Now to see if some words can be spelled out.")')
      DO I = 1,TESTS
        CALL UPCASE(WORD(I))
        YAY = CANBLOCK(WORD(I),HAVE,BLOCKS)
        WRITE (MSG,*) YAY,ANS(I),YAY.EQ.ANS(I),WORD(I)
      END DO
      END
