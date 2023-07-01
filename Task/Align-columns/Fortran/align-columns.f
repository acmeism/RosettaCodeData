      SUBROUTINE RAKE(IN,M,X,WAY)	!Casts forth text in fixed-width columns.
Collates column widths so that each column is wide enough for its widest member.
       INTEGER IN		!Fingers the input file.
       INTEGER M		!Maximum record length thereof.
       CHARACTER*1 X		!The delimiter, possibly a comma.
       INTEGER WAY		!Alignment style.
       INTEGER W(M + 1)		!If every character were X in the maximum-length record,
       INTEGER C(0:M + 1)	!Then M + 1 would be the maximum number of fields possible.
       CHARACTER*(M) ACARD	!A scratchpad big enough for the biggest.
       CHARACTER*(28 + 4*M) FORMAT	!Guess. Allow for "Ann," per field.
       INTEGER I		!A stepper.
       INTEGER L,LF		!Text fingers.
       INTEGER NF,MF		!Field counts.
       CHARACTER*6 WAYNESS(-1:+1)	!Some annotation may be helpful.
       PARAMETER (WAYNESS = (/"Left","Centre","Right"/))	!Using normal language.
       INTEGER LINPR	!The mouthpiece.
       COMMON LINPR	!Used all over.
        W = 0		!Maximum field widths so far seen.
        MF = 0		!Maximum number of fields to a record.
        C(0) = 0	!Syncopation for the first field's predecessor.
        WRITE (LINPR,*)	!Some separation.
        WRITE (LINPR,*) "Align ",WAYNESS(MIN(MAX(WAY,-1),+1))	!Explain, cautiously.

Chase through the file assessing the lengths of each field.
   10   READ (IN,11,END = 20) L,ACARD(1:L)	!Grab a record.
   11   FORMAT (Q,A)				!Working only up to its end.
        CALL LIZZIEBORDEN	!Find the chop points.
        W(1:NF) = MAX(W(1:NF),C(1:NF) - C(0:NF - 1) - 1)	!Thereby the lengths between.
        MF = MAX(MF,NF)		!Also want to know the most number of chops.
        GO TO 10		!Get the next record.

Concoct a FORMAT based on the maximum size of each field. Plus one.
   20   REWIND(IN)		!Back to the beginning.
        WRITE (FORMAT,21) W(1:MF) + 1	!Add one to meet the specified at least one space between columns.
   21   FORMAT ("(",<MF>("A",I0,","))	!Generates a sequence of An, items.
        LF = INDEX(FORMAT,", ")		!The last one has a trailing comma.
        IF (LF.LE.0) STOP "Format trouble!"	!Or, maybe not!
        FORMAT(LF:LF) = ")"			!Convert it to the closing bracket.
        WRITE (LINPR,*) "Format",FORMAT(1:LF)	!Present it.

Chug afresh, this time knowing the maximum length of each field.
   30   READ (IN,11,END = 40) L,ACARD(1:L)	!Place just the record's content.
        CALL LIZZIEBORDEN		!Find the chop points.
        SELECT CASE(WAY)	!What is to be done?
         CASE(-1)		!Shove leftwards by appending spaces.
          WRITE (LINPR,FORMAT) (ACARD(C(I - 1) + 1:C(I) - 1)//	!The chopped text.
     1     REPEAT(" ",W(I) - C(I) + C(I - 1) + 1),I = 1,NF)	!Some spaces.
         CASE( 0)		!Centre by appending half as many spaces.
          WRITE (LINPR,FORMAT) (ACARD(C(I - 1) + 1:C(I) - 1)//	!The chopped text.
     1     REPEAT(" ",(W(I) - C(I) + C(I - 1) + 1)/2),I = 1,NF)	!Some spaces.
         CASE(+1)		!Align rightwards is the default style.
          WRITE (LINPR,FORMAT) (ACARD(C(I - 1) + 1:C(I) - 1),I = 1,NF)	!So, just the texts.
         CASE DEFAULT		!This shouldn't happen.
         WRITE (LINPR,*) "Huh? WAY=",WAY	!But if it does,
         STOP "Unanticipated value for WAY!"	!Explain.
        END SELECT		!So much for that record.
        GO TO 30		!Go for another.
Closedown
   40   REWIND(IN)		!Be polite.
       CONTAINS	!This also marks the end of source for RAKE...
        SUBROUTINE LIZZIEBORDEN	!Take an axe to ACARD, chopping at X.
          NF = 0		!No strokes so far.
          DO I = 1,L		!So, step away.
            IF (ICHAR(ACARD(I:I)).EQ.ICHAR(X)) THEN	!Here?
              NF = NF + 1		!Yes!
              C(NF) = I		!The place!
            END IF		!So much for that.
          END DO		!On to the next.
          NF = NF + 1		!And the end of ACARD is also a chop point.
          C(NF) = L + 1		!As if here.
        END SUBROUTINE LIZZIEBORDEN	!She was aquitted.
      END SUBROUTINE RAKE	!So much raking over.

      INTEGER L,M,N	!To be determined the hard way.
      INTEGER LINPR,IN	!I/O unit numbers.
      COMMON LINPR	!Some of general note.
      LINPR = 6		!Standard output via this unit number.
      IN = 10		!Some unit number for the input file.
      OPEN (IN,FILE="Rake.txt",STATUS="OLD",ACTION="READ")	!For formatted input.
      N = 0		!No records read.
      M = 0		!Longest record so far.

    1 READ (IN,2,END = 10) L	!How long is this record?
    2 FORMAT (Q)	!Obviously, Q specifies the length, not a content field.
      N = N + 1		!Anyway, another record has been read.
      M = MAX(M,L)	!And this is the longest so far.
      GO TO 1		!Go back for more.

   10 REWIND (IN)	!We're ready now.
      WRITE (LINPR,*) N,"Recs, longest rec. length is ",M
      CALL RAKE(IN,M,"$",-1)	!Align left.
      CALL RAKE(IN,M,"$", 0)	!Centre.
      CALL RAKE(IN,M,"$",+1)	!Align right.
      END	!That's all.
