      SUBROUTINE UNBLOCK(THIS,THAT)	!Removes block comments bounded by THIS and THAT.
Copies from file INF to file OUT, record by record, except skipping null output records.
       CHARACTER*(*) THIS,THAT	!Starting and ending markers.
       INTEGER LOTS			!How long is a piece of string?
       PARAMETER (LOTS = 6666)		!This should do.
       CHARACTER*(LOTS) ACARD,ALINE	!Scratchpads.
       INTEGER LC,LL,L		!Lengths.
       INTEGER L1,L2		!Scan fingers.
       INTEGER NC,NL		!Might as well count records read and written.
       LOGICAL BLAH		!A state: in or out of a block comment.
       INTEGER MSG,KBD,INF,OUT		!I/O unit numbers.
       COMMON /IODEV/MSG,KBD,INF,OUT	!Thus.
        NC = 0		!No cards read in.
        NL = 0		!No lines written out.
        BLAH = .FALSE.	!And we're not within a comment.
Chug through the input.
   10   READ(INF,11,END = 100) LC,ACARD(1:MIN(LC,LOTS))	!Yum.
   11   FORMAT (Q,A)		!Sez: how much remains (Q), then, characters (A).
        NC = NC + 1		!A card has been read.
        IF (LC.GT.LOTS) THEN	!Paranoia.
          WRITE (MSG,12) NC,LC,LOTS	!Scream.
   12     FORMAT ("Record ",I0," has length ",I0,"! My limit is ",I0)
          LC = LOTS			!Stay calm, and carry on.
        END IF			!None of this should happen.
Chew through ACARD according to mood.
        LL = 0		!No output yet.
        L2 = 0		!Syncopation. Where the previous sniff ended.
   20   L1 = L2 + 1	!The start of what we're looking at.
        IF (L1.LE.LC) THEN	!Anything left?
          L2 = L1		!Yes. This is the probe.
          IF (BLAH) THEN	!So, what's our mood?
   21       IF (L2 + LEN(THAT) - 1 .LE. LC) THEN	!We're skipping stuff.
              IF (ACARD(L2:L2 + LEN(THAT) - 1).EQ.THAT) THEN	!An ender yet?
                BLAH = .FALSE.		!Yes!
                L2 = L2 + LEN(THAT) - 1	!Finger its final character.
                GO TO 20		!And start a new advance.
              END IF		!But if that wasn't an ender,
              L2 = L2 + 1	!Advance one.
              GO TO 21		!And try again.
            END IF	!By here, insufficient text remains to match THAT, so we're finished with ACARD.
           ELSE		!Otherwise, if we're not in a comment, we're looking at grist.
   22       IF (L2 + LEN(THIS) - 1 .LE. LC) THEN	!Enough text to match a comment starter?
              IF (ACARD(L2:L2 + LEN(THIS) - 1).EQ.THIS) THEN	!Yes. Does it?
                BLAH = .TRUE.		!Yes!
                L = L2 - L1		!Recalling where this state started.
                ALINE(LL + 1:LL + L) = ACARD(L1:L2 - 1)	!Copy the non-BLAH text.
                LL = LL + L		!L2 fingers the first of THIS.
                L2 = L2 + LEN(THIS) - 1	!Finger the last matching THIS.
                GO TO 20		!And resume.
              END IF		!But if that wasn't a comment starter,
              L2 = L2 + 1	!Advance one.
              GO TO 22		!And try again.
            END IF	!But if there remains insufficient to match THIS
            L = LC - L1 + 1	!Then the remainder of the line is grist.
            ALINE(LL + 1:LL + L) = ACARD(L1:LC)	!So grab it.
            LL = LL + L		!And count it in.
          END IF	!By here, we're finished witrh ACARD.
        END IF	!So much for ACARD.
Cast forth some output.
        IF (LL.GT.0) THEN	!If there is any.
          WRITE (OUT,23) ALINE(1:LL)	!There is.
   23     FORMAT (">",A,"<") 		!Just text, but with added bounds.
          NL = NL + 1			!Count a line.
        END IF        		!So much for output.
        GO TO 10	!Perhaps there is some more input.
Completed.
  100   WRITE (MSG,101) NC,NL	!Be polite.
  101   FORMAT (I0," read, ",I0," written.")
      END       !No attention to context, such as quoted strings.

      PROGRAM TEST
      INTEGER MSG,KBD,INF,OUT
      COMMON /IODEV/MSG,KBD,INF,OUT
      KBD = 5
      MSG = 6
      INF = 10
      OUT = 11
      OPEN (INF,FILE="Source.txt",STATUS="OLD",ACTION="READ")
      OPEN (OUT,FILE="Src.txt",STATUS="REPLACE",ACTION="WRITE")

      CALL UNBLOCK("/*","*/")

      END	!All open files are closed on exit..
