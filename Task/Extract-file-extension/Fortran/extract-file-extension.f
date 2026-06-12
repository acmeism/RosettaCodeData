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
       EQUIVALENCE (CHARACTER(8),GOODEXT)
c       PARAMETER (GOODEXT = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"	!for an approved
c     1                    //"abcdefghijklmnopqrstuvwxyz"	!file "extension" part
c     2                    //"0123456789")			!Of a file name.
       INTEGER MEXT		!A fixed bound.
       PARAMETER (MEXT = 28)	!This should do.
       CONTAINS
        CHARACTER*(MEXT) FUNCTION FEXT(FNAME)	!Return the file extension part.
         CHARACTER*(*) FNAME	!May start with the file's path name blather.
         INTEGER L1,L2		!Fingers to the text.
          L2 = LEN(FNAME)	!The last character of the file name.
          L1 = L2		!Starting at the end...
   10     IF (L1.GT.0) THEN	!Damnit, can't rely on DO WHILE(safe & test)
            IF (INDEX(GOODEXT,FNAME(L1:L1)).GT.0) THEN	!So do the two parts explicitly.
              L1 = L1 - 1		!Well, that was a valid character for an extension.
              GO TO 10			!So, move back one and try again.
            END IF		!Until the end of valid stuff.
            IF (FNAME(L1:L1).EQ.".") THEN	!Stopped here. A proper introduction?
              L1 = L1 - 1			!Yes. Include the period.
              GO TO 20				!And escape.
            END IF		!Otherwise, not valid stuff.
          END IF		!Keep on moving back.
          L1 = L2		!If we're here, no period was found.
   20     FEXT = FNAME(L1 + 1:L2)	!The text of the extension.
        END FUNCTION FEXT	!Possibly, blank.
      END MODULE TEXTGNASH	!Enough for this.

      PROGRAM POKE
      USE TEXTGNASH

      WRITE (6,*) FEXT("Picture.jpg")
      WRITE (6,*) FEXT("http://mywebsite.com/picture/image.png")
      WRITE (6,*) FEXT("myuniquefile.longextension")
      WRITE (6,*) FEXT("IAmAFileWithoutExtension")
      WRITE (6,*) FEXT("/path/to.my/file")
      WRITE (6,*) FEXT("file.odd_one")
      WRITE (6,*)
      WRITE (6,*) "Now for the new test collection..."
      WRITE (6,*) FEXT("http://example.com/download.tar.gz")
      WRITE (6,*) FEXT("CharacterModel.3DS")
      WRITE (6,*) FEXT(".desktop")
      WRITE (6,*) FEXT("document")
      WRITE (6,*) FEXT("document.txt_backup")
      WRITE (6,*) FEXT("/etc/pam.d/login")
      WRITE (6,*) "Approved characters: ",GOODEXT
      END
