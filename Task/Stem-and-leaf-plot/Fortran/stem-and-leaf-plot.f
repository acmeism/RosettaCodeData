      SUBROUTINE COMBSORT(A,N)
       INTEGER A(*)	!The array.
       INTEGER N	!The count.
       INTEGER H,T	!Assistants.
       LOGICAL CURSE
        H = N - 1		!Last - First, and not +1.
    1   H = MAX(1,H*10/13)	!The special feature.
        IF (H.EQ.9 .OR. H.EQ.10) H = 11	!A twiddle.
        CURSE = .FALSE.		!So far, so good.
        DO I = N - H,1,-1	!If H = 1, this is a BubbleSort.
          IF (A(I) .GT. A(I + H)) THEN	!One compare.
            T=A(I); A(I)=A(I+H); A(I+H)=T	!One swap.
            CURSE = .TRUE.			!One curse.
          END IF			!One test.
        END DO			!One loop.
        IF (CURSE .OR. H.GT.1) GO TO 1	!Work remains?
      END SUBROUTINE COMBSORT	!Good performance, small code.

      SUBROUTINE TOPIARY(A,N)	!Produces a "stem&leaf" display for the integers in A, damaging A.
       INTEGER A(*)		!An array of integers.
       INTEGER N		!Their number.
       INTEGER CLIP		!Semi-generalisation.
       PARAMETER (CLIP = 10)	!Or at least, annotation.
       INTEGER I1,I2,STEM	!Assistants.
        CALL COMBSORT(A,N)	!Rearrange the array!
        STEM = A(1)/CLIP	!The first stem value.
        I1 = 1			!The first stem's span starts here.
        I2 = I1			!And so far as I know, ends here.
   10   I2 = I2 + 1			!Probe ahead one position.
        IF (I2 .GT. N) GO TO 11		!Off the end? Don't look!
        IF (A(I2)/CLIP .EQ.STEM) GO TO 10	!Still in the same stem? Probe on.
Cast forth a STEM line, corresponding to elements I1:I2 - 1.
   11   WRITE (6,12) STEM,ABS(MOD(A(I1:I2 - 1),CLIP))	!ABS: MOD with negatives can be unexpected.
   12   FORMAT (I4,"|",(100I1))		!Layout. If more than a hundred, starts a new line.
        IF (I2 .GT. N) RETURN		!Are we there yet?
        I1 = I2				!No. This is my new span's start.
Chug along to the next STEM value.
   13   STEM = STEM + 1			!Advance to the next stem.
        IF (A(I2)/CLIP.GT.STEM) GO TO 11!Has the stem reached the impending value?
        GO TO 10			!Yes. Scan its span.
      END SUBROUTINE TOPIARY	!The days of carefully-arranged output.

      PROGRAM TEST
      INTEGER VALUES(121)	!The exact number of values.
      DATA VALUES/		!As in the specified example.
     o  12,127, 28, 42, 39,113, 42, 18, 44,118,	!A regular array
     1  44, 37,113,124, 37, 48,127, 36, 29, 31,	!Makes counting easier.
     2 125,139,131,115,105,132,104,123, 35,113,
     3 122, 42,117,119, 58,109, 23,105, 63, 27,
     4  44,105, 99, 41,128,121,116,125, 32, 61,
     5  37,127, 29,113,121, 58,114,126, 53,114,
     6  96, 25,109,  7, 31,141, 46, 13, 27, 43,
     7 117,116, 27,  7, 68, 40, 31,115,124, 42,
     8 128, 52, 71,118,117, 38, 27,106, 33,117,
     9 116,111, 40,119, 47,105, 57,122,109,124,
     o 115, 43,120, 43, 27, 27, 18, 28, 48,125,
     1 107,114, 34,133, 45,120, 30,127, 31,116,
     2 146/
        CALL TOPIARY(VALUES,121)
      END
