        IDENTIFICATION DIVISION.
        PROGRAM-ID. LOOK-AND-SAY-SEQ.

        DATA DIVISION.
        WORKING-STORAGE SECTION.
        01 SEQUENCES.
           02 CUR-SEQ       PIC X(80) VALUE "1".
           02 CUR-CHARS     REDEFINES CUR-SEQ
                            PIC X OCCURS 80 TIMES INDEXED BY CI.
           02 CUR-LENGTH    PIC 99 COMP VALUE 1.
           02 NEXT-SEQ      PIC X(80).
           02 NEXT-CHARS    REDEFINES NEXT-SEQ
                            PIC X OCCURS 80 TIMES INDEXED BY NI.
        01 ALG-STATE.
           02 STEP-AMOUNT   PIC 99 VALUE 14.
           02 ITEM-COUNT    PIC 9.

        PROCEDURE DIVISION.
        LOOK-AND-SAY.
            DISPLAY CUR-SEQ.
            SET CI TO 1.
            SET NI TO 1.
        MAKE-NEXT-ENTRY.
            MOVE 0 TO ITEM-COUNT.
            IF CI IS GREATER THAN CUR-LENGTH GO TO STEP-DONE.
        TALLY-ITEM.
            ADD 1 TO ITEM-COUNT.
            SET CI UP BY 1.
            IF CI IS NOT GREATER THAN CUR-LENGTH
               AND CUR-CHARS(CI) IS EQUAL TO CUR-CHARS(CI - 1)
                GO TO TALLY-ITEM.
        INSERT-ENTRY.
            MOVE ITEM-COUNT TO NEXT-CHARS(NI).
            MOVE CUR-CHARS(CI - 1) TO NEXT-CHARS(NI + 1).
            SET NI UP BY 2.
            GO TO MAKE-NEXT-ENTRY.
        STEP-DONE.
            MOVE NEXT-SEQ TO CUR-SEQ.
            SET NI DOWN BY 1.
            SET CUR-LENGTH TO NI.
            SUBTRACT 1 FROM STEP-AMOUNT.
            IF STEP-AMOUNT IS NOT EQUAL TO ZERO GO TO LOOK-AND-SAY.
            STOP RUN.
