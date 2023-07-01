      SUBROUTINE CROAK(GASP)	!Something bad has happened.
       CHARACTER*(*) GASP	!As noted.
        WRITE (6,*) "Oh dear. ",GASP	!So, gasp away.
        STOP "++ungood."	!Farewell, cruel world.
      END			!No return from this.

      SUBROUTINE FILEHACK(FNAME,IST,N)
       CHARACTER*(*) FNAME	!Name for the file.
       INTEGER IST		!First record to be omitted.
       INTEGER N		!Number of records to be omitted.
       INTEGER ENUFF,L		!Some lengths.
       PARAMETER (ENUFF = 66666)!Surely?
       CHARACTER*(ENUFF) ALINE	!But not in general...
       INTEGER NREC		!A counter.
       INTEGER F,T		!Mnemonics for file unit numbers.
       PARAMETER (F=66,T=67)	!These should do.
       LOGICAL EXIST
        IF (FNAME.EQ."") CALL CROAK("Blank file name!")
        IF (IST.LE.0)    CALL CROAK("First record must be positive!")
        IF (N.LE.0)      CALL CROAK("Remove count must be positive!")
        INQUIRE(FILE = FNAME, EXIST = EXIST)	!This mishap is frequent, so attend to it.
        IF (.NOT.EXIST) CALL CROAK("Can't find a file called "//FNAME)	!Tough love.
        OPEN (F,FILE=FNAME,STATUS="OLD",ACTION="READ",FORM="FORMATTED")	!Grab the source file.
        OPEN (T,STATUS="SCRATCH",FORM="FORMATTED")	!Request a temporary file.
        NREC = 0		!Number of records read so far.
Copy the desired records to a temporary file.
   10   READ (F,11,END = 20) L,ALINE(1:MIN(L,ENUFF))	!Minimal protection.
   11   FORMAT (Q,A)		!Obviously, Q = # of characters to come, A = their format.
        IF (L.GT.ENUFF) CALL CROAK("Ow! Lengthy record!!")
        NREC = NREC + 1		!If we're here. we've read a record.
        IF (NREC.LT.IST .OR. NREC.GE.IST + N) WRITE (T,12) ALINE(1:L)	!A desired record?
   12   FORMAT (A)		!No character count is explicitly specified.
        GO TO 10		!Keep on thumping.
Convert from input to output...
   20   IF (NREC.LT.IST + N) CALL CROAK("Insufficient records!")	!Finished ignoring records?
        REWIND T		!Not CLOSE! That would discard the file!
        CLOSE(F)		!The source file still exists.
        OPEN (F,FILE=FNAME,FORM="FORMATTED",	!But,
     1   ACTION="WRITE",STATUS="REPLACE")	!This dooms it!
Copy from the temporary file.
   21   READ (T,11,END = 30) L,ALINE(1:L)	!All records are not longer than ALINE.
        WRITE (F,12) ALINE(1:L)			!Out it goes.
        GO TO 21		!Keep on thumping.
Completed.
   30   CLOSE(T)		!Abandon the temporary file.
        CLOSE(F)		!Finished with the source file.
      END		!Done.

      PROGRAM CHOPPER
       CALL FILEHACK("foobar.txt",1,2)
      END
