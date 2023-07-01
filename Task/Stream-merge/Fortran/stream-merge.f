      SUBROUTINE FILEMERGE(N,INF,OUTF)	!Merge multiple inputs into one output.
       INTEGER N	!The number of input files.
       INTEGER INF(*)	!Their unit numbers.
       INTEGER OUTF	!The output file.
       INTEGER L(N)	!The length of each current record.
       INTEGER LIST(0:N)!In sorted order.
       LOGICAL LIVE(N)	!Until end-of-file.
       INTEGER ENUFF		!As ever, how long is a piece of string?
       PARAMETER (ENUFF = 666)	!Perhaps this will suffice.
       CHARACTER*(ENUFF) AREC(N)!One for each input file.
       INTEGER I,IT	!Assistants.
        LIST = 0	!LIST(0) fingers the leader.
        LIVE = .TRUE.	!All files are presumed live.
Charge the battery.
        DO I = 1,N	!Taste each.
          CALL GRAB(I)		!By obtaining the first record.
        END DO		!Also, preparing the LIST.
Chug away.
        DO WHILE(LIST(0).GT.0)	!Have we a leader?
          IT = LIST(0)		!Yes. Which is it?
          WRITE (OUTF,"(A)") AREC(IT)(1:L(IT))	!Send it forth.
          LIST(0) = LIST(IT)	!Head to the leader's follower.
          CALL GRAB(IT)		!Get the next candidate.
        END DO			!Try again.

       CONTAINS	!An assistant, called in two places.
        SUBROUTINE GRAB(IN)	!Get another record.
         INTEGER IN		!From this input file.
         INTEGER IT,P		!Linked-list stepping.
          IF (.NOT.LIVE(IN)) RETURN	!No more grist?
          READ (INF(IN),1,END = 10) L(IN),AREC(IN)(1:MIN(ENUFF,L(IN)))	!Burp.
    1     FORMAT (Q,A)		!Q = "length remaining", obviously.
Consider the place of AREC(IN) in the LIST. Entry LIST(IN) is to be linked back in.
          P = 0		!Finger the head of the LIST.
    2     IT = LIST(P)		!Which supplier is fingered?
          IF (IT.GT.0) THEN	!If we're not at the end,
            IF (AREC(IN)(1:L(IN)).GT.AREC(IT)(1:L(IT))) THEN	!Compare.
              P = IT			!The incomer follows this node.
              GO TO 2			!So, move to IT and check afresh.
            END IF		!So much for the comparison.
          END IF	!The record from supplier IN is to precede that from IT, fingered by LIST(P).
          LIST(IN) = IT		!So, IN's follower is IT.
          LIST(P) = IN		!And P's follower is now IN.
          RETURN	!Done.
   10     LIVE(IN) = .FALSE.	!No further input.
          LIST(IN) = -666	!This will cause trouble if accessed.
        END SUBROUTINE GRAB	!Grab input, and jostle for position.
      END SUBROUTINE FILEMERGE	!Simple...

      PROGRAM MASH
      INTEGER MANY
      PARAMETER (MANY = 4)	!Sufficient?
      INTEGER FI(MANY)
      CHARACTER*(28) FNAME(MANY)
      DATA FNAME/"FileAppend.for","FileChop.for",
     1 "FileExt.for","FileHack.for"/
      INTEGER I,F

      F = 10	!Safely past pre-defined unit numbers.
      OPEN (F,FILE="Merged.txt",STATUS="REPLACE",ACTION="WRITE")	!File for output.
      DO I = 1,MANY	!Go for the input files.
        FI(I) = F + I		!Choose another unit number.
        OPEN (FI(I),FILE=FNAME(I),STATUS="OLD",ACTION="READ")	!Hope.
      END DO		!On to the next.

      CALL FILEMERGE(MANY,FI,F)	!E pluribus unum.

      END	!That was easy.
