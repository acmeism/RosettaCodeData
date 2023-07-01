      SUBROUTINE CROAK(GASP)	!Something bad has happened.
       CHARACTER*(*) GASP	!As noted.
        WRITE (6,*) "Oh dear. ",GASP	!So, gasp away.
        STOP "++ungood."	!Farewell, cruel world.
      END			!No return from this.

      SUBROUTINE FILEHACK(FNAME,NB)
       CHARACTER*(*) FNAME	!Name for the file.
       INTEGER NB		!Number of bytes to survive.
       INTEGER L		!A counter for te length of the file.
       INTEGER F,T		!Mnemonics for file unit numbers.
       PARAMETER (F=66,T=67)	!These should do.
       LOGICAL EXIST		!Same as the mnemonic so left/right can be forgotten.
       CHARACTER*1 B		!The worker!
        IF (FNAME.EQ."") CALL CROAK("Blank file name!")
        IF (NB.LE.0)     CALL CROAK("Chop must be positive!")
        INQUIRE(FILE = FNAME, EXIST = EXIST)	!This mishap is frequent, so attend to it.
        IF (.NOT.EXIST) CALL CROAK("Can't find a file called "//FNAME)	!Tough love.
        OPEN (F,FILE=FNAME,STATUS="OLD",ACTION="READWRITE",	!Grab the source file.
     1   FORM="UNFORMATTED",RECL=1,ACCESS="DIRECT")		!Oh dear.
        OPEN (T,STATUS="SCRATCH",FORM="UNFORMATTED",RECL=1)	!Request a temporary file.

Copy the desired "records" to the temporary file.
   10   DO L = 1,NB	!Only up to a point.
          READ  (F,REC = L,ERR = 20) B	!One whole byte!
          WRITE (T) B			!And, write it too!
        END DO		!Again.
   20   IF (L.LE.NB) CALL CROAK("Short file!")	!Should end the loop with L = NB + 1.
Convert from input to output...
        REWIND T		!Not CLOSE! That would discard the file!
        CLOSE(F)		!The source file still exists.
        OPEN (F,FILE=FNAME,FORM="FORMATTED",	!But,
     1   ACTION="WRITE",STATUS="REPLACE")	!This dooms it!
Copy from the temporary file.
        DO L = 1,NB	!A certain number only.
          READ  (T) B		!One at at timne.
          WRITE (F,"(A1,$)") B	!The $, obviously, means no end-of-record appendage.
        END DO		!And again.
Completed.
   30   CLOSE(T)	!Abandon the temporary file.
        CLOSE(F)	!Finished with the source file.
      END		!Done.

      PROGRAM CHOPPER
       CALL FILEHACK("foobar.txt",12)
      END
