      MODULE ZhangSuenThinning	!Image manipulation.
       CONTAINS
        SUBROUTINE ZST(DOT)	!Attempts to thin out thick lines.
         INTEGER DOT(:,:)	!The image in an array, rows down the page.
         TYPE PLACE		!This records an array location.
          INTEGER I			!Via its
          INTEGER J			!Indices.
          END TYPE PLACE	!A lot of baggage.
         TYPE(PLACE) WHACK(UBOUND(DOT,DIM = 1)*UBOUND(DOT,DIM = 2))	!Allow a whack for every dot.
         INTEGER WHACKCOUNT	!Counts up those to be wiped out.
         LOGICAL WHACKED	!Notes if any have been.
         INTEGER STEP,I,N,J,M	!Assistants.
         INTEGER D9(9)		!Holds a 3x3 portion.
         INTEGER HIT1(3,2),HIT2(3,2)	!Lists of elements to inspect for certain tests.
         PARAMETER (HIT1 = (/2,6,8, 4,2,6/))	!Two stages.
         PARAMETER (HIT2 = (/4,8,6, 2,4,8/))	!Each with two hit lists.
          N = UBOUND(DOT,DIM = 1)	!Number of rows.
          M = UBOUND(DOT,DIM = 2)	!Number of columns.
Commence a pass.
   10     WHACKED = .FALSE.	!No damage so far.
          DO STEP = 1,2		!Each pass is in two stages.
            WHACKCOUNT = 0	!No dots have been selected for whitewashing.
            DO I = 2,N - 1	!Scan down the rows.
              DO J = 2,M - 1	!And the columns. Interior dots only.
                IF (DOT(I,J).NE.0) THEN	!Rule 0: Is the dot black? Eight neighbours are present due to loop control.
                  D9(1:3) = DOT(I - 1,J - 1:J + 1)	!Yes. Form a 3x3 mesh.	1 2 3  not  9 2 3
                  D9(4:6) = DOT(I    ,J - 1:J + 1)	!As a 1-D array.	4 5 6       8 1 4
                  D9(7:9) = DOT(I + 1,J - 1:J + 1)	!For eased access.	7 8 9       7 6 5
                  CALL INSPECT(D9,HIT1(1,STEP),HIT2(1,STEP))	!Apply rules one to four, as specified.
                END IF			!So much for a black dot.
              END DO		!On to the next column.
            END DO		!On to the next row.
            IF (WHACKCOUNT.GT.0) THEN	!Are any to be wiped out?
              DO I = 1,WHACKCOUNT		!Yes!
                DOT(WHACK(I).I,WHACK(I).J) = 0		!One by one.
              END DO				!On to the next victim.
Can't use     DOT(WHACK(1:WHACKCOUNT).I,WHACK(1:WHACKCOUNT).J) = 0
              WHACKED = .TRUE.			!There has been a change.
            END IF			!So much for changes.
          END DO		!On to the second stage.
          IF (WHACKED) GO TO 10	!If there had been changes, perhaps there will be more.
         CONTAINS	!Some helpers.
          SUBROUTINE INSPECT(BLOB,HIT1,HIT2)	!Inspect a 3x3 piece according to the four levels of tests as specified.
           INTEGER BLOB(9)		!The piece. BLOB(5) is DOT(I,J), and is expected to be 1.
           INTEGER HIT1(3),HIT2(3)	!Two hit lists.
           INTEGER TWIRL(9)		!traces the periphery of the piece.
           PARAMETER (TWIRL = (/2,3,6,9,8,7,4,1,2/))	!Cycle around the periphery.
           INTEGER B	!A counter.			!Rule:
            B = SUM(BLOB) - BLOB(5)			!1: Count the neighbours having one, not zero.
            IF (2 <= B .AND. B <= 6) THEN		!   The test. Can't have 2 <= B <= 6, alas.
              IF (COUNT(BLOB(TWIRL(1:8))		!2: Counting transitions.
     *              .LT.BLOB(TWIRL(2:9))) .EQ.1) THEN	!   The test of 0 --> positive.
                IF (ANY(BLOB(HIT1).EQ.0)) THEN		!3: At least one must be white.
                  IF (ANY(BLOB(HIT2).EQ.0)) THEN	!4: Of two sets of three.
                    WHACKCOUNT = WHACKCOUNT + 1			!Another one down!
                    WHACK(WHACKCOUNT) = PLACE(I,J)		!This is the place.
                  END IF				!Now back out of the nested IF-statements.
                END IF				!Since the tests must all be passed
              END IF			!Rather than say three out of four.
            END IF		!For the given method.
          END SUBROUTINE INSPECT!That was weird.
        END SUBROUTINE ZST	!But so it goes.

        SUBROUTINE SHOW(A)	!Display an image array on the standard output.
         INTEGER A(:,:)		!Values are expected to be zero and one.
         CHARACTER*1 HIC(0:1)	!But I don't want to look at wads of digits.
         PARAMETER (HIC = (/".","#"/))	!These offer better contrast.
         INTEGER I		!A stepper.
         DO I = 1,UBOUND(A,DIM = 1)	!Work down the given number of rows.
           WRITE (6,"(666A1)") HIC(A(I,:))	!Roll a translated line.
         END DO				!Hopefully, no more than 666 to a line.
        END SUBROUTINE SHOW	!That was straightforward.
      END MODULE ZhangSuenThinning

      PROGRAM POKE	!Just set up the example.
      USE ZhangSuenThinning
      INTEGER N,M		!Parameters for the example.
      PARAMETER (N = 10,M = 32)	!Rows and columns.
      CHARACTER*(M) CANVAS(N)	!Rather than some monster DATA statement,
      PARAMETER (CANVAS = (/	!It is easier to prepare a worksheet.
     1 "                                ",
     2 " 111111111       11111111       ",
     3 " 111   1111     1111  1111      ",
     4 " 111    111     111    111      ",
     5 " 111   1111     111             ",
     6 " 111111111      111             ",
     7 " 111 1111       111    111      ",
     8 " 111  1111  111 1111  1111 111  ",
     9 " 111   1111 111  11111111  111  ",
     o "                                "/))
       INTEGER IMAGE(N,M)	!The image array. Exactly the required size.
       INTEGER I		!A stepper.

       DO I = 1,N		!Read the rows.
         READ (CANVAS(I),"(666I1)") IMAGE(I,:)	!Presumably, 666 will suffice.
       END DO			!A blank is taken as a zero with formatted input.

       WRITE (6,*) "The initial image..."
       CALL SHOW(IMAGE)
       WRITE (6,*)

       CALL ZST(IMAGE)
       WRITE (6,*) "And after 'thinning'..."
       CALL SHOW(IMAGE)

      END PROGRAM POKE
