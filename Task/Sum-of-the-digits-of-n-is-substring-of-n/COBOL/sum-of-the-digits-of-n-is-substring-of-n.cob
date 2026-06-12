        IDENTIFICATION DIVISION.
        PROGRAM-ID. SUM-SUBSTRING.

        DATA DIVISION.
        WORKING-STORAGE SECTION.
        01 CALCULATION.
           02 N         PIC 9999.
           02 X         PIC 9.
           02 DSUM      PIC 99.
           02 N-DIGITS  REDEFINES N.
              03 ND     PIC 9 OCCURS 4 TIMES.
           02 S-DIGITS  REDEFINES DSUM.
              03 SUMD   PIC 9 OCCURS 2 TIMES.
        01 OUTPUT-FORMAT.
           02 N-OUT     PIC ZZZ9.

        PROCEDURE DIVISION.
        BEGIN.
            PERFORM TESTNUMBER VARYING N FROM 0 BY 1
                    UNTIL N IS EQUAL TO 1000.
            STOP RUN.

        TESTNUMBER SECTION.
        BEGIN.
            PERFORM SUM-DIGITS.
            SET X TO 1.
            IF DSUM IS LESS THAN 10 GO TO ONE-DIGIT-CHECK.

        TWO-DIGIT-CHECK.
            IF X IS GREATER THAN 3 GO TO DONE.
            IF ND(X) = SUMD(1) AND ND(X + 1) = SUMD(2) GO TO SHOW.
            ADD 1 TO X.
            GO TO TWO-DIGIT-CHECK.

        ONE-DIGIT-CHECK.
            IF X IS GREATER THAN 4 GO TO DONE.
            IF ND(X) = SUMD(2) GO TO SHOW.
            ADD 1 TO X.
            GO TO ONE-DIGIT-CHECK.

        SHOW.
            MOVE N TO N-OUT.
            DISPLAY N-OUT.
        DONE. EXIT.

        SUM-DIGITS SECTION.
        BEGIN.
            SET DSUM TO 0.
            SET X TO 1.
        LOOP.
            ADD ND(X) TO DSUM.
            ADD 1 TO X.
            IF X IS LESS THAN 5 GO TO LOOP.
