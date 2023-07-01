      MODULE TEXTGNASH	!Some text inspection.
       CHARACTER*10 DIGITS		!Integer only.
       CHARACTER*11 DDIGITS		!With a full stop masquerading as a decimal point.
       CHARACTER*13 SDDIGITS		!Signed decimal digits.
       CHARACTER*4  EXPONENTISH		!With exponent parts.
       CHARACTER*17 NUMBERISH		!The complete mix.
       CHARACTER*16 HEXLETTERS		!Extended for base sixteen.
       CHARACTER*62 DIGILETTERS		!File nameish but no .
       CHARACTER*26 LITTLELETTERS,BIGLETTERS	!These are well-known.
       CHARACTER*52 LETTERS		!The union thereof.
       CHARACTER*66 NAMEISH		!Allowing digits and . and _ as well.
       CHARACTER*3  ODDITIES		!And allow these in names also.
       CHARACTER*1 CHARACTER(72)	!Prepare a work area.
       EQUIVALENCE			!Whose components can be fingered.
     1  (CHARACTER( 1),EXPONENTISH,NUMBERISH),	!Start with numberish symbols that are not nameish.
     2  (CHARACTER( 5),SDDIGITS),		!Since the sign symbols are not nameish.
     3  (CHARACTER( 7),DDIGITS,NAMEISH),	!Computerish names might incorporate digits and a .
     4  (CHARACTER( 8),DIGITS,HEXLETTERS,DIGILETTERS),	!A proper name doesn't start with a digit.
     5  (CHARACTER(18),BIGLETTERS,LETTERS),	!Just with a letter.
     6  (CHARACTER(44),LITTLELETTERS),		!The second set.
     7  (CHARACTER(70),ODDITIES)		!Tack this on the end.
       DATA EXPONENTISH /"eEdD"/	!These on the front.
       DATA SDDIGITS /"+-.0123456789"/	!Any of these can appear in a floating point number.
       DATA BIGLETTERS    /"ABCDEFGHIJKLMNOPQRSTUVWXYZ"/	!Simple.
       DATA LITTLELETTERS /"abcdefghijklmnopqrstuvwxyz"/	!Subtly different.
       DATA ODDITIES /"_:#"/		!Allow these in names also. This strains := usage!

       CHARACTER*62 GOODEXT	!These are all the characters allowed
       EQUIVALENCE (CHARACTER(8),GOODEXT)	!Starts with the first digit.
       INTEGER MEXT		!A fixed bound.
       PARAMETER (MEXT = 28)	!This is perfect.
       CONTAINS
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

        SUBROUTINE UPCASE(TEXT)	!In the absence of an intrinsic...
Converts any lower case letters in TEXT to upper case...
Concocted yet again by R.N.McLean (whom God preserve) December MM.
Converting from a DO loop evades having both an iteration counter to decrement and an index variable to adjust.
Could use the character code to index an array, instead of searching a sequence...
         CHARACTER*(*) TEXT	!The stuff to be modified.
         INTEGER I,L,IT	!Fingers.
          L = LEN(TEXT)		!Get a local value, in case LEN engages in oddities.
          I = L			!Start at the end and work back..
    1     IF (I.LE.0) RETURN 	!Are we there yet? Comparison against zero should not require a subtraction.
          IT = INDEX(LITTLELETTERS,TEXT(I:I))	!Well?
          IF (IT .GT. 0) TEXT(I:I) = BIGLETTERS(IT:IT)	!One to convert?
          I = I - 1		!Back one.
          GO TO 1		!Inspect..
        END SUBROUTINE UPCASE	!Easy. In EBCDIC, letters are NOT contiguous, and other symbols appear.

        CHARACTER*(MEXT) FUNCTION FEXT(FNAME)	!Return the file extension part.
         CHARACTER*(*) FNAME	!May start with the file's path name blather.
         INTEGER L1,L2		!Fingers to the text.
          L2 = LEN(FNAME)	!The last character of the file name.
          L1 = L2		!Starting at the end...
   10     IF (L1.GT.0) THEN	!Damnit, can't rely on DO WHILE(safe & test)
            IF (FNAME(L1:L1).NE.".") THEN	!So do the two parts explicitly.
              L1 = L1 - 1		!Well, that was a valid character for an extension.
              GO TO 10			!So, move back one and try again.
            END IF		!Until a period is found.
            L1 = L1 - 1		!Here. Thus include the period.
            GO TO 20		!And escape.
          END IF		!Keep on moving back.
          L1 = L2		!If we're here, no period was found.
   20     FEXT = FNAME(L1 + 1:L2)	!The text of the extension.
        END FUNCTION FEXT	!Possibly, blank.

        LOGICAL FUNCTION FOUND(TEXT,LIST)	!Is TEXT found in the LIST?
         CHARACTER*(*) TEXT	!The text.
         CHARACTER*(*) LIST	!A sequence, separated by the periods. Like ".EXE.TXT.etc."
         CHARACTER*(LEN(TEXT)) EXT	!A scratchpad of sufficient size.
          L = LSTNB(TEXT)	!Find its last non-blank.
          IF (L.LE.0) THEN	!A null text?
            FOUND = .FALSE.		!Yep. Can't be in the list.
           ELSE			!Otherwise,
            EXT(1:L) = TEXT(1:L)	!A copy I can damage.
            CALL UPCASE(EXT(1:L))	!Simplify.
            FOUND = INDEX(LIST,EXT(1:L)//".") .GT. 0	!Found somewhere?
          END IF		!The period can't be a character in an extension name.
        END FUNCTION FOUND	!So, possibilities collapse.
      END MODULE TEXTGNASH	!Enough for this.

      PROGRAM POKE
      USE TEXTGNASH
      INTEGER I,LEX,LFN
      INTEGER TESTS
      PARAMETER (TESTS = 12)
      CHARACTER*80 TEST(TESTS)	!A collection.
      CHARACTER*(MEXT) EXT
      DATA TEST/
     1 "Picture.jpg",
     2 "http://mywebsite.com/picture/image.png",
     3 "myuniquefile.longextension",
     4 "IAmAFilenameWithoutExtension",
     5 "/path/to.my/file",
     6 "file.odd_one",
     7 "Mydata.a##",
     8 "Mydata.tar.Gz",
     9 "MyData.gzip",
     o "MyData.7z.backup",
     1 "Mydata...",
     2 "Mydata"/
      CHARACTER*(*) IMAGE	!A sequence of approved texts, delimited by .
      PARAMETER (IMAGE = ".ZIP.RAR.7Z.GZ.ARCHIVE.A##.")	!All in capitals, and ending with a . too.

      WRITE (6,1) IMAGE
    1 FORMAT ("To note file name extensions that are amongst ",A,/
     1 "File name",40X,"Extension",7X,"Test")

      DO I = 1,TESTS	!Step through the candidates.
       LFN = LSTNB(TEST(I))		!Thus do without trailing spaces.
       EXT = FEXT(TEST(I)(1:LFN))	!Grab the file name's extension text.
       LEX = LSTNB(EXT)			!More trailing spaces.
       WRITE (6,2) TEST(I)(1:LFN),EXT(1:LEX),FOUND(EXT(1:LEX),IMAGE)
    2  FORMAT (A48,A16,L)	!Produces tidy columns, aligned right.
      END DO		!On to the next.
      END
