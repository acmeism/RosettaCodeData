      MODULE STASHTEXTS		!Using COMMON is rather more tedious.
       INTEGER MSG,KBD			!I/O unit numbers.
       DATA MSG,KBD/6,5/		!Output, input.

       INTEGER LSTASH,NSTASH,MSTASH	!Prepare a common text stash.
       PARAMETER (LSTASH = 2468, MSTASH = 234)	!LSTASH characters for MSTASH texts.
       INTEGER ISTASH(MSTASH + 1)	!Index to start positions.
       CHARACTER*(LSTASH) STASH		!One pool.
       DATA NSTASH,ISTASH(1)/0,1/	!Which is empty.
       CONTAINS
        SUBROUTINE CROAK(GASP)	!A dying remark.
         CHARACTER*(*) GASP	!The last words.
         WRITE (MSG,*) "Oh dear."	!Shock.
         WRITE (MSG,*) GASP		!Aargh!
         STOP "How sad."		!Farewell, cruel world.
        END SUBROUTINE CROAK	!Farewell...

        SUBROUTINE UPCASE(TEXT)	!In the absence of an intrinsic...
Converts any lower case letters in TEXT to upper case...
Concocted yet again by R.N.McLean (whom God preserve) December MM.
Converting from a DO loop evades having both an iteration counter to decrement and an index variable to adjust.
         CHARACTER*(*) TEXT	!The stuff to be modified.
c         CHARACTER*26 LOWER,UPPER	!Tables. a-z may not be contiguous codes.
c         PARAMETER (LOWER = "abcdefghijklmnopqrstuvwxyz")
c         PARAMETER (UPPER = "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
CAREFUL!! The below relies on a-z and A-Z being contiguous, as is NOT the case with EBCDIC.
         INTEGER I,L,IT	!Fingers.
          L = LEN(TEXT)		!Get a local value, in case LEN engages in oddities.
          I = L			!Start at the end and work back..
    1     IF (I.LE.0) RETURN 	!Are we there yet? Comparison against zero should not require a subtraction.
c         IT = INDEX(LOWER,TEXT(I:I))	!Well?
c         IF (IT .GT. 0) TEXT(I:I) = UPPER(IT:IT)	!One to convert?
          IT = ICHAR(TEXT(I:I)) - ICHAR("a")		!More symbols precede "a" than "A".
          IF (IT.GE.0 .AND. IT.LE.25) TEXT(I:I) = CHAR(IT + ICHAR("A"))	!In a-z? Convert!
          I = I - 1		!Back one.
          GO TO 1		!Inspect..
        END SUBROUTINE UPCASE	!Easy.

        SUBROUTINE SHOWSTASH(BLAH,I)	!One might be wondering.
         CHARACTER*(*) BLAH		!An annotation.
         INTEGER I			!The desired stashed text.
          IF (I.LE.0 .OR. I.GT.NSTASH) THEN	!Paranoia rules.
            WRITE (MSG,1) BLAH,I		!And is not always paranoid.
    1       FORMAT (A,': Text(',I0,') is not in the stash!')	!Hopefully, helpful.
           ELSE		!But surely I will only be asked for what I have.
            WRITE (MSG,2) BLAH,I,STASH(ISTASH(I):ISTASH(I + 1) - 1)	!Whee!
    2       FORMAT (A,': Text(',I0,')=>',A,'<')	!Hopefully, informative.
          END IF			!So, it is shown.
        END SUBROUTINE SHOWSTASH	!Ah, debugging.

       INTEGER FUNCTION STASHIN(L2)	!Assimilate the text ending at L2.
Careful: furrytran regards "blah" and "blah   " as equal, so, compare lengths first.
        INTEGER L2	!The text to add is at ISTASH(NSTASH + 1):L2.
        INTEGER I,L1	!Assistants.
         L1 = ISTASH(NSTASH + 1)!Where the scratchpad starts.
         L = L2 - L1 + 1	!The length of the text.
Check to see if I already have stashed this exact text.
         DO I = 1,NSTASH	!Search my existing texts.
           IF (L.EQ.ISTASH(I + 1) - ISTASH(I)) THEN	!Matching lengths?
             IF (STASH(L1:L2)				!Yes. Does the scratchpad
     1       .EQ.STASH(ISTASH(I):ISTASH(I + 1) - 1)) THEN	!Match the stashed text?
               STASHIN = I		!Yes! I already have this exact text.
               RETURN			!And there is no need to duplicate it.
             END IF		!So much for matching text, furrytran style.
           END IF		!This time, trailing space differences will count.
         END DO			!On to the next stashed text.
Can't find it. Assimilate the scratchpad. No text is moved, just extend the fingers.
         IF (NSTASH.GE.MSTASH) CALL CROAK("The text pool is crowded!")	!Alas.
         IF (L2.GT.LSTASH) CALL CROAK("Overtexted!")	!Alack.
         NSTASH = NSTASH + 1		!Count in another entry.
         ISTASH(NSTASH + 1) = L2 + 1	!The new "first available" position.
         STASHIN = NSTASH		!Fingered for the caller.
       END FUNCTION STASHIN	!Rather than assimilating a supplied text.
      END MODULE STASHTEXTS	!Others can extract text as they wish.

      MODULE BADCHARACTER	!Some characters are not for glyphs but for action.
       CHARACTER*1 BS,HT,LF,VT,FF,CR	!Nicknames for a bunch of troublemakers.
       CHARACTER*6 BADC,GOODC		!I want a system.
       INTEGER*1 IBADC(6)		!Initialisation syntax is restricive.
       PARAMETER (GOODC="btnvfr")	!Mnemonics.
       EQUIVALENCE (BADC(1:1),BS),(BADC(2:2),HT),(BADC(3:3),LF),!Match the names
     1  (BADC(4:4),VT),(BADC(5:5),FF),(BADC(6:6),CR),	!To their character.
     2  (IBADC,BADC)				!Alas, a PARAMETER style is rejected.
       DATA IBADC/8,9,10,11,12,13/	!ASCII encodements.
       PRIVATE IBADC			!Keep this quiet.
      END MODULE BADCHARACTER	!They can disrupt layout.

      MODULE COMPOUND	!Stores entries, each of multiple parts, each part a text and a number.
       USE STASHTEXTS		!Gain access to the text repository.
       INTEGER LENTRY,NENTRY,MENTRY	!Entry counting.
       PARAMETER (MENTRY = 28)		!Should be enough for the test runs.
       INTEGER TENTRY(MENTRY)		!Each entry has a source text somewhere in STASH.
       INTEGER IENTRY(MENTRY + 1)	!This fingers its first part in PARTT and PARTI.
       INTEGER MPART,NPART		!Now for the pool of parts.
       PARAMETER (MPART = 120)		!Should suffice.
       INTEGER PARTT(MPART)		!A part's text number in STASH.
       INTEGER PARTI(MPART)		!A part's number, itself.
       DATA NENTRY,NPART,IENTRY(1)/0,0,1/	!There are no entries, with no parts either.
       CONTAINS		!The fun begins.
       INTEGER FUNCTION ADDENTRY(X)	!Create an entry holding X.
Chops X into many parts, alternating <text><integer>,<text><integer>,...
Converts the pieces' texts to upper case, as they will be used as a sort key later.
        CHARACTER*(*) X		!The text.
        INTEGER BORED,GRIST,NUMERIC	!Might as well supply some mnemonics.
        PARAMETER (BORED = 0, GRIST = 1, NUMERIC = 2)	!For nearly arbitrary integers.
        INTEGER I,STATE,D	!For traipsing through the text.
        INTEGER L1,L2		!Bounds of the scratchpad in STASH.
        CHARACTER*1 C		!Save on some typing.
Create a new entry. First, save its source text exactly as supplied.
         IF (NENTRY.GE.MENTRY) CALL CROAK("Too many entries!")	!Perhaps I can't.
         NENTRY = NENTRY + 1		!Another entry.
         L2 = ISTASH(NSTASH + 1) - 1	!Find my scratchpad.
         STASH(L2 + 1:L2 + LEN(X)) = X	!Place the text as it stands.
         TENTRY(NENTRY) = STASHIN(L2 + LEN(X))	!Find a finger to it in my text stash.
         CALL SHOWSTASH("Entering",TENTRY(NENTRY))	!Ah, debugging.
         ADDENTRY = NENTRY		!I shall return this.
Contemplate the text of the entry. Leading spaces, multiple spaces, numeric portions...
         STATE = BORED			!As if in leading space stuff.
         L2 = ISTASH(NSTASH + 1) - 1	!Syncopation for text piece placement.
         N = 0				!A number may be encountered.
         DO I = 1,LEN(X)	!Step through the text.
           C = X(I:I)		!Grab a character.
           IF (C.LE." ") THEN	!A space, or somesuch.
             SELECT CASE(STATE)	!What were we doing?
              CASE(BORED)	!Ignoring spaces.
              				!Do nothing with this one too.
              CASE(GRIST)	!We were in stuff.
               CALL ONESPACE		!So accept one space only.
              CASE(NUMERIC)	!We were in a number.
               CALL ADDPART		!So, the number has been ended.
               STATE = BORED		!But the space wot did it is ignored.
              CASE DEFAULT	!This should never happen.
               CALL CROAK("Confused state!")	!So this shouldn't.
             END SELECT		!So much for encountering spaceish stuff.
           ELSE IF ("0".LE.C .AND. C.LE."9") THEN	!A digit?
             D = ICHAR(C) - ICHAR("0")	!Yes. Convert to a numerical digit.
             N = N*10 + D		!Assimilate into a proper number.
             STATE = NUMERIC		!Perhaps more digits follow.
           ELSE		!All other characters are accepted as they stand.
             IF (STATE.EQ.NUMERIC) CALL ADDPART	!A number has just ended.
             L2 = L2 + 1		!Starting a new pair's text.
             STASH(L2:L2) = C	!With this.
             STATE = GRIST	!And anticipating more to come.
           END IF		!Types are: spaceish, grist, digits.
         END DO			!On to the next character.
         CALL ADDPART		!Ended by the end-of-text.
         IENTRY(NENTRY + 1) = NPART + 1	!Thus be able to find an entry's last part.
        CONTAINS	!Odd assistants.
         SUBROUTINE ONESPACE	!Places a space, then declares BORED.
           L2 = L2 + 1		!Advance one.
           STASH(L2:L2) = " "	!An actual blank.
           STATE = BORED	!Any subsequent spaces are to be ignored.
         END SUBROUTINE ONESPACE!Skipping them.
         SUBROUTINE ADDPART	!Augment the paired PARTT and PARTI.
           IF (NPART.GE.MPART) CALL CROAK("Too many parts!")	!If space remains.
           NPART = NPART + 1		!So, another part.
           IF (STASH(L2:L2).EQ." ") L2 = L2 - 1	!A trailing space trimmed. BORED means at most only one.
           L1 = ISTASH(NSTASH + 1)	!My scratchpad starts after the last stashed text.
           CALL UPCASE(STASH(L1:L2))	!Simplify the text to be a sort key part.
           IF (IENTRY(NENTRY).EQ.NPART) CALL LIBRARIAN	!The first part of an entry?
           PARTT(NPART) = STASHIN(L2)	!Finger the text part.
           PARTI(NPART) = N		!Save the numerical value.
           L2 = ISTASH(NSTASH + 1) - 1	!The text may not have been a newcomer.
           N = 0			!Ready for another number.
         END SUBROUTINE ADDPART	!Always paired, even if no number was found.
         SUBROUTINE LIBRARIAN	!Adjusts names starting "The ..." or "An ..." or "A ...", library style.
          CHARACTER*4 ARTICLE(3)	!By chance, three, by happy chance, lengths 1, 2, 3!
          PARAMETER (ARTICLE = (/"A","AN","THE"/))	!These each have trailing space.
          INTEGER I		!A stepper.
           DO I = 1,3		!So step through the known articles.
             IF (L1 + I.GT.L2) RETURN	!Insufficient text? Give up.
             IF (STASH(L1:L1 + I).EQ.ARTICLE(I)(1:I + 1)) THEN	!Starts with this one?
               STASH(L1:L2 - I - 1) = STASH(L1 + I + 1:L2)	!Yes! Shift the rest back over it.
               STASH(L2 - I:L2 + 1) = ", "//ARTICLE(I)(1:I)	!Place the article at the end.
               L2 = L2 + 1				!One more, for the comma.
               RETURN				!Done!
             END IF			!But if that article didn't match,
           END DO			!Try the next.
         END SUBROUTINE LIBRARIAN	!Ah, catalogue order. Blah, The.
       END FUNCTION ADDENTRY	!That was fun!

       SUBROUTINE SHOWENTRY(BLAH,E)	!Ah, debugging.
        CHARACTER*(*) BLAH	!With distinguishing mark.
        INTEGER E,P		!Entry and part fingering.
        INTEGER L1,L2		!Fingers.
         L1 = ISTASH(TENTRY(E))		!The source text is stashed as text #TENTRY(E).
         L2 = ISTASH(TENTRY(E) + 1) - 1	!ISTASH(i) is where in STASH text #i starts.
         WRITE (MSG,1) BLAH,E,IENTRY(E),IENTRY(E + 1) - 1,STASH(L1:L2)
    1    FORMAT (/,A," Entry(",I0,")=Pt ",I0," to ",I0,", text >",A,"<")
         DO P = IENTRY(E),IENTRY(E + 1) - 1	!Step through the part list.
           L1 = ISTASH(PARTT(P))		!Find the text of the part.
           L2 = ISTASH(PARTT(P) + 1) - 1	!Saved in STASH.
           WRITE (MSG,2) P,PARTT(P),PARTI(P),STASH(L1:L2)	!The text is of variable length,
    2      FORMAT ("Part(",I0,") = text#",I0,", N = ",I0," >",A,"<")	!So present it *after* the number.
         END DO					!On to the next part.
       END SUBROUTINE SHOWENTRY		!Shows entry = <text><number>, <text><number>, ...

       INTEGER FUNCTION ENTRYORDER(E1,E2)	!Report on the order of entries E1 and E2.
Chug through the parts list of the two entries, for each part comparing the text, then the number.
        INTEGER E1,E2		!Finger entries via TENTRY(i) and IENTRY(i)...
        INTEGER T1,T2		!Fingers texts in STASH.
        INTEGER I1,N1,I2,N2	!Fingers and counts.
        INTEGER I,D		!A stepper and a difference.
c         CALL SHOWENTRY("E1",E1)
c         CALL SHOWENTRY("E2",E2)
         P1 = IENTRY(E1)		!Finger the first parts
         P2 = IENTRY(E2)		!Of the two entries.
Compare the text part of the two parts.
   10    T1 = PARTT(P1)		!So, what is the number of the text,
         T2 = PARTT(P2)		!Safely stored in STASH.
         IF (T1.NE.T2) THEN	!Inspect text only if the text parts differ.
           I1 = ISTASH(T1)		!Where its text is stashed.
           N1 = ISTASH(T1 + 1) - I1	!Thus the length of that text.
           I2 = ISTASH(T2)		!First character of the other text.
           N2 = ISTASH(T2 + 1) - I2	!Thus its length.
           DO I = 1,MIN(N1,N2)	!Step along both texts while they have characters to match.
             D = ICHAR(STASH(I2:I2)) - ICHAR(STASH(I1:I1))	!The difference.
             IF (D.NE.0) GO TO 666	!Is there a difference?
             I1 = I1 + 1		!No.
             I2 = I2 + 1		!Advance to the next character for both.
           END DO		!And try again.
Can't compare character pairs beyond the shorter of the two texts.
           D = N2 - N1			!Very well, which text is the shorter?
           IF (D.NE.0) GO TO 666	!No difference in length?
         END IF			!So much for the text comparison.
Compare the numeric part.
         D = PARTI(P2) - PARTI(P1)	!Righto, compare the numeric side.
         IF (D.NE.0) GO TO 666		!A difference here?
Can't find any difference between those two parts.
         P1 = P1 + 1			!Move on to the next part.
         P2 = P2 + 1			!For both entries.
         N1 = IENTRY(E1 + 1) - P1	!Knowing where the next entry's parts start
         N2 = IENTRY(E2 + 1) - P2	!Means knowing where an entry's parts end.
         IF (N1.GT.0 .AND. N2.GT.0) GO TO 10	!At least one for both, so compare the next pair.
         D = N2 - N1			!Thus, the shorter precedes the longer.
Conclusion.
  666    ENTRYORDER = D			!Zero sez "equal".
       END FUNCTION ENTRYORDER	!That was a struggle.

       SUBROUTINE ORDERENTRY(LIST,N)
Crank up a Comb sort of the entries fingered by LIST. Working backwards, just for fun.
Caution: the H*10/13 means that H ought not be INTEGER*2. Otherwise, use H/1.3.
        INTEGER LIST(*)	!This is an index to the items being compared.
        INTEGER T	!In the absence of a SWAP(a,b). Same type as LIST.
        INTEGER N	!The number of entries.
        INTEGER I,H	!Tools. H ought not be a small integer.
        LOGICAL CURSE	!Annoyance.
         H = N - 1		!Last - First, and not +1.
         IF (H.LE.0) RETURN	!Ha ha.
    1    H = MAX(1,H*10/13)	!The special feature.
         IF (H.EQ.9 .OR. H.EQ.10) H = 11	!A twiddle.
         CURSE = .FALSE.	!So far, so good.
         DO I = N - H,1,-1	!If H = 1, this is a BubbleSort.
           IF (ENTRYORDER(LIST(I),LIST(I + H)).LT.0) THEN	!One compare.
             T=LIST(I); LIST(I)=LIST(I+H); LIST(I+H)=T	!One swap.
             CURSE = .TRUE.			!One curse.
           END IF			!One test.
         END DO			!One loop.
         IF (CURSE .OR. H.GT.1) GO TO 1	!Work remains?
       END SUBROUTINE ORDERENTRY

       CHARACTER*44 FUNCTION ENTRYTEXT(E)	!Ad-hoc extraction of an entry's source text.
        INTEGER E	!The desired entry's number.
        INTEGER P	!A stage in the dereferencing.
         P = TENTRY(E)	!Entry E's source text is #P.
         ENTRYTEXT = STASH(ISTASH(P):ISTASH(P + 1) - 1)	!Stashed here.
       END FUNCTION ENTRYTEXT	!Fixed size only, with trailing spaces.

       CHARACTER*44 FUNCTION ENTRYTEXTCHAR(E)	!The same, but with nasty characters defanged.
        USE BADCHARACTER	!Just so.
        INTEGER E		!The desired entry's number.
        INTEGER P		!A stage in the dereferencing.
        CHARACTER*44 TEXT	!A scratchpad, to avoid confusing the compiler.
        INTEGER I,L,H		!Fingers.
        CHARACTER*1 C		!A waystation.
         L = 0			!No text has been extracted.
         P = TENTRY(E)		!Entry E's source text is #P.
         DO I = ISTASH(P),ISTASH(P + 1) - 1	!Step along the stash..
           C = STASH(I:I)	!Grab a character.
           H = INDEX(BADC,C)	!Scan the shit list.
           IF (H.LE.0) THEN	!One of the troublemakers?
             CALL PUT(C)		!No. Just copy it.
            ELSE		!Otherwise,
             CALL PUT("!")		!Place a context changer.
             CALL PUT(GOODC(H:H))	!Place the corresponding mnemonic.
           END IF		!So much for that character.
         END DO			!On to the next.
         ENTRYTEXTCHAR = TEXT(1:MIN(L,44))	!Protect against overflow.
        CONTAINS		!A trivial assistant.
         SUBROUTINE PUT(C)	!But too messy to have in-line.
          CHARACTER*1 C		!The character of the moment.
           L = L + 1			!Advance to place it.
           IF (L.LE.44) TEXT(L:L) = C	!If within range.
         END SUBROUTINE PUT	!Simple enough.
       END FUNCTION ENTRYTEXTCHAR	!On output, the troublemakers make trouble.

       SUBROUTINE ORDERENTRYTEXT(LIST,N)
Crank up a Comb sort of the entries fingered by LIST. Working backwards, just for fun.
Caution: the H*10/13 means that H ought not be INTEGER*2. Otherwise, use H/1.3.
        INTEGER LIST(*)	!This is an index to the items being compared.
        INTEGER T	!In the absence of a SWAP(a,b). Same type as LIST.
        INTEGER N	!The number of entries.
        INTEGER I,H	!Tools. H ought not be a small integer.
        LOGICAL CURSE	!Annoyance.
         H = N - 1		!Last - First, and not +1.
         IF (H.LE.0) RETURN	!Ha ha.
    1    H = MAX(1,H*10/13)	!The special feature.
         IF (H.EQ.9 .OR. H.EQ.10) H = 11	!A twiddle.
         CURSE = .FALSE.	!So far, so good.
         DO I = N - H,1,-1	!If H = 1, this is a BubbleSort.
           IF (ENTRYTEXT(LIST(I)).GT.ENTRYTEXT(LIST(I+H))) THEN	!One compare.
             T=LIST(I); LIST(I)=LIST(I+H); LIST(I+H)=T	!One swap.
             CURSE = .TRUE.			!One curse.
           END IF			!One test.
         END DO			!One loop.
         IF (CURSE .OR. H.GT.1) GO TO 1	!Work remains?
       END SUBROUTINE ORDERENTRYTEXT
      END MODULE COMPOUND	!Accepts, stores, lists and sorts the content.

      PROGRAM MR NATURAL	!Presents a list in sorted order.
      USE COMPOUND		!Stores text in a complicated way.
      USE BADCHARACTER		!Some characters wreck the layout.
      INTEGER I,ITEM(30),PLAIN(30)	!Two sets of indices.
      I = 0	!An array must have equal-length items, so trailing spaces would result.
      I=I+1;ITEM(I) = ADDENTRY("ignore leading spaces: 2-2")
      I=I+1;ITEM(I) = ADDENTRY(" ignore leading spaces: 2-1")
      I=I+1;ITEM(I) = ADDENTRY("  ignore leading spaces: 2+0")
      I=I+1;ITEM(I) = ADDENTRY("   ignore leading spaces: 2+1")
      I=I+1;ITEM(I) = ADDENTRY("ignore m.a.s spaces: 2-2")
      I=I+1;ITEM(I) = ADDENTRY("ignore m.a.s  spaces: 2-1")
      I=I+1;ITEM(I) = ADDENTRY("ignore m.a.s   spaces: 2+0")
      I=I+1;ITEM(I) = ADDENTRY("ignore m.a.s    spaces: 2+1")
      I=I+1;ITEM(I) = ADDENTRY("Equiv."//" "//"spaces: 3-3")
      I=I+1;ITEM(I) = ADDENTRY("Equiv."//CR//"spaces: 3-2")	!CR can't appear as itself.
      I=I+1;ITEM(I) = ADDENTRY("Equiv."//FF//"spaces: 3-1")	!As it is used to mark line endings.
      I=I+1;ITEM(I) = ADDENTRY("Equiv."//VT//"spaces: 3+0")	!And if typed in an editor,
      I=I+1;ITEM(I) = ADDENTRY("Equiv."//LF//"spaces: 3+1")	!It is acted upon there and then.
      I=I+1;ITEM(I) = ADDENTRY("Equiv."//HT//"spaces: 3+2")	!So, name instead of value.
      I=I+1;ITEM(I) = ADDENTRY("cASE INDEPENDENT: 3-2")
      I=I+1;ITEM(I) = ADDENTRY("caSE INDEPENDENT: 3-1")
      I=I+1;ITEM(I) = ADDENTRY("casE INDEPENDENT: 3+0")
      I=I+1;ITEM(I) = ADDENTRY("case INDEPENDENT: 3+1")
      I=I+1;ITEM(I) = ADDENTRY("foo100bar99baz0.txt")
      I=I+1;ITEM(I) = ADDENTRY("foo100bar10baz0.txt")
      I=I+1;ITEM(I) = ADDENTRY("foo1000bar99baz10.txt")
      I=I+1;ITEM(I) = ADDENTRY("foo1000bar99baz9.txt")
      I=I+1;ITEM(I) = ADDENTRY("The Wind in the Willows")
      I=I+1;ITEM(I) = ADDENTRY("The 40th step more")
      I=I+1;ITEM(I) = ADDENTRY("The 39 steps")
      I=I+1;ITEM(I) = ADDENTRY("Wanda")
c      I=I+1;ITEM(I) = ADDENTRY("A Dinosaur Grunts: Fortran Emerges")
c      I=I+1;ITEM(I) = ADDENTRY("The Joy of Text Twiddling with Fortran")
c      I=I+1;ITEM(I) = ADDENTRY("An Aversion to Unused Trailing Spaces")
      WRITE (MSG,*) "nEntry=",NENTRY		!Reach into the compound storage area.
      PLAIN = ITEM				!Copy the list of entries.
      CALL ORDERENTRY(ITEM,NENTRY)		!"Natural" order.
      CALL ORDERENTRYTEXT(PLAIN,NENTRY)		!Plain text order.
      WRITE (MSG,1) "Character","'Natural'"	!Provide a heading.
    1 FORMAT (2("Entry|Text ",A9," Order",24X))	!Usual trickery.
      DO I = 1,NENTRY				!Step through the lot.
        WRITE (MSG,2) PLAIN(I),ENTRYTEXTCHAR(PLAIN(I)),	!Plain order,
     1                ITEM(I), ENTRYTEXTCHAR(ITEM(I))	!Followed by natural order.
    2   FORMAT (2(I5,"|",A44))			!This follows function ENTRYTEXT.
      END DO					!On to the next.
      END	!A handy hint from Mr. Natural: "At home or at work, get the right tool for the job!"
