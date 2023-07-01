      MODULE MADLIB	!Messing with COMMON is less convenient.
       INTEGER MSG,KBD,INF		!I/O unit numbers.
       DATA MSG,KBD,INF/6,5,10/		!Output, input, some disc file.
       INTEGER LSTASH,NSTASH,MSTASH	!Prepare a common text stash.
       PARAMETER (LSTASH = 246810, MSTASH = 6666)	!LSTASH characters for MSTASH texts.
       CHARACTER*(LSTASH) STASH		!The pool.
       INTEGER ISTASH(MSTASH + 1)	!Fingers start positions, and thus end positions by extension.
       DATA NSTASH,ISTASH(1)/0,1/	!Empty pool: no entries, first available character is at 1.
       INTEGER MANYLINES,MANYTESTS	!I also want some lists of texts.
       PARAMETER (MANYLINES = 1234)	!This is to hold the story.
       INTEGER NSTORY,STORY(MANYLINES)	!Fingering texts in the stash.
       PARAMETER (MANYTESTS = 1234)	!Likewise, some target/replacement texts.
       INTEGER NTESTS,TARGET(MANYTESTS),REPLACEMENT(MANYTESTS)	!Thus.
       DATA NSTORY,NTESTS/0,0/		!No story lines, and no tests.
       INTEGER STACKLIMIT		!A recursion limit.
       PARAMETER (STACKLIMIT = 28)	!This should suffice.

       CONTAINS
        SUBROUTINE CROAK(GASP)	!A dying remark.
         CHARACTER*(*) GASP	!The last words.
         WRITE (MSG,*) "Oh dear."	!Shock.
         WRITE (MSG,*) GASP		!Aargh!
         STOP "How sad."		!Farewell, cruel world.
        END SUBROUTINE CROAK	!Farewell...

        SUBROUTINE SHOWSTASH(BLAH,I)	!One might be wondering.
         CHARACTER*(*) BLAH		!An annotation.
         INTEGER I			!The desired stashed text.
          WRITE (MSG,1) BLAH,I,STASH(ISTASH(I):ISTASH(I + 1) - 1)	!Whee!
    1     FORMAT (A,': Text(',I0,')="',A,'"')	!Hopefully, helpful.
        END SUBROUTINE SHOWSTASH	!Ah, debugging.

        INTEGER FUNCTION EATTEXT(IN)	!Add a text to STASH and finger it.
Co-opts the as-yet unused space in STASH as its scratchpad.
         INTEGER IN	!Input from this I/O unit number.
         INTEGER I,N,L	!Fingers.
          I = ISTASH(NSTASH + 1)!First available position in STASH.
          N = LSTASH - I + 1	!Number of characters yet unused.
          IF (N.LT.666) CALL CROAK("Insufficient STASH space remains!")
          READ (IN,1,END = 66) L,STASH(I:I + MIN(L,N) - 1)	!Calculated during the read.
    1     FORMAT (Q,A)		!Obviously, Q = character count incoming, A = accept all of them.
          L = I + MIN(L,N) - 1	!The last character read.
   10     IF (L.LT.I) GO TO 66	!A blank line! Deemed end-of-file.
          IF (ICHAR(STASH(L:L)).LE.ICHAR(" ")) THEN	!A trailing space?
            L = L - 1		!Yes. Pull back.
            GO TO 10		!And try again.
          END IF		!So much for trailing spaces.
          IF (NSTASH.GE.MSTASH) CALL CROAK("Too many texts!")
          NSTASH = NSTASH + 1	!Admit another text.
          ISTASH(NSTASH + 1) = L + 1	!The start point of the following text.
          EATTEXT = NSTASH	!STASH(ISTASH(n):ISTASH(n + 1) - 1) has text n.
         RETURN			!All well.
   66     EATTEXT = 0		!Sez: "No text".
        END FUNCTION EATTEXT	!Rather odd side effects.

        INTEGER FUNCTION ADDSTASH(TEXT)	!Appends an arbitrary text to the pool of stashed texts.
         CHARACTER*(*) TEXT	!The stuff.
         INTEGER I		!A finger.
          IF (NSTASH.GE.MSTASH) CALL CROAK("The text pool is crowded!")	!Alas.
          I = ISTASH(NSTASH + 1)	!First unused character.
          IF (I + LEN(TEXT).GT.LSTASH) CALL CROAK("Overtexted!")	!Alack.
          STASH(I:I + LEN(TEXT) - 1) = TEXT	!Place.
          NSTASH = NSTASH + 1			!Count in another entry.
          ISTASH(NSTASH + 1) = I + LEN(TEXT)	!The new "first available" position.
          ADDSTASH = NSTASH	!Pass a finger back to the caller.
        END FUNCTION ADDSTASH	!Just an integer.

        INTEGER FUNCTION ANOTHER(TEXT)	!Possibly add TEXT to the table of target texts.
Collects TARGET REPLACEMENT pairs (increasing NTESTS) as directed by INSPECT.
         CHARACTER*(*) TEXT	!The text of the target.
         INTEGER I,IT		!Steppers.
          ANOTHER = 0		!Possibly, the text is already in the table.
          DO I = 1,NTESTS	!So, step through the known target texts.
            IT = TARGET(I)		!Finger a target text.
            IF (TEXT.EQ.STASH(ISTASH(IT):ISTASH(IT + 1) - 1)) RETURN	!Already have this one.
          END DO		!Otherwise, try the next.
          IF (NTESTS.GE.MANYTESTS) CALL CROAK("Too many tests!")	!Oh dear.
          NTESTS = NTESTS + 1		!Count in another.
          TARGET(NTESTS) = ADDSTASH(TEXT)!Stash its text and get a finger to it.
          ANOTHER = NTESTS		!My caller will want to know which test.
          WRITE (MSG,1) TEXT		!Now request the replacement text.
    1     FORMAT ("Enter your text for ",A,": ",$)	!Obviously, the $ indicates "no new line".
          REPLACEMENT(NTESTS) = EATTEXT(KBD)	!Zero for "no text".
        END FUNCTION ANOTHER	!Produces entries for TARGET and REPLACEMENT.

        SUBROUTINE INSPECT(X)	!Examine text number X for the special <...> sequence.
Calls for inspection of REPLACEMENT texts as well, should ANOTHER report a new entry.
         INTEGER X	!Fingers the text in STASH via ISTASH(X).
         INTEGER MARK	!Recalls where the < was found.
         INTEGER IT,NEW	!Fingers to entries in STASH.
         INTEGER I	!A stepper.
         INTEGER SP,STACK(STACKLIMIT)	!Prepare for some recursion.
          SP = 1		!Start with the starter.
          STACK(1) = X		!Stack up.
          DO WHILE(SP.GT.0)	!While texts are yet uninspected,
            IT = STACK(SP)		!Finger one.
            SP = SP - 1			!Working down the stack.
            MARK = 0			!Uninitialised variables are bad.
            DO I = ISTASH(IT),ISTASH(IT + 1) - 1!Step through the stashed text.
              IF (STASH(I:I).EQ."<") THEN	!Is it the starter?
                MARK = I			!Yes. Remember where it is.
              ELSE IF (STASH(I:I).EQ.">") THEN	!The ender?
                IF (MARK.LE.0) CALL CROAK("A > with no preceeding <!")	!Bah.
                NEW = ANOTHER(STASH(MARK:I))	!Consider the spanned text.
                IF (NEW.GT.0) THEN		!If that became a new table entry,
                  IF (SP.GE.STACKLIMIT) CALL CROAK("Stack overflow!")	!Its replacement is to be inspected.
                  SP = SP + 1			!But I'm still busy with the current text.
                  STACK(SP) = REPLACEMENT(NEW)	!So, stack it for later.
                END IF			!So much for that <...> apparition.
                MARK = 0		!Be ready to check afresh for the next.
              END IF		!So much for that character.
            END DO		!On to the next.
          END DO	!So much for that stacked entry.
        END SUBROUTINE INSPECT	!WRITESTORY will rescan the story lines.

        SUBROUTINE READSTORY(IN)!Read and stash the lines.
         INTEGER IN		!Input from here.
         INTEGER LINE		!A finger to the story line.
   10    LINE = EATTEXT(IN)	!So, grab a line.
         IF (LINE.GT.0) THEN	!A live line?
           NSTORY = NSTORY + 1	!Yes.Count it in.
           STORY(NSTORY) = LINE	!Save it in the story list.
           CALL INSPECT(LINE)	!Look for trouble as well.
           GO TO 10		!And go for the next line.
         END IF			!Oh for while (Line:=EatText(in)) > 0 do SaveAndInspect(Line);
        END SUBROUTINE READSTORY!Simple enough, anyway.

        SUBROUTINE WRITESTORY(WIDTH)	!Applying the replacements, with replacement replacement too.
Co-opts the as-yet unused space in STASH as its output scratchpad.
Can't rely on changing the index and bounds of a DO-loop on the fly.
         INTEGER WIDTH
         INTEGER LINE,IT,I,J	!Steppers.
         INTEGER L,L0,N		!Fingers.
         INTEGER TAIL,MARK,LAST	!Scan choppers.
         INTEGER SP,STACKI(STACKLIMIT),STACKL(STACKLIMIT)	!Ah, recursion.
          L0 = ISTASH(NSTASH + 1)	!The first available place in the stash.
          L = L0 - 1			!Syncopation for my output finger.
       LL:DO LINE = 1,NSTORY		!Step through the lines of the story.
            SP = 0			!Start with the task in hand.
            IT = STORY(LINE)		!Finger the stashed line.
            LAST = ISTASH(IT + 1) - 1	!Find its last character in STASH.
            I = ISTASH(IT)		!Find its first character in STASH.
            TAIL = I - 1		!Syncopation. No text from this line yet.
            IF (STASH(I:I).LE." ") THEN	!The line starts with a space?
              CALL BURP			!Yes. Flush, so as to start a new paragraph.
            ELSE IF (LINE.GT.1) THEN	!Otherwise, the line is a continuation.
              L = L + 1			!So, squeeze in a space as a separator.
              STASH(L:L) = " "		!Since its text follows on.
            END IF			!Now for the content of the line.
  666    II:DO WHILE(I.LE.LAST)		!Step along its text.
              IF (STASH(I:I).EQ."<") THEN	!Trouble starter?
                MARK = I			!Yes. Remember where.
              ELSE IF (STASH(I:I).EQ.">") THEN	!The corresponding ender?
                CALL APPEND(TAIL + 1,MARK - 1)	!Waiting text up to the mark.
             JJ:DO J = 1,NTESTS		!Step through the target texts.
                  IT = TARGET(J)		!Finger one.
                  IF (STASH(ISTASH(IT):ISTASH(IT + 1) - 1)	!Its stashed text.
     1            .EQ.STASH(MARK:I)) THEN		!Matches the suspect text?
                    IT = REPLACEMENT(J)		!Yes! Finger the replacement text.
                    IF (IT.GT.0) THEN	!Null replacements can be ignored.
                      IF (SP.GE.STACKLIMIT) CALL CROAK("StackOverflow!")	!Always diff. messages.
                      SP = SP + 1		!Interrupt the current scan.
                      STACKI(SP) = I		!Remember where we're up to,
                      STACKL(SP) = LAST		!And the end of the text.
                      I = ISTASH(IT) - 1	!One will be added shortly, at JJ+1.
                      LAST = ISTASH(IT + 1) - 1	!Preempt the scan-in-progress.
                    END IF			!To work along the replacement text.
                    EXIT JJ		!Found the target, so the search is finished.
                  END IF		!Otherwise,
                END DO JJ		!Try the next target text.
                TAIL = I		!Normal text resumes at TAIL + 1.
              END IF			!Enough analysis of that character from the story line.
              I = I + 1			!The next to consider.
            END DO II		!Perhaps we've finished this text.
            IF (SP.GT.0) THEN	!Yes! But, were we interrupted in a previous scan?
              CALL APPEND(TAIL + 1,LAST)!Yes! Roll the tail of the just-finished scan.
              TAIL = STACKI(SP)		!The stacked value of I was fingering a >.
              LAST = STACKL(SP)		!And this was the end of the text.
              SP = SP - 1		!So we've recovered where the scan was.
              I = TAIL + 1		!And this is the next to look at.
              GO TO 666			!Proceed to do so.
            END IF		!But if all is unstacked,
            CALL APPEND(TAIL + 1,LAST)	!Don't forget the tail end.
          END DO LL			!On to the next story line.
          CALL BURP		!Any waiting text must be less than WIDTH.
         CONTAINS		!Some assistants, defined after usage...
          SUBROUTINE APPEND(IST,LST)	!Has access to L.
           INTEGER IST,LST		!To copy STASH(IST:LST) to the scratchpad.
           INTEGER N			!The number of characters to copy.
            N = LST - IST + 1		!So find out.
            IF (N.LE.0) RETURN		!Avoid relying on zero-length action.
            IF (L + N.GT.LSTASH) CALL CROAK("Out of stash!")	!Oh dear.
            STASH(L + 1:L + N) = STASH(IST:LST)	!There they go.
            L = L + N			!Advance my oputput finger.
            IF (L - L0 + 1.GE.WIDTH) CALL BURP	!Enough to be going on with?
          END SUBROUTINE APPEND		!Few invocations, if with tricky parameters.
          SUBROUTINE BURP		!Flushes forth up to WIDTH characters.
           INTEGER N,W,L1		!And slides any remnant back.
            N = L - L0 + 1		!So, how many characters are waiting?
            IF (N.LE.WIDTH) THEN	!Too many for one line of output?
              L1 = L			!Nope. Roll the lot.
             ELSE			!Otherwise, a partial flush.
              W = L0 + WIDTH - 1	!Last character that can be fitted into WIDTH.
              DO L1 = W,L0,-1		!Look for a good split.
                IF (STASH(L1:L1).LE." ") EXIT	!Like, at a space.
              END DO			!Keep winding back.
              IF (L1.LE.L0) L1 = W	!No pleasing split found. Just roll a full width.
            END IF			!Ready to roll.
            WRITE (MSG,"(A)") STASH(L0:L1)	!Thus!
            IF (N.LE.WIDTH) THEN	!If the whole text was written,
              L = L0 - 1		!Then there is no text in the scratchpad.
             ELSE			!If only L0:L1 were written of L0:L,
              W = L0 + L - L1 - 1	!How far will the remaining text extend?
              STASH(L0:W) = STASH(L1 + 1:L)	!Shift it.
              L = W			!Finger the last used character position.
            END IF			!One trim is enough, even if the scracchpad contains multiple widths' worth..
          END SUBROUTINE BURP		!Since I don't want to flush the lot.
        END SUBROUTINE WRITESTORY	!Just a sequence of lines.
      END MODULE MADLIB		!Enough of that.

      PROGRAM MADLIBBER	!See, for example, https://en.wikipedia.org/wiki/Mad_Libs
      USE MADLIB
      WRITE (MSG,1)	!It's polite to explain.
    10FORMAT ("Reads a story in template form, containing special ",
     1 "entries such as <dog's name> amongst the text.",/,
     2 "You will be invited to supply a replacement text for each "
     3 "such entry, as encountered,",/,
     4 "after which the story will be presented with your ",
     5 "substitutions made.",//,
     6 "Here goes... Reading file Madlib.txt",/)
      OPEN(INF,STATUS="OLD",ACTION="READ",FORM="FORMATTED",
     1 FILE = "Madlib.txt")
      CALL READSTORY(INF)
      CLOSE(INF)
      WRITE (MSG,*)
      WRITE (MSG,*) "  Righto!"
      WRITE (MSG,*)
      CALL WRITESTORY(66)
      END
