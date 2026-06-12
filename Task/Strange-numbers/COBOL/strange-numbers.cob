        IDENTIFICATION DIVISION.
        PROGRAM-ID. STRANGE-NUMBERS.

        DATA DIVISION.
        WORKING-STORAGE SECTION.
        01 COMPUTATION.
           02 NUM           PIC 999.
           02 DIGITS        REDEFINES NUM PIC 9 OCCURS 3 TIMES.
           02 DIGIT-PRIME   PIC 9.
              88 PRIME      VALUES 2 3 5 7.
           02 CUR-DIGIT     PIC 9.
        01 OUTPUT-FORMAT.
           02 N-OUT         PIC ZZ9.
        PROCEDURE DIVISION.
        BEGIN.
            PERFORM STRANGE-TEST
                VARYING NUM FROM 100 BY 1
                UNTIL NUM IS GREATER THAN 500.
            STOP RUN.

        STRANGE-TEST SECTION.
        BEGIN.
            SET CUR-DIGIT TO 1.
        STEP.
            IF DIGITS(CUR-DIGIT) IS LESS THAN DIGITS(CUR-DIGIT + 1)
                SUBTRACT DIGITS(CUR-DIGIT + 1) FROM DIGITS(CUR-DIGIT)
                    GIVING DIGIT-PRIME
            ELSE
                SUBTRACT DIGITS(CUR-DIGIT) FROM DIGITS(CUR-DIGIT + 1)
                    GIVING DIGIT-PRIME.
            IF PRIME NEXT SENTENCE ELSE GO TO DONE.
            ADD 1 TO CUR-DIGIT.
            IF CUR-DIGIT IS LESS THAN 3 GO TO STEP.
            MOVE NUM TO N-OUT.
            DISPLAY N-OUT.
        DONE. EXIT.
