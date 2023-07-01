      MODULE SAMPLER    !To sample a record from a file.                SAM00100
       CONTAINS                                                         SAM00200
        CHARACTER*20 FUNCTION GETREC(N,F,IS)    !Returns a status.      SAM00300
Careful. Some compilers get confused over the function name's usage.    SAM00400
         INTEGER N              !The desired record number.             SAM00500
         INTEGER F              !Of this file.                          SAM00600
         CHARACTER*(*) IS       !Stashed here.                          SAM00700
         INTEGER I,L            !Assistants.                            SAM00800
          IS = ""               !Clear previous content, even if null...SAM00900
          IF (N.LE.0) THEN      !Start on errors.                       SAM01000
            WRITE (GETREC,1) "!No record",N     !Could never be found.  SAM01100
    1       FORMAT (A,1X,I0)                    !Message, number.       SAM01200
          ELSE IF (F.LE.0) THEN                 !Obviously wrong?       SAM01300
            WRITE (GETREC,1) "!No unit number",F!Positive is valid.     SAM01400
          ELSE IF (LEN(IS).LE.0) THEN           !Space awaits?          SAM01500
            WRITE (GETREC,1) "!String size",LEN(IS)     !Nope.          SAM01600
          ELSE                  !Otherwise, there is hope.              SAM01700
            REWIND (F)          !Clarify the file position.             SAM01800
            DO I = 1,N - 1      !Grind up to the desired record.        SAM01900
              READ (F,2,END=3)  !Ignoring any content.                  SAM02000
            END DO              !Are we there yet?                      SAM02100
            READ (F,2,END = 3) L,IS(1:MIN(L,LEN(IS)))    !At last.      SAM02200
    2       FORMAT (Q,A)        !Q = characters yet unread.             SAM02300
            IF (L.LT.LEN(IS)) IS(L + 1:) = ""   !Clear the tail.        SAM02400
            IF (L.GT.LEN(IS)) THEN              !Now for more silliness.SAM02500
              WRITE (GETREC,1) "+Length",L      !Too long to fit in IS. SAM02600
            ELSE IF (L.LE.0) THEN               !A zero-length record   SAM02700
              WRITE (GETREC,1) "+Null"          !Is not the same        SAM02800
            ELSE IF (IS.EQ."") THEN             !As a record            SAM02900
              WRITE (GETREC,1) "+Blank",L       !Containing spaces.     SAM03000
            ELSE                                !But otherwise,         SAM03100
              WRITE (GETREC,1) " Length",L      !Note the leading space.SAM03200
            END IF              !Righto, we've decided.                 SAM03300
          END IF                !And, no more options.                  SAM03400
          RETURN                !So, done.                              SAM03500
    3     WRITE (GETREC,1) "!End on read",I     !An alternative ending. SAM03600
        END FUNCTION GETREC     !That was interesting.                  SAM03700
      END MODULE SAMPLER        !Just a sample of possibility.          SAM03800
                                                                        SAM03900
      PROGRAM POKE                                                      POK00100
      USE SAMPLER                                                       POK00200
      INTEGER ENUFF     !Some sizes.                                    POK00300
      PARAMETER (ENUFF = 666)   !Sufficient?                            POK00400
      CHARACTER*(ENUFF) STUFF   !Lots of memory these days.             POK00500
      CHARACTER*20 RESULT                                               POK00600
      INTEGER MSG,F     !I/O unit numbers.                              POK00700
      MSG = 6           !Standard output.                               POK00800
      F = 10            !Chooose a unit number.                         POK00900
      WRITE (MSG,*) "      To select record 7 from a disc file."        POK01000
                                                                        POK01100
      WRITE (MSG,*) "As a FORMATTED file."                              POK01200
      OPEN (F,FILE="FileSlurpN.for",STATUS="OLD",ACTION="READ")         POK01300
      RESULT = GETREC(7,F,STUFF)                                        POK01400
      WRITE (MSG,1) "Result",RESULT                                     POK01500
      WRITE (MSG,1) "Record",STUFF                                      POK01600
    1 FORMAT (A,":",A)                                                  POK01700
                                                                        POK01800
      CLOSE (F)                                                         POK01900
      WRITE (MSG,*) "As a random-access unformatted file."              POK02000
      OPEN (F,FILE="FileSlurpN.for",STATUS="OLD",ACTION="READ",         POK02100
     1 ACCESS="DIRECT",FORM="UNFORMATTED",RECL=82)      !Not 80!        POK02200
      STUFF = "Cleared."                                                POK02300
      READ (F,REC = 7,ERR = 666) STUFF(1:80)                            POK02400
      WRITE (MSG,1) "Record",STUFF(1:80)                                POK02500
      STOP                                                              POK02600
  666 WRITE (MSG,*) "Can't get the record!"                             POK02700
      END       !That was easy.                                         POK02800
