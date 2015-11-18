      MODULE ASSISTANCE
       INTEGER MSG,KBD			!I/O unit numbers.
       DATA MSG,KBD/6,5/		!Output, input.
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
    1    IF (L.LE.0) GO TO 2	!Are we there yet?
         IF (ICHAR(TEXT(L:L)).GT.ICHAR(" ")) GO TO 2	!Control chars are regarded as spaces also.
         L = L - 1		!Step back one.
         GO TO 1		!And try again.
    2    LSTNB = L		!The last non-blank, possibly zero.
        RETURN			!Unsafe to use LSTNB as a variable.
       END FUNCTION LSTNB	!Compilers can bungle it.
      END MODULE ASSISTANCE

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
       CONTAINS
        CHARACTER*44 FUNCTION DEFANG(THIS)	!Ad-hoc text conversion with nasty characters defanged.
         CHARACTER*(*) THIS	!The text.
         CHARACTER*44 TEXT	!A scratchpad, to avoid confusing the compiler.
         INTEGER I,L,H		!Fingers.
         CHARACTER*1 C		!A waystation.
          L = 0			!No text has been extracted.
          DO I = 1,LEN(THIS)	!Step along the stash..
            C = THIS(I:I)	!Grab a character.
            H = INDEX(BADC,C)	!Scan the shit list.
            IF (H.LE.0) THEN	!One of the troublemakers?
              CALL PUT(C)		!No. Just copy it.
             ELSE		!Otherwise,
              CALL PUT("!")		!Place a context changer.
              CALL PUT(GOODC(H:H))	!Place the corresponding mnemonic.
            END IF		!So much for that character.
          END DO			!On to the next.
          DEFANG = TEXT(1:MIN(L,44))	!Protect against overflow.
         CONTAINS		!A trivial assistant.
          SUBROUTINE PUT(C)	!But too messy to have in-line.
           CHARACTER*1 C		!The character of the moment.
            L = L + 1			!Advance to place it.
            IF (L.LE.44) TEXT(L:L) = C	!If within range.
          END SUBROUTINE PUT	!Simple enough.
        END FUNCTION DEFANG	!On output, the troublemakers make trouble.
      END MODULE BADCHARACTER	!They can disrupt layout.

      MODULE COMPOUND	!Stuff to store the text entries, and to sort lists.
       USE ASSISTANCE
       INTEGER LENTRY,NENTRY,MENTRY		!Size information.
       PARAMETER (LENTRY = 66, MENTRY = 666)	!Should suffice.
       INTEGER ENTRYLENGTH(MENTRY)		!Lengths for the entries.
       CHARACTER*(LENTRY) ENTRYTEXT(MENTRY)	!Their texts.
       CHARACTER*(LENTRY) ENTRYKEY(MENTRY)	!Comparison keys.
       CONTAINS		!The details.
       INTEGER FUNCTION ADDENTRY(X)	!Create an entry holding X.
        CHARACTER*(*) X		!The text to be stashed.
        INTEGER L		!It may have trailing space stuff.
         L = LSTNB(X)		!Thus, LEN(X) won't do.
         IF (L.GT.LENTRY) CALL CROAK("Over-long text!")	!Even though any trailing spaces have been lost.
         IF (NENTRY.GE.MENTRY) CALL CROAK("Too many entries!")	!Perhaps I can't.
         NENTRY = NENTRY + 1		!Righto, another one.
         ENTRYTEXT(NENTRY)(1:L) = X(1:L)!Place. Trailing spaces will not be supplied.
         ENTRYLENGTH(NENTRY) = L	!But I won't be looking where they won't be.
         ADDENTRY = NENTRY		!The caller needn't keep count.
       END FUNCTION ADDENTRY	!That was simple.

       INTEGER FUNCTION TEXTORDER(E1,E2)	!Compare the texts as they stand.
        INTEGER E1,E2		!Finger the entries holding the texts.
         IF (ENTRYTEXT(E1)(1:ENTRYLENGTH(E1))	!If the text of entry E1
     1   .LT.ENTRYTEXT(E2)(1:ENTRYLENGTH(E2))) THEN	!Precedes that of E2,
          TEXTORDER = +1				!Then the order is good.
         ELSE IF (ENTRYTEXT(E1)(1:ENTRYLENGTH(E1))	!ENTRYLENGTH means no trailing spaces.
     1   .GT.ENTRYTEXT(E2)(1:ENTRYLENGTH(E2))) THEN	!Accordingly, no "x" = "x " accommodation.
          TEXTORDER = -1				!So, reversed order.
         ELSE					!Otherwise,
          TEXTORDER = 0					!They're equal.
         END IF					!So, decided.
       END FUNCTION TEXTORDER		!Thus use the character collation sequence.

       INTEGER FUNCTION NATURALORDER(E1,E2)	!Compares the texts in "natural" order.
        INTEGER E1,E2		!Pity this couldn't be an array of two values.
        CHARACTER*4 ARTICLE(3)	!By chance, three, by happy chance, lengths 1, 2, 3!
        PARAMETER (ARTICLE = (/"A","AN","THE"/))	!These each have trailing space.
        INTEGER DONE,BORED,GRIST,NUMERIC		!Might as well supply some mnemonics.
        PARAMETER (DONE=-1,BORED=0,GRIST=1,NUMERIC=2)	!For nearly arbitrary integers.
        INTEGER WOT(2)		!Collect the two entry numbers.
        INTEGER L(2),LST(2)	!Scan text with finger L, ending with LST.
        INTEGER N		!Counter for comparisons.
        INTEGER DCOUNT(2)	!Counts the number of digits for L(is) onwards.
        INTEGER STATE(2)	!The scans vary in mood.
        INTEGER TAIL(2)		!The LIBRARIAN may discover an ARTICLE and put it in the TAIL.
        INTEGER D		!A difference.
        CHARACTER*1 C(2)	!Character pairs ascertained one-by-one by ANOTHER.
         WOT(1) = E1		!Alright,
         WOT(2) = E2		!Into an array to play.
         L = 0			!Syncopation to start the scan.
         LST = ENTRYLENGTH(WOT)	!End markers.
         STATE = BORED		!So far, and no matter what the librarian discovers.
         DCOUNT = 0		!Nor have any digits been counted.
         CALL LIBRARIAN		!Assess the start of the texts.
         N = 0			!No comparisons so far.
Chug along the texts, character by character.
   10    CALL ANOTHER		!Grab one from each text.
         N = N + 1		!Count another compare.
         ENTRYKEY(WOT)(N:N) = C	!Place the characters being compared.
         D = ICHAR(C(2)) - ICHAR(C(1))		!Their difference.
         IF (D.NE.0) GO TO 666			!A decision yet?
         L = L + 1				!No. Advance both fingers.
         IF (ANY(STATE.NE.DONE)) GO TO 10	!And try again.
  666    NATURALORDER = D	!The decision.
         RETURN		!Despite the lack of an END, this is the end of the function.
        CONTAINS	!Which however contains some assistants, defined after use.
         SUBROUTINE CRUSH(C)	!Reduces annoying variation.
          CHARACTER*1 C		!The victim.
           IF (C.LE." ") THEN	!Spaceish?
             C = " "			!Yes. Standardise.
            ELSE		!For all others,
             CALL UPCASE(C)		!Simplify.
           END IF		!Righto, ready to compare.
         END SUBROUTINE CRUSH	!This should do the deed in place.

         SUBROUTINE ANOTHER	!The entry's text may be followed by an article in the tail.
Claws along the text strings, looking for the next character pair to report for matching.
          INTEGER IS	!Steps through the two texts.
          INTEGER L2	!A second finger, for probing ahead and the TAIL.
          CHARACTER*1 D	!Potentially a digit character.
        EE:DO IS = 1,2		!Dealing with both texts in the same way.
   10        L2 = L(IS) - LST(IS)	!Compare the finger to the end-of-text.
             IF (L2.GT.0) THEN		!Perhaps we have reached the tail.
               IF (TAIL(IS).GT.0 .AND. L2.LE.TAIL(IS)) THEN	!Yes. What about the possible tail?
                 C(IS) = ARTICLE(TAIL(IS))(L2:L2)	!Still wagging.
                ELSE			!But if no tail (or the tail is exhausted)
                 C(IS) = CHAR(0)	!Empty space.
                 STATE(IS) = DONE	!Declare this.
               END IF			!So much for the librarian's tail.
               CYCLE EE			!On to the next text.
             END IF		!But if we have text yet to scan,
             C(IS) = ENTRYTEXT(WOT(IS))(L(IS):L(IS))	!Grab the character.
             CALL CRUSH(C(IS))				!Simplify.
             IF (C(IS).EQ." ") THEN	!So, what have we received?
               IF (STATE(IS).EQ.BORED) THEN	!A space. Are we ignoring them?
                 L(IS) = L(IS) + 1		!Yes. Advance in hope.
                 GO TO 10			!And try again.
               END IF			!So much for another space.
               STATE(IS) = BORED	!If we weren't in spaces, we are now.
             ELSE IF (C(IS).GE."0" .AND. C(IS).LE."9") THEN	!A digit?
               STATE(IS) = NUMERIC		!Double trouble might ensue.
             ELSE			!For all other characters,
               STATE(IS) = GRIST		!We have grist.
             END IF			!So much for the character.
           END DO EE		!On to the next text.
Comparing digit sequences is to be done as numbers. "007" vs "70" is to become vs. "070" by length matching.
           IF (ALL(STATE.EQ.NUMERIC)) THEN	!If we're comparing a digit to a digit,
             IF (ALL(DCOUNT.EQ.0)) THEN		!I want to align the comparison from the right.
            DD:DO IS = 1,2	!So I need to determine how many digits follow in both.
   20            DCOUNT(IS) = DCOUNT(IS) + 1	!Count one more.
                 L2 = L(IS) + DCOUNT(IS)	!Finger the next position.
                 IF (L2.GT.LST(IS)) CYCLE DD	!If we're off the end, we're done.
                 D = ENTRYTEXT(WOT(IS))(L2:L2)	!Otherwise, grab the character.
                 IF (D.LT."0" .OR. D.GT."9") CYCLE DD	!Not a digit: done counting.
                 GO TO 20			!Otherwise, keep on looking.
               END DO DD		!On to the other text.
             END IF		!Righto, I now know how many digits are in each sequence.
Choose the shorter, and notionally insert a leading zero for it to be matched against the longer's digit..
             IF (DCOUNT(1).LT.DCOUNT(2)) THEN	!Righto, if the first has fewer digits,
               DCOUNT(2) = DCOUNT(2) - 1	!Then only the second's digit will be used up.
               L(1) = L(1) - 1			!Step back to re-encounter this next time.
               C(1) = "0"			!And create a leading zero from nothing.
             ELSE IF (DCOUNT(2).LT.DCOUNT(1)) THEN	!Likewise if the other way around.
               DCOUNT(1) = DCOUNT(1) - 1	!The scan will consume this side's digit.
               L(2) = L(2) - 1			!The next time here (if there is one)
               C(2) = "0"			!Will find a reduced difference in length.
             ELSE		!But if both have the same number of digits remaining,
               DCOUNT = DCOUNT - 1	!They are used in parallel.
             END IF		!Perhaps even equal digit remnants.
           END IF		!Thus, arbitrary-size numbers are allowed, as they're never numbers.
         END SUBROUTINE ANOTHER	!Characters are announced in array C, moods in array STATE.

         SUBROUTINE LIBRARIAN	!Looks for texts starting "The ..." or "An ..." or "A ...", library style.
Checks the starts of the two texts, skipping leading spaceish stuff.
          INTEGER IS,A,I	!Steppers.
          CHARACTER*1 C		!A character to mess with.
        EE:DO IS = 1,2		!Two texts to inspect.
             TAIL(IS) = 0		!Nothing special found.
   10        L(IS) = L(IS) + 1		!Advance one.
             IF (L(IS).GT.LST(IS)) CYCLE EE	!Run out of text?
             IF (ENTRYTEXT(WOT(IS))(L(IS):L(IS)).LE." ") GO TO 10	!Scoot through leading space stuff.
          AA:DO A = 1,3			!Now step through the known articles.
               DO I = 0,A			!Character by character thereof, with one trailing space.
                 IF (L(IS) + I.GT.LST(IS)) CYCLE EE	!Have I a character to probe?
                 C = ENTRYTEXT(WOT(IS))(L(IS) + I:L(IS) + I)	!Yes. Grab it.
                 CALL CRUSH(C)					!Simplify.
                 IF (C.NE.ARTICLE(A)(1 + I:1 + I)) CYCLE AA	!Mismatch? Try another.
               END DO				!On to the next character of ARTICLE(A).
               TAIL(IS) = A		!A match!
               L(IS) = L(IS) + I	!Finger the first character after the space.
               CYCLE EE			!Finished with this text. Also, BORED.
             END DO AA			!Try the next article..
           END DO EE			!Try the next text.
         END SUBROUTINE LIBRARIAN	!Ah, catalogue order. Blah, The.
       END FUNCTION NATURALORDER	!Not natural to a computer.

       SUBROUTINE ORDERENTRY(LIST,N,WOTORDER)	!Sorts the list according to the ordering function.
Crank up a Comb sort of the entries fingered by LIST. Working backwards, just for fun.
Caution: the H*10/13 means that H ought not be INTEGER*2. Otherwise, use H/1.3.
        INTEGER LIST(*)		!This is an index to the items being compared.
        INTEGER T		!In the absence of a SWAP(a,b). Same type as LIST.
        INTEGER N		!The number of entries.
        EXTERNAL WOTORDER	!A function to compare two entries.
        INTEGER WOTORDER	!Returns an integer result, on principle.
        INTEGER I,H		!Tools. H ought not be a small integer.
        LOGICAL CURSE		!Annoyance.
         H = N - 1		!Last - First, and not +1.
         IF (H.LE.0) RETURN	!Ha ha.
    1    H = MAX(1,H*10/13)	!The special feature.
         IF (H.EQ.9 .OR. H.EQ.10) H = 11	!A twiddle.
         CURSE = .FALSE.	!So far, so good.
         DO I = N - H,1,-1	!If H = 1, this is a BubbleSort.
           IF (WOTORDER(LIST(I),LIST(I + H)) .LT. 0) THEN	!One compare.
             T=LIST(I); LIST(I)=LIST(I+H); LIST(I+H)=T	!One swap.
             CURSE = .TRUE.			!One curse.
           END IF			!One test.
         END DO			!One loop.
         IF (CURSE .OR. H.GT.1) GO TO 1	!Work remains?
       END SUBROUTINE ORDERENTRY!Fast enough, and simple.
      END MODULE COMPOUND	!Enough.

      PROGRAM MR NATURAL	!Presents a list in sorted order.
      USE ASSISTANCE		!Often needed.
      USE COMPOUND		!Deals with text in a complicated way.
      USE BADCHARACTER		!Some characters wreck the layout.
      INTEGER ITEM(30),FANCY(30)!Two sets of indices.
      INTEGER I,IT,TI		!Assistants.
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
c      I=I+1;ITEM(I) = ADDENTRY("An Abundance of Storage Enables Waste")
c      I=I+1;ITEM(I) = ADDENTRY("Theory Versus Practice: The Chasm")
      WRITE (MSG,*) "nEntry=",NENTRY	!Reach into the compound storage area.
      FANCY = ITEM			!Copy the list of entries.
      ENTRYKEY = ""			!To be written to by NATURALORDER.
      CALL ORDERENTRY(FANCY,NENTRY,NATURALORDER)	!"Natural" order.
      CALL ORDERENTRY(ITEM,NENTRY,TEXTORDER)		!Plain text order.
      WRITE (MSG,1) "Character","'Natural'","N.Key"	!Provide a heading.
    1 FORMAT (3("Entry|Text ",A9," Order",16X))	!Usual trickery.
      DO I = 1,NENTRY	!Step through the lot.
        IT = ITEM(I)		!Saving on some typing.
        TI = FANCY(I)		!Presenting two lists, line by line.
        WRITE (MSG,2) IT,DEFANG(ENTRYTEXT(IT)(1:ENTRYLENGTH(IT)))	!Plain order,
     1               ,TI,DEFANG(ENTRYTEXT(TI)(1:ENTRYLENGTH(TI)))	!Followed by natural order.
     2               ,TI,ENTRYKEY(TI)	!Already defanged.
    2   FORMAT (3(I5,"|",A36))			!This follows function ENTRYTEXT.
      END DO		!On to the next.
      END	!A handy hint from Mr. Natural: "At home or at work, get the right tool for the job!"
