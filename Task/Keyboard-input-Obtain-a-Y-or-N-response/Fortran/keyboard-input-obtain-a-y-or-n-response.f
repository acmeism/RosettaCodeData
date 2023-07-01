      CHARACTER*120 FUNCTION REPLY(QUERY)    !Obtain a text in reply.
Concocted by R.N.McLean (whom God preserve), December MM.
       CHARACTER*(*) QUERY	!The question.
       CHARACTER*120 TEXT	!Alas, oh for proper strings.
       INTEGER MSG,KEYS,LSTNB	!Let's hope everyone has the same type.
       COMMON /IOUNITS/ MSG,KEYS!Orifices.
        WRITE (MSG,1) QUERY(1:LSTNB(QUERY)),"?"!So, splurt.
    1   FORMAT (2A,$)		!A trailing text literal may not be rolled.
        READ (KEYS,1) TEXT	!Dare not use REPLY itself. Some implementations bungle.
        REPLY = TEXT		!So, shuffle.
       RETURN			!Take that.
      END 			!Others interpret the reply.

      REAL*8 FUNCTION REPLYN(QUERY)	!Obtain a number in reply.
Concocted by R.N.McLean (whom God preserve), December MM.
       CHARACTER*(*) QUERY	!The question.
       REAL X			!The answer, presumably not 42.
       INTEGER MSG,KEYS,LSTNB	!Let's hope everyone has the same type.
       COMMON /IOUNITS/ MSG,KEYS!Orifices.
    1   WRITE (MSG,2) QUERY(1:LSTNB(QUERY))	!No trailing spaces.
    2   FORMAT (A,$)		!The $ obviously suppresses the newline.
        READ (KEYS,*,ERR = 3) X	!Presume adequate testing for now.
        REPLYN = X		!The value!
       RETURN			!All done.
    3   WRITE (MSG,4)		!Or perhaps not.
    4   FORMAT ('Distasteful number. Try again...')	!All sorts of ways.
        GO TO 1			!My patience is unconditional.
      END			!One way or another, a number will be secured.

      LOGICAL FUNCTION YEA(QUERY)	!Obtain a Yes in reply?
Concocted by R.N.McLean (whom God preserve), December MM.
       CHARACTER*(*) QUERY	!The question.
       CHARACTER*120 WHAT,REPLY	!Quite so.
       CHARACTER*1 C		!Scratchpad.
       INTEGER MSG,KEYS		!Let's hope everyone has the same type.
       COMMON /IOUNITS/ MSG,KEYS!Orifices.
       INTEGER L		!A finger.
    1   WHAT = REPLY(QUERY)	!So, get an answer.
        DO L = 1,LEN(WHAT)	!Sigh. Oh for Trim(string)
          C = WHAT(L:L)		!Sniff a CHARACTER.
          IF (C .NE. ' ') GO TO 10	!A starter?
        END DO			!No. Try further on.
        WRITE (MSG,2)		!Surely not.
    2   FORMAT ('All blank?')	!Poke.
    3   WRITE (MSG,4) 		!Sigh.
    4   FORMAT ('I dig it not. Try Yes/Si/Da/Oui/Ja, or No')
        GO TO 1			!Get it right, this time?
   10   IF (INDEX('YySsDdOoJj',C) .GT. 0) THEN	!Yes/Si/Da/Oui/Ja...
          YEA = .TRUE.		!A decision.
        ELSE IF (INDEX('Nn',C) .GT. 0) THEN	!No,No,Nyet,Non...
          YEA = .FALSE.		!Even if negative.
        ELSE			!But if unrecognised,
          GO TO 3		!Try again.
        END IF			!So much for choices.
       RETURN			!Pass the word.
      END			!Enough of yes-beings.
      LOGICAL FUNCTION NAY(QUERY)	!Perhaps this reads better.
Concocted by R.N.McLean (whom God preserve), December MM.
       CHARACTER*(*) QUERY	!The question.
       LOGICAL YEA		!Let us hope so.
        NAY = .NOT.YEA(QUERY)	!Straightforward.
       RETURN			!Pass the inverted word.
      END			!So much for naysayers.
