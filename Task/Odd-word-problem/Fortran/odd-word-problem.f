      MODULE ELUDOM	!Uses the call stack for auxiliary storage.
       INTEGER MSG,INF	!I/O unit numbers.
       LOGICAL DEFER	!To stumble, or not to stumble.
       CONTAINS
        CHARACTER*1 RECURSIVE FUNCTION GET(IN)	!Returns one character, going forwards.
         INTEGER IN	!The input file.
         CHARACTER*1 C	!The single character to be read therefrom.
          READ (IN,1,ADVANCE="NO",EOR=3,END=4) C	!Thus. Not advancing to the next record.
    1     FORMAT (A1,$)	!For output, no advance to the next line either.
    2     IF (("A"<=C .AND. C<="Z").OR.("a"<=C .AND. C<="z")) THEN	!Unsafe for EBCDIC.
            IF (DEFER) THEN	!Are we to reverse the current text?
              GET = GET(IN)	!Yes. Go for the next letter.
              WRITE (MSG,1) C	!And now, backing out, reveal the letter at this level.
              RETURN		!Retreat another level.
            END IF		!Thus passing back the ending non-letter that was encountered.
           ELSE		!And if we've encountered a non-letter,
            DEFER = .NOT. DEFER	!Then our backwardness flips.
          END IF	!Enough inspection of C.
    3     GET = C	!Pass it back.
          RETURN	!And we're done.
    4     GET = CHAR(0)	!Reserving this for end-of-file.
        END FUNCTION GET!That was strange.
      END MODULE ELUDOM	!But as per the specification.

      PROGRAM CONFUSED	!Just so.
      USE ELUDOM	!Forwards? Backwards?
      CHARACTER*1 C	!A scratchpad for multiple inspections.
      MSG = 6	!Standard output.
      INF = 10	!This will do.
      OPEN (INF,NAME = "Confused.txt",STATUS="OLD",ACTION="READ")	!Go for the file.

Chew through the input. A full stop marks the end.
   10 DEFER = .FALSE.	!Start off going forwards.
   11 C = GET(INF)		!Get some character from file INF.
      IF (ICHAR(C).LE.0) STOP		!Perhaps end-of-file is reported.
      IF (C.NE." ") WRITE (MSG,12) C	!Otherwise, write it. A blank for end-of-record.
   12 FORMAT (A1,$)			!Obviously, not finishing the line each time.
      IF (C.NE.".") GO TO 11	!And if not a full stop, do it again.
      WRITE (MSG,"('')")	!End the line of output.
      GO TO 10		!And have another go.
      END	!That was confusing.
