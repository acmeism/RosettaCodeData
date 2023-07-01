      MODULE PARAMETERS	!Assorted oddities that assorted routines pick and choose from.
       CHARACTER*5 I AM		!Assuage finicky compilers.
       PARAMETER (IAM = "Gnash")	!I AM!
       INTEGER		LUSERCODE	!One day, I'll get around to devising some string protocol.
       CHARACTER*28	USERCODE		!I'm not too sure how long this can be.
       DATA		USERCODE,LUSERCODE/"",0/!Especially before I have a text.
      END MODULE PARAMETERS

      MODULE ASSISTANCE
      CONTAINS	!Assorted routines that seem to be of general use but don't seem worth isolating..
      Subroutine Croak(Gasp)	!A dying message, when horror is suddenly encountered.
Casts out some final words and STOP, relying on the SubInOut stuff to have been used.
Cut down from the full version of April MMI, that employed the SubIN and SubOUT protocol..
       Character*(*) Gasp	!The last gasp.
       COMMON KBD,MSG
       WRITE (MSG,1) GASP
    1  FORMAT ("Oh dear! ",A)
       STOP "I STOP now. Farewell..."	!Whatever pit I was in, I'm gone.
      End Subroutine Croak	!That's it.

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
       CHARACTER*2 FUNCTION I2FMT(N)	!These are all the same.
        INTEGER*4 N			!But, the compiler doesn't offer generalisations.
         IF (N.LT.0) THEN	!Negative numbers cop a sign.
           IF (N.LT.-9) THEN	!But there's not much room left.
             I2FMT = "-!"	!So this means 'overflow'.
            ELSE			!Otherwise, room for one negative digit.
             I2FMT = "-"//CHAR(ICHAR("0") - N)	!Thus. Presume adjacent character codes, etc.
           END IF		!So much for negative numbers.
         ELSE IF (N.LT.10) THEN	!Single digit positive?
           I2FMT = " " //CHAR(ICHAR("0") + N)	!Yes. This.
         ELSE IF (N.LT.100) THEN	!Two digit positive?
           I2FMT = CHAR(N/10      + ICHAR("0"))	!Yes.
     1            //CHAR(MOD(N,10) + ICHAR("0")) !These.
         ELSE			!Otherwise,
           I2FMT = "+!" 	!Positive overflow.
         END IF			!So much for that.
       END FUNCTION I2FMT	!No WRITE and FORMAT unlimbering.
       CHARACTER*8 FUNCTION I8FMT(N)	!Oh for proper strings.
        INTEGER*4 N
        CHARACTER*8 HIC
         WRITE (HIC,1) N
    1    FORMAT (I8)
         I8FMT = HIC
       END FUNCTION I8FMT
       CHARACTER*42 FUNCTION ERRORWORDS(IT)	!Look for an explanation. One day, the system may offer coherent messages.
Curious collection of encountered codes. Will they differ on other systems?
Compaq's compiler was taken over by unintel; http://software.intel.com/sites/products/documentation/hpc/compilerpro/en-us/fortran/lin/compiler_f/bldaps_for/common/bldaps_rterrs.htm
contains a schedule of error numbers that matched those I'd found for Compaq, and so some assumptions are added.
Copying all (hundreds!) is excessive; these seem possible for the usage so far made of error diversion.
Compaq's compiler interface ("visual" blah) has a help offering, which can provide error code information.
Compaq messages also appear in http://cens.ioc.ee/local/man/CompaqCompilers/cf/dfuum028.htm#tab_runtime_errors
Combines IOSTAT codes (file open, read etc) with STAT codes (allocate/deallocate) as their numbers are distinct.
Completeness and context remains a problem. Excess brevity means cause and effect can be confused.
        INTEGER IT			!The error code in question.
        INTEGER LASTKNOWN 		!Some codes I know about.
        PARAMETER (LASTKNOWN = 26)	!But only a few, discovered by experiment and mishap.
        TYPE HINT			!For them, I can supply a table.
         INTEGER	CODE		!The code number. (But, different systems..??)
         CHARACTER*42	EXPLICATION	!An explanation. Will it be the answer?
        END TYPE HINT			!Simple enough.
        TYPE(HINT) ERROR(LASTKNOWN)	!So, let's have a collection.
        PARAMETER (ERROR = (/		!With these values.
     1   HINT(-1,"End-of-file at the start of reading!"),	!From examples supplied with the Compaq compiler involving IOSTAT.
     2   HINT( 0,"No worries."),			!Apparently the only standard value.
     3   HINT( 9,"Permissions - read only?"),
     4   HINT(10,"File already exists!"),
     5   HINT(17,"Syntax error in NameList input."),
     6   HINT(18,"Too many values for the recipient."),
     7   HINT(19,"Invalid naming of a variable."),
     8   HINT(24,"Surprise end-of-file during read!"),	!From example source.
     9   HINT(25,"Invalid record number!"),
     o   HINT(29,"File name not found."),
     1   HINT(30,"Unavailable - exclusive use?"),
     2   HINT(32,"Invalid fileunit number!"),
     3   HINT(35,"'Binary' form usage is rejected."),	!From example source.
     4   HINT(36,"Record number for a non-existing record!"),
     5   HINT(37,"No record length has been specified."),
     6   HINT(38,"I/O error during a write!"),
     7   HINT(39,"I/O error during a read!"),
     8   HINT(41,"Insufficient memory available!"),
     9   HINT(43,"Malformed file name."),
     o   HINT(47,"Attempting a write, but read-only is set."),
     1   HINT(66,"Output overflows single record size."),	!This one from experience.
     2   HINT(67,"Input demand exceeds single record size."),	!These two are for unformatted I/O.
     3   HINT(151,"Can't allocate: already allocated!"),	!These different numbers are for memory allocation failures.
     4   HINT(153,"Can't deallocate: not allocated!"),
     5   HINT(173,"The fingered item was not allocated!"),	!Such as an ordinary array that was not allocated.
     6   HINT(179,"Size exceeds addressable memory!")/))
        INTEGER I		!A stepper.
         DO I = LASTKNOWN,1,-1	!So, step through the known codes.
           IF (IT .EQ. ERROR(I).CODE) GO TO 1	!This one?
         END DO			!On to the next.
    1    IF (I.LE.0) THEN	!Fail with I = 0.
           ERRORWORDS = I8FMT(IT)//" is a novel code!"	!Reveal the mysterious number.
          ELSE			!But otherwise, it is found.
           ERRORWORDS = ERROR(I).EXPLICATION	!And these words might even apply.
         END IF			!But on all systems?
       END FUNCTION ERRORWORDS	!Hopefully, helpful.
      END MODULE ASSISTANCE

      MODULE LOGORRHOEA
       CONTAINS
        SUBROUTINE ECART(TEXT)	!Produces trace output with many auxiliary details.
         CHARACTER*(*) TEXT	!The text to be annotated.
         COMMON KBD,MSG		!I/O units.
          WRITE (MSG,1) TEXT	!Just roll the text.
    1     FORMAT ("Trace: ",A)	!Lacks the names of the invoking routine, and that which invoked it.
        END SUBROUTINE ECART
       SUBROUTINE WRITE(OUT,TEXT,ON)	!We get here in the end. Cast forth some pearls.
C   Once upon a time, there was just confusion between ASCII and EBCDIC character codes and glyphs,
c after many variant collections caused annoyance. Now I see that modern computing has introduced
c many new variations, so that one text editor may display glyphs differing from those displayed
c by another editor and also different from those displayed when a programme writes to the screen
c in "teletype" mode, which is to say, employing the character/glyph combination of the moment.
c And in particular, decimal points and degree symbols differ and annoyance has grown.
c   So, on re-arranging SAY to not send output to multiple distinations depending on the value of OUT,
c except for the special output to MSG that is echoed to TRAIL, it became less messy to make an assault
c on the text that goes to MSG, but after it was sent to TRAIL. I would have preferred to fiddle the
c "code page" for text output that determines what glyph to show for which code, but not only
c is it unclear how to do this, even if facilities were available, I suspect that the screen display
c software only loads the mysterious code page during startup.
c   This fiddling means that any write to MSG should be done last, and writes of text literals
c should not include characters that will be fiddled, as text literals may be protected against change.
C   Somewhere along the way, the cent character (¢) has disappeared. Perhaps it will return in "unicode".
        USE ASSISTANCE		!But might still have difficulty.
        INTEGER OUT		!The destination.
        CHARACTER*(*) TEXT	!The message. Possibly damaged. Any trailing spaces will be sent forth.
        LOGICAL ON		!Whether to terminate the line... TRUE sez that someone will be carrying on.
        INTEGER IOSTAT		!Furrytran gibberish.
c        INCLUDE "cIOUnits.for"	!I/O unit numbers.
        COMMON KBD,MSG
c        INTEGER*2,SAVE:: I Be	!Self-identification.
c         CALL SUBIN("Write",I Be)	!Hullo!
         IF (OUT.LE.0) GO TO 999	!Goodbye?
c         IF (IOGOOD(OUT)) THEN	!Is this one in good heart?
c           IF (IOCOUNT(OUT).LE.0 .AND. OUT.NE.MSG) THEN	!Is it attached to a file?
c             IF (IONAME(OUT).EQ."") IONAME(OUT) = "Anome"	!"No name".
c     1         //I2FMT(OUT)//".txt"	!Clutch at straws.
c             IF (.NOT.OPEN(OUT,IONAME(OUT),"REPLACE","WRITE")) THEN	!Just in time?
c               IOGOOD(OUT) = .FALSE.	!No! Strangle further usage.
c               GO TO 999		!Can't write, so give up!
c             END IF			!It might be better to hit the WRITE and fail.
c           END IF		!We should be ready now.
c           IF (OUT.EQ.MSG .AND. SCRAGTEXTOUT) CALL SCRAG(TEXT)	!Output to the screen is recoded for the screen.
           IF (ON) THEN		!Now for the actual output at last. This is annoying.
             WRITE (OUT,1,ERR = 666,IOSTAT = IOSTAT) TEXT	!Splurt.
    1        FORMAT (A,$)	!Don't move on to a new line. (The "$"! Is it not obvious?)
c             IOPART(OUT) = IOPART(OUT) + 1	!Thus count a part-line in case someone fusses.
            ELSE		!But mostly, write and advance.
             WRITE (OUT,2,ERR = 666,IOSTAT = IOSTAT) TEXT	!Splurt.
    2        FORMAT (A)		!*-style "free" format chops at 80 or some such.
           END IF		!So much for last-moment dithering.
c           IOCOUNT(OUT) = IOCOUNT(OUT) + 1	!Count another write (whole or part) so as to be not zero..
c         END IF			!So much for active passages.
c  999    CALL SUBOUT("Write")	!I am closing.
  999   RETURN			!Done.
Confusions.
  666    IF (OUT.NE.MSG) CALL CROAK("Can't write to unit "//I2FMT(OUT)	!Why not?
c     1    //" (file "//IONAME(OUT)(1:LSTNB(IONAME(OUT)))	!Possibly, no more disc space! In which case, this may fail also!
     2    //") message "//ERRORWORDS(IOSTAT)			!Hopefully, helpful.
     3    //" length "//I8FMT(LEN(TEXT))//", this: "//TEXT)	!The instigation.
        STOP "Constipation!"	!Just so.
       END SUBROUTINE WRITE	!The moving hand having writ, moves on.

       SUBROUTINE SAY(OUT,TEXT)	!And maybe a copy to the trail file as well.
        USE PARAMETERS		!Odds and ends.
        USE ASSISTANCE		!Just a little.
        INTEGER OUT		!The orifice.
        CHARACTER*(*) TEXT	!The blather. Can be modified if to MSG and certain characters are found.
        CHARACTER*120 IS	!For a snatched question.
        INTEGER L		!A finger.
c        INCLUDE "cIOUnits.for"	!I/O unit numbers.
        COMMON KBD,MSG
c        INTEGER*2,SAVE:: I Be	!Self-identification.
c         CALL SUBIN("Say",I Be)	!Me do be Me, I say!
Chop off trailing spaces.
         L = LEN(TEXT)		!What I say may be rather brief.
    1    IF (L.GT.0) THEN	!So, is there a last character to look at?
           IF (ICHAR(TEXT(L:L)).LE.ICHAR(" ")) THEN	!Yes. Is it boring?
             L = L - 1			!Yes! Trim it!
             GO TO 1			!And check afresh.
           END IF		!A DO-loop has overhead with its iteration count as well.
         END IF			!Function LEN_TRIM copies the text first!!
Contemplate the disposition of TEXT(1:L)
c         IF (OUT.NE.MSG) THEN	!Normal stuff?
           CALL WRITE(OUT,TEXT(1:L),.FALSE.)	!Roll.
c          ELSE			!Echo what goes to MSG to the TRAIL file.
c           CALL WRITE(TRAIL,TEXT(1:L),.FALSE.)	!Thus.
c           CALL WRITE(  MSG,TEXT(1:L),.FALSE.)	!Splot to the screen.
c           IF (.NOT.BLABBERMOUTH) THEN		!Do we know restraint?
c             IF (IOCOUNT(MSG).GT.BURP) THEN	!Yes. Consider it.
c               WRITE (MSG,100) IOCOUNT(MSG)	!Alas, triggered. So remark on quantity,
c  100          FORMAT (//I9," lines! Your spirit might flag."	!Hint. (Not copied to the TRAIL file)
c     1          /," Type quit to set GIVEOVER to TRUE, with hope for "
c     2           ,"a speedy palliation,",
c     3          /,"   or QUIT to abandon everything, here, now",
c     4          /,"   or blabber to abandon further restraint,",
c     5          /,"   or anything else to carry on:")
c               IS = REPLY("QUIT, quit, blabber or continue")	!And ask.
c               IF (IS.EQ."QUIT") CALL CROAK("Enough of this!")	!No UPDATE, nothing.
c               CALL UPCASE(IS)		!Now we're past the nice distinction, simplify.
c               IF (IS.EQ."QUIT") GIVEOVER = .TRUE.	!Signal to those who listen.
c               IF (IS.EQ."BLABBER") BLABBERMOUTH = .TRUE.	!Well?
c               IF (GIVEOVER) WRITE (MSG,101)			!Announce hope.
c  101          FORMAT ("Let's hope that the babbler notices...")	!Like, IF (GIVEOVER) GO TO ...
c               IF (.NOT.GIVEOVER) WRITE (MSG,102)	!Alternatively, firm resolve.
c  102          FORMAT("Onwards with renewed vigour!")	!Fight the good fight.
c               BURP = IOCOUNT(MSG) + ENOUGH	!The next pause to come.
c             END IF			!So much for last-moment restraint.
c           END IF			!So much for restraint.
c         END IF			!So much for selection.
c         CALL SUBOUT("Say")	!I am merely the messenger.
       END SUBROUTINE SAY	!Enough said.
       SUBROUTINE SAYON(OUT,TEXT)	!Roll to the screen and to the trail file as well.
C This differs by not ending the line so that further output can be appended to it.
        USE ASSISTANCE
        INTEGER OUT		!The orifice.
        CHARACTER*(*) TEXT	!The blather.
        INTEGER L		!A finger.
c        INCLUDE "cIOUnits.for"	!I/O unit numbers.
        COMMON KBD,MSG
c        INTEGER*2,SAVE:: I Be	!Self-identification.
c         CALL SUBIN("SayOn",I Be)	!Me do be another. Me, I say on!
         L = LEN(TEXT)			!How much say I on?
    1    IF (L.GT.0) THEN		!I say on anything?
           IF (ICHAR(TEXT(L:L)).LE.ICHAR(" ")) THEN	!I end it spaceish?
             L = L - 1				!Yes. Trim such.
             GO TO 1				!And look afresh.
           END IF			!So much for trailing off.
         END IF			!Continue with L fingering the last non-blank.
c         IF (OUT.EQ.MSG) CALL WRITE(TRAIL,TEXT(1:L),.TRUE.)	!Writes to the screen go also to the TRAIL.
                         CALL WRITE(  OUT,TEXT(1:L),.TRUE.)	!It is said, and more is expected.
c         CALL SUBOUT("SayOn")	!I am merely the messenger.
       END SUBROUTINE SAYON	!And further messages impend.

      END MODULE LOGORRHOEA

      MODULE HTMLSTUFF	!Assists with the production of decorated output.
Can't say I think much of the scheme. How about <+blah> ... <-blah> rather than the assymetric <blah> ... </blah>?
Cack-handed comment format as well...
       USE PARAMETERS	!To ascertain who I AM.
       USE ASSISTANCE	!To get at LSTNB.
       USE LOGORRHOEA	!To get at SAYON and SAY.
       INTEGER INDEEP,HOLE	!I keep track of some details.
       PRIVATE INDEEP,HOLE	!Amongst myselves.
       DATA INDEEP,HOLE/0,0/	!Initially, I'm not doing anything.
Choose amongst output formats.
       INTEGER LASTFILETYPENAME		!Certain file types are recognised.
       PARAMETER (LASTFILETYPENAME = 2)	!Thus, three options.
       INTEGER OUTTYPE,OUTTXT,OUTCSV,OUTHTML	!The recognition.
       CHARACTER*5 OUTSTYLE,FILETYPENAME(0:LASTFILETYPENAME)	!Via the tail end of a file name.
       PARAMETER (FILETYPENAME = (/".txt",".CSV",".HTML"/))	!Thusly. Note that WHATFILETYPE will not recognise ".txt" directly.
       PARAMETER (OUTTXT = 0,OUTCSV = 1,OUTHTML = 2)	!Mnemonics.
       DATA OUTSTYLE/""/	!So OUTTYPE = OUTTXT. But if an output file is specified, its file type will be inspected.
       TYPE HTMLMNEMONIC	!I might as well get systematic, as these are global names.
        CHARACTER* 9 COMMAH		!This looks like a comma
        CHARACTER* 9 COMMAD		!And in another context, so does this.
        CHARACTER* 6 SPACE		!Some spaces are to be atomic.
        CHARACTER*18 RED		!Decoration and
        CHARACTER* 7 DER		!noitaroceD.
       END TYPE HTMLMNEMONIC	!That's enough for now.
       TYPE(HTMLMNEMONIC) HTMLA	!I'll have one set, please.
       PARAMETER (HTMLA = HTMLMNEMONIC(	!With these values.
     1  "</th><th>",			!But .html has its variants. For a heading.
     2  "</td><td>",			!For a table datum.
     3  "&nbsp;",			!A space that is not to be split.
     4  '<font color="red">',		!Dabble in decoration.
     5  '</font>'))			!Grrrr. A font is for baptismal water.
      CONTAINS	!Mysterious assistants.
       SUBROUTINE HTML(TEXT)	!Rolls some text, with suitable indentation.
        CHARACTER*(*) TEXT	!The text.
c        INCLUDE "cIOUnits.for"	!I/O unit numbers.
         IF (LEN(TEXT).LE.0) RETURN	!Possibly boring.
         IF (INDEEP.GT.0) THEN		!Some indenting desired?
           CALL WRITE(HOLE,REPEAT(" ",INDEEP),.TRUE.)	!Yep. SAYON trims trailing spaces.
c           IF (HOLE.EQ.MSG) CALL WRITE(TRAIL,REPEAT(" ",INDEEP),.TRUE.)	!So I must copy.
         END IF			!Enough indenting.
         CALL SAY(HOLE,TEXT)	!Say the piece and end the line.
       END SUBROUTINE HTML	!Maintain stacks? Check entry/exit matching?

       SUBROUTINE HTML3(HEAD,BUMF,TAIL)	!Rolls some text, with suitable indentation.
Checks the BUMF for decimal points only. HTMLALINE handles text to HTML for troublesome characters, replacing them with special names for the desired glyph.
Confusion might arise, if & is in BUMF and is not to be converted. "&amp;" vs "&so on"; similar worries with < and >.
        CHARACTER*(*) HEAD	!If not "", the start of the line, with indentation supplied.
        CHARACTER*(*) BUMF	!The main body of the text.
        CHARACTER*(*) TAIL	!If not "", this is for the end of the line.
        INTEGER LB,L1,L2	!A length and some fingers for scanning.
        CHARACTER*1 MUMBLE	!These symbols may not be presented properly.
        CHARACTER*8 MUTTER	!But these encodements may be interpreted as desired.
        PARAMETER (MUMBLE = "·")	!I want certain glyphs, but encodement varies.
        PARAMETER (MUTTER = "&middot;")	!As does recognition.
c        INCLUDE "cIOUnits.for"	!I/O unit numbers.
        COMMON KBD,MSG
Commence with a new line?
         IF (HEAD.NE."") THEN	!Is a line to be started? (Spaces are equivalent to "" as well)
           IF (INDEEP.GT.0) THEN	!Some indentation is good.
             CALL WRITE(HOLE,REPEAT(" ",INDEEP),.TRUE.)	!Yep. SAYON trims trailing spaces.
c             IF (HOLE.EQ.MSG) CALL WRITE(TRAIL,	!So I must copy for the log.
c     1        REPEAT(" ",INDEEP),.TRUE.)	!Hopefully, not generated a second time.
            ELSE			!The accountancy may be bungled.
             CALL ECART("HTML huh? InDeep="//I8FMT(INDEEP))	!So, complain.
           END IF			!Also, REPEAT has misbehaved.
           CALL SAYON(HOLE,HEAD)	!Thus a suitable indentation.
         END IF			!So much for a starter.
Cast forth the bumf. Any trailing spaces will be dropped by SAYON.
         LB = LEN(BUMF)		!How much bumf? Trailing spaces will be rolled.
         L1 = 1			!Waiting to be sent.
         L2 = 0			!Syncopation.
    1    L2 = L2 + 1		!Advance to the next character to be inspected..
         IF (L2.GT.LB) GO TO 2	!Is there another?
         IF (ICHAR(BUMF(L2:L2)).NE.ICHAR(MUMBLE)) GO TO 1	!Yes. Advance through the untroublesome.
         IF (L1.LT.L2) THEN		!A hit. Have any untroubled ones been passed?
           CALL WRITE(HOLE,BUMF(L1:L2 - 1),.TRUE.)	!Yes. Send them forth.
c           IF (HOLE.EQ.MSG) CALL WRITE(TRAIL,BUMF(L1:L2 - 1),.TRUE.)	!With any trailing spaces included.
         END IF				!Now to do something in place of BUMF(L2)
         L1 = L2 + 1			!Moving the marker past it, like.
         CALL SAYON(HOLE,MUTTER)	!The replacement for BUMF(L2 as was).
         GO TO 1		!Continue scanning.
    2    IF (L2.GT.L1) THEN	!Any tail end, but not ending the output line.
           CALL WRITE(HOLE,BUMF(L1:L2 - 1),.TRUE.)	!Yes. Away it goes.
c           IF (HOLE.EQ.MSG) CALL WRITE(TRAIL,BUMF(L1:L2 - 1),.TRUE.)	!And logged.
         END IF				!So much for the bumf.
Consider ending the line.
    3    IF (TAIL.NE."") CALL SAY(HOLE,TAIL)	!Enough!
       END SUBROUTINE HTML3	!Maintain stacks? Check entry/exit matching?

       SUBROUTINE HTMLSTART(OUT,TITLE,DESC)	!Roll forth some gibberish.
        INTEGER OUT		!The mouthpiece, mentioned once only at the start, and remembered for future use.
        CHARACTER*(*) TITLE	!This should be brief.
        CHARACTER*(*) DESC	!This a little less brief.
        CHARACTER*(*) METAH	!Some repetition.
        PARAMETER (METAH = '<Meta Name="')	!The syntax is dubious.
        CHARACTER*8 D		!YYYYMMDD
        CHARACTER*10 T		!HHMMSS.FFF
         HOLE = OUT		!Keep a local copy to save on parameters.
         INDEEP = 0		!We start.
         CALL HTML('<!DOCTYPE HTML PUBLIC "'	!Before we begin, we wave hands.
     1    //'-//W3C//DTD HTML 4.01 Transitional//EN"'	!Otherwise "nowrap" is objected to, as in http://validator.w3.org/check
     2    //' "http://www.w3.org/TR/html4/loose.dtd">')	!Endless blather.
         CALL HTML('<HTML lang="en-NZ">')	!  H E R E   W E   G O !
         INDEEP = 1				!Its content.
         CALL HTML("<Head>")			!And the first decoration begins.
         INDEEP = 2				!Its content.
         CALL HTML("<Title>"//I AM//" "	!This appears in the web page tag.
     1    // TITLE(1:LSTNB(TITLE)) //"</Title>")!So it should be short.
         CALL HTML('<Meta http-equiv="Content-Type"'	!Crazed gibberish.
     1    //' content="text/html; charset=utf-8">') 		!But said to be worthy.
         CALL HTML(METAH//'Description" Content="'//DESC//'">')	!Hopefully, helpful.
         CALL HTML(METAH//'Generator"   Content="'//I AM//'">')	!I said.
         CALL DATE_AND_TIME(DATE = D,TIME = T)			!Not assignments, but attachments.
         CALL HTML(METAH//'Created"     Content="'		!Convert the timestamp
     1    //D(1:4)//"-"//D(5:6)//"-"//D(7:8)			!Into an international standard.
     2    //" "//T(1:2)//":"//T(3:4)//":"//T(5:10)//'">')	!For date and time.
         IF (LUSERCODE.GT.0) CALL HTML(METAH			!Possibly, the user's code is known.
     1    //'Author"      Content="'//USERCODE(1:LUSERCODE)	!If so, reveal.
     2    //'"> <!-- User code as reported by GetLog.-->')	!Disclaiming responsibility...
         INDEEP = 1		!Finishing the content of the header.
         CALL HTML("</Head>")	!Enough of that.
         CALL HTML("<BODY>")	!A fresh line seems polite.
         INDEEP = 2		!Its content follows..
       END SUBROUTINE HTMLSTART	!Others will follow on. Hopefully, correctly.
       SUBROUTINE HTMLSTOP	!And hopefully, this will be a good closure.
Could be more sophisticated and track the stack via INDEEP+- and names, to enable a desperate close-off if INDEEP is not 2.
         IF (INDEEP.NE.2) CALL ECART("Misclosure! InDeep not 2 but"	!But,
     1    //I8FMT(INDEEP))	!It may not be.
         INDEEP = 1		!Retreat to the first level.
         CALL HTML("</BODY>")	!End the "body".
         INDEEP = 0		!Retreat to the start level.
         CALL HTML("</HTML>")	!End the whole thing.
       END SUBROUTINE HTMLSTOP	!Ah...

       SUBROUTINE HTMLTSTART(B,SUMMARY)	!Start a table.
        INTEGER B		!Border thickness.
        CHARACTER*(*) SUMMARY	!Some well-chosen words.
         CALL HTML("<Table border="//I2FMT(B)	!Just so. Text digits, or, digits in text?
     1    //' summary="'//SUMMARY//'">')	!Not displayed, but potentially used by non-display agencies...
         INDEEP = INDEEP + 1		!Another level dug.
       END SUBROUTINE HTMLTSTART!That part was easy.
       SUBROUTINE HTMLTSTOP	!And the ending is easy too.
         INDEEP = INDEEP - 1		!Withdraw a level.
         CALL HTML("</Table>")		!Hopefully, aligning.
       END SUBROUTINE HTMLTSTOP	!The bounds are easy.

       SUBROUTINE HTMLTHEADSTART	!Start a table's heading.
         CALL HTML("<tHead>")		!Thus.
         INDEEP = INDEEP + 1		!Dig deeper.
       END SUBROUTINE HTMLTHEADSTART	!Content should follow.
       SUBROUTINE HTMLTHEADSTOP		!And now, enough.
         INDEEP = INDEEP - 1		!Retreat a level.
         CALL HTML("</tHead>")		!And end the head.
       END SUBROUTINE HTMLTHEADSTOP	!At the neck of the body?

       SUBROUTINE HTMLTHEAD(N,TEXT)	!Cast forth a whole-span table heading.
        INTEGER N		!The count of columns to be spanned.
        CHARACTER*(*) TEXT	!A brief description to place there.
         CALL HTML3("<tr><th colspan=",I8FMT(N)//' align="center">',"")	!Start the specification.
         CALL HTML3("",TEXT(1:LSTNB(TEXT)),"</th></tr>")	!This text, possibly verbose.
       END SUBROUTINE HTMLTHEAD		!Thus, all contained on one line.

       SUBROUTINE HTMLTBODYSTART	!Start on the table body.
         CALL HTML('<tBody> <!--Profuse "align" usage '	!Simple, but I'm unhappy.
     1    //'for all cells can be factored out to "row" '	!Alas, so far as I can make out.
     2    //'but not to "body"-->')		!And I don't think much of the "comment" formalism, either.
         INDEEP = INDEEP + 1	!Anyway, we're ready with the alignment.
       END SUBROUTINE HTMLTBODYSTART	!Others will provide the body.
       SUBROUTINE HTMLTBODYSTOP	!And, they've had enough.
         INDEEP = INDEEP - 1		!So, up out of the hole.
         CALL HTML("</tBody>")		!Take a breath.
       END SUBROUTINE HTMLTBODYSTOP	!And wander off.
       SUBROUTINE HTMLTROWTEXT(TEXT,N)	!Roll a row of column headings.
        CHARACTER*(*) TEXT(:)	!The headings.
        INTEGER N		!Their number.
        INTEGER I,L		!Assistants.
         CALL HTML3("<tr>","","")	!Start a row of headings-to-come, and don't end the line.
         DO I = 1,N			!Step through the headings.
           L = LSTNB(TEXT(I))		!Trailing spaces are to be ignored.
           IF (L.LE.0) THEN		!Thus discovering blank texts.
             CALL HTML3("","<th>&nbsp;</th>","")	!This prevents the cell being collapsed.
            ELSE				!But for those with text,
             CALL HTML3("","<th>"//TEXT(I)(1:L)//"</th>","")	!Roll it.
           END IF			!So much for that text.
         END DO				!On to the next.
         CALL HTML3("","","</tr>")	!Finish the row, and thus the line.
       END SUBROUTINE HTMLTROWTEXT	!So much for texts.
       SUBROUTINE HTMLTROWINTEGER(V,N)	!Now for all integers.
        INTEGER V(:)	!The integers.
        INTEGER N	!Their number.
        INTEGER I	!A stepper.
         CALL HTML3('<tr align="right">',"","")	!Start a row of entries.
         DO I = 1,N			!Work through the row's values.
           CALL HTML3("","<td>"//I8FMT(V(I))//"</td>","")	!One by one.
         END DO				!On to the next.
         CALL HTML3("","","</tr>")	!Finish the row, and thus the line.
       END SUBROUTINE HTMLTROWINTEGER	!All the same type is not troublesome.
      END MODULE HTMLSTUFF	!Enough already.

      PROGRAM MAKETABLE
      USE PARAMETERS
      USE ASSISTANCE
      USE HTMLSTUFF
      INTEGER KBD,MSG
      INTEGER NCOLS		!The usage of V must conform to this!
      PARAMETER (NCOLS = 4)	!Specified number of columns.
      CHARACTER*3 COLNAME(NCOLS)	!And they have names.
      PARAMETER (COLNAME = (/"","X","Y","Z"/))	!As specified.
      INTEGER V(NCOLS)		!A scratchpad for a line's worth.
      COMMON KBD,MSG		!I/O units.
      KBD = 5			!Keyboard.
      MSG = 6			!Screen.
      CALL GETLOG(USERCODE)		!Who has poked me into life?
      LUSERCODE = LSTNB(USERCODE)	!Ah, text gnashing.

      CALL HTMLSTART(MSG,"Powers","Table of integer powers")		!Output to the screen will do.
       CALL HTMLTSTART(1,"Successive powers of successive integers")	!Start the table.
        CALL HTMLTHEADSTART						!The table heading.
         CALL HTMLTHEAD(NCOLS,"Successive powers")			!A full-width heading.
         CALL HTMLTROWTEXT(COLNAME,NCOLS)				!Headings for each column.
        CALL HTMLTHEADSTOP						!So much for the heading.
        CALL HTMLTBODYSTART						!Now for the content.
        DO I = 1,10		!This should be enough.
          V(1) = I		!The unheaded row number.
          V(2) = I**2		!Its square.
          V(3) = I**3		!Cube.
          V(4) = I**4		!Fourth power.
          CALL HTMLTROWINTEGER(V,NCOLS)					!Show a row's worth..
        END DO			!On to the next line.
        CALL HTMLTBODYSTOP						!No more content.
       CALL HTMLTSTOP							!End the table.
      CALL HTMLSTOP
      END
