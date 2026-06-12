        IDENTIFICATION DIVISION.
        PROGRAM-ID. DIV-BY-DGTS-BUT-NOT-PROD.

        DATA DIVISION.
        WORKING-STORAGE SECTION.
        01 CALCULATION.
           02 N             PIC 9(4).
           02 DGT-PROD      PIC 9(3).
           02 NSTART        PIC 9.
           02 D             PIC 9.
           02 N-INDEXING    REDEFINES N.
              03 DIGIT      PIC 9 OCCURS 4 TIMES.
           02 NDIV          PIC 9(4).
           02 OK            PIC 9.
        01 OUTPUT-FORMAT.
           02 DISP-N        PIC Z(4).

        PROCEDURE DIVISION.
        BEGIN.
            PERFORM CHECK VARYING N FROM 1 BY 1
                    UNTIL N IS EQUAL TO 1000.
            STOP RUN.

        CHECK SECTION.
        BEGIN.
            SET NSTART TO 1.
            INSPECT N TALLYING NSTART FOR LEADING '0'.

            SET DGT-PROD TO 1.
            PERFORM MUL-DIGIT VARYING D FROM NSTART BY 1
                    UNTIL D IS GREATER THAN 4.
            IF DGT-PROD = 0 GO TO NOPE.
            SET OK TO 1.
            PERFORM CHECK-DIGIT VARYING D FROM NSTART BY 1
                    UNTIL D IS GREATER THAN 4.
            IF OK = 0 GO TO NOPE.
            DIVIDE N BY DGT-PROD GIVING NDIV.
            MULTIPLY DGT-PROD BY NDIV.
            IF NDIV IS EQUAL TO N GO TO NOPE.
            MOVE N TO DISP-N.
            DISPLAY DISP-N.
        MUL-DIGIT.
            IF D IS GREATER THAN 4 GO TO NOPE.
            MULTIPLY DIGIT(D) BY DGT-PROD.
        CHECK-DIGIT.
            IF D IS GREATER THAN 4 GO TO NOPE.
            DIVIDE N BY DIGIT(D) GIVING NDIV.
            MULTIPLY DIGIT(D) BY NDIV.
            IF NDIV IS NOT EQUAL TO N SET OK TO 0.
        NOPE. EXIT.
