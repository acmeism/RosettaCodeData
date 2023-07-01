        IDENTIFICATION DIVISION.
        PROGRAM-ID. GAPFUL.

        DATA DIVISION.
        WORKING-STORAGE SECTION.
        01 COMPUTATION.
            02 N            PIC 9(10).
            02 N-DIGITS     REDEFINES N.
               03 ND        PIC 9 OCCURS 10 TIMES.
            02 DIV-CHECK    PIC 9(10)V9(2).
            02 DIV-PARTS    REDEFINES DIV-CHECK.
               03 DIV-INT   PIC 9(10).
               03 DIV-FRAC  PIC 9(2).
            02 GAP-AMOUNT   PIC 99.
            02 GAP-DSOR     PIC 99.
            02 FIRST-DIGIT  PIC 99.
        01 OUTPUT-FORMAT.
            02 N-OUT        PIC Z(10).

        PROCEDURE DIVISION.
        BEGIN.
            DISPLAY "First 30 gapful numbers >= 100:".
            MOVE 100 TO N. MOVE 30 TO GAP-AMOUNT.
            PERFORM CHECK-GAPFUL-NUMBER.

            DISPLAY " ".
            DISPLAY "First 15 gapful numbers >= 1000000:".
            MOVE 1000000 TO N. MOVE 15 TO GAP-AMOUNT.
            PERFORM CHECK-GAPFUL-NUMBER.

            DISPLAY " ".
            DISPLAY "First 10 gapful numbers >= 1000000000:".
            MOVE 1000000000 TO N. MOVE 10 TO GAP-AMOUNT.
            PERFORM CHECK-GAPFUL-NUMBER.
            STOP RUN.

        CHECK-GAPFUL-NUMBER.
            SET FIRST-DIGIT TO 1.
            INSPECT N TALLYING FIRST-DIGIT FOR LEADING '0'.
            COMPUTE GAP-DSOR = ND(FIRST-DIGIT) * 10 + ND(10).
            DIVIDE N BY GAP-DSOR GIVING DIV-CHECK.
            IF DIV-FRAC IS EQUAL TO 0
                MOVE N TO N-OUT
                DISPLAY N-OUT
                SUBTRACT 1 FROM GAP-AMOUNT.
            ADD 1 TO N.
            IF GAP-AMOUNT IS GREATER THAN 0
                GO TO CHECK-GAPFUL-NUMBER.
