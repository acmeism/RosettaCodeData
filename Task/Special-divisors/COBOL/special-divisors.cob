        IDENTIFICATION DIVISION.
        PROGRAM-ID. SPECIAL-DIVISORS.

        DATA DIVISION.
        WORKING-STORAGE SECTION.
        01 VARIABLES.
           02 CANDIDATE         PIC 999.
           02 CAND-REV          PIC 999.
           02 REVERSE           PIC 999.
           02 REV-DIGITS        REDEFINES REVERSE PIC 9 OCCURS 3 TIMES.
           02 DIVMAX            PIC 999.
           02 DIVISOR           PIC 999.
           02 DIVRSLT           PIC 999V999.
           02 FILLER            REDEFINES DIVRSLT.
              03 FILLER         PIC 999.
              03 FILLER         PIC 999.
                 88 DIVISIBLE   VALUE 0.
           02 TEMP              PIC 9.
           02 RD                PIC 9 COMP.
           02 STATUS-FLAG       PIC X.
              88 OK             VALUE 'Y'.
           02 SPECIAL-N         PIC ZZ9.

        PROCEDURE DIVISION.
        BEGIN.
            PERFORM CHECK-SPECIAL-DIVISOR
                VARYING CANDIDATE FROM 1 BY 1
                UNTIL CANDIDATE IS EQUAL TO 200.
            STOP RUN.

        CHECK-SPECIAL-DIVISOR.
            MOVE CANDIDATE TO REVERSE.
            PERFORM REVERSE-NUMBER.
            MOVE REVERSE TO CAND-REV.
            DIVIDE CANDIDATE BY 2 GIVING DIVMAX.
            MOVE 'Y' TO STATUS-FLAG.
            PERFORM TRY-DIVISOR
                VARYING DIVISOR FROM 1 BY 1
                UNTIL DIVISOR IS GREATER THAN DIVMAX.
            IF OK
                MOVE CANDIDATE TO SPECIAL-N
                DISPLAY SPECIAL-N.

        TRY-DIVISOR.
            IF OK
                DIVIDE CANDIDATE BY DIVISOR GIVING DIVRSLT
                IF DIVISIBLE
                    MOVE DIVISOR TO REVERSE
                    PERFORM REVERSE-NUMBER
                    DIVIDE CAND-REV BY REVERSE GIVING DIVRSLT
                    IF NOT DIVISIBLE MOVE 'N' TO STATUS-FLAG.

        REVERSE-NUMBER.
            SET RD TO 1.
            INSPECT REVERSE TALLYING RD FOR LEADING '0'.
            MOVE REV-DIGITS(RD) TO TEMP.
            MOVE REV-DIGITS(3) TO REV-DIGITS(RD).
            MOVE TEMP TO REV-DIGITS(3).
