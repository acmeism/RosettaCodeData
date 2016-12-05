      SUBROUTINE FILEHACK(FNAME,THIS,THAT)	!Attacks a file!
       CHARACTER*(*) FNAME	!The name of the file, presumed to contain text.
       CHARACTER*(*) THIS	!The text sought in each record.
       CHARACTER*(*) THAT	!Its replacement, should it be found.
       INTEGER F,T		!Mnemonics for file unit numbers.
       PARAMETER (F=66,T=67)	!These should do.
       INTEGER L		!A length
       CHARACTER*6666 ALINE	!Surely sufficient?
       LOGICAL AHIT		!Could count them, but no report is called for.
        INQUIRE(FILE = FNAME, EXIST = AHIT)	!This mishap is frequent, so attend to it.
        IF (.NOT.AHIT) RETURN			!Nothing can be done!
        OPEN (F,FILE=FNAME,STATUS="OLD",ACTION="READWRITE")	!Grab the source file.
        OPEN (T,STATUS="SCRATCH")	!Request a temporary file.
        AHIT = .FALSE.		!None found so far.
Chew through the input, replacing THIS by THAT while writing to the temporary file..
   10   READ (F,11,END = 20) L,ALINE(1:MIN(L,LEN(ALINE)))	!Grab a record.
        IF (L.GT.LEN(ALINE)) STOP "Monster record!"		!Perhaps unmanageable.
   11   FORMAT (Q,A)		!Obviously, Q = length of characters unread in the record.
        L1 = 1			!Start at the start.
   12   L2 = INDEX(ALINE(L1:L),THIS)	!Look from L1 onwards.
        IF (L2.LE.0) THEN		!A hit?
          WRITE (T,13) ALINE(L1:L)	!No. Finish with the remainder of the line.
   13     FORMAT (A)			!Thus finishing the output line.
          GO TO 10			!And try for the next record.
        END IF				!So much for not finding THIS.
   14   L2 = L1 + L2 - 2	!Otherwise, THIS is found, starting at L1.
        WRITE (T,15) ALINE(L1:L2)	!So roll the text up to the match, possibly none.
   15   FORMAT (A,$)			!But not ending the record.
        WRITE (T,15) THAT		!Because THIS is replaced by THAT.
        AHIT = .TRUE.			!And we've found at least one match.
        L1 = L2 + LEN(THIS) + 1		!Finger the first character beyond the matching THIS.
        IF (L - L1 + 1 .GE. LEN(THIS)) GO TO 12	!Might another search succeed?
        WRITE (T,13) ALINE(L1:L)	!Nope. Finish the line with the tail end.
        GO TO 10		!And try for another record.
Copy the temporary file back over the source file. Hope for no mishap and data loss!
   20   IF (AHIT) THEN	!If there were no hits, there is nothing to do.
          CLOSE (F)		!Oh well.
          REWIND T		!Go back to the start.
          OPEN (F,FILE="new"//FNAME,STATUS = "REPLACE",ACTION = "WRITE")	!Overwrite...
   21     READ (T,11,END = 22) L,ALINE(1:MIN(L,LEN(ALINE)))	!Grab a line.
          IF (L.GT.LEN(ALINE)) STOP "Monster changed record!"	!Once you start checking...
          WRITE (F,13) ALINE(1:L) 		!In case LEN(THAT) > LEN(THIS)
          GO TO 21			!Go grab the next line.
        END IF		!So much for the replacement of the file.
   22   CLOSE(T)	!Finished: it will vanish.
        CLOSE(F)	!Hopefully, the buffers will be written.
      END	!So much for that.

      PROGRAM ATTACK
      INTEGER N
      PARAMETER (N = 6)		!More than one, anyway.
      CHARACTER*48 VICTIM(N)	!Alternatively, the file names could be read from a file
      DATA VICTIM/		!Along with the target and replacement texts in each case.
     1 "StaffStory.txt",
     2 "Accounts.dat",
     3 "TravelAgent.txt",
     4 "RemovalFirm.dat",
     5 "Addresses.txt",
     6 "SongLyrics.txt"/	!Invention flags.

      DO I = 1,N	!So, step through the list.
        CALL FILEHACK(VICTIM(I),"Goodbye London!","Hello New York!")	!One by one.
      END DO		!On to the next.

      END
