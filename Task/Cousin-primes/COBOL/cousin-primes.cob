        IDENTIFICATION DIVISION.
        PROGRAM-ID. COUSIN-PRIMES.

        DATA DIVISION.
        WORKING-STORAGE SECTION.
        01 PRIME-SIEVE.
           02 PRIME-FLAG        PIC 9 OCCURS 1000 INDEXED BY P, Q.
              88 PRIME          VALUE 1.
           02 STEP-SIZE         PIC 999.
           02 X                 PIC 999.
           02 P-START           PIC 999.
           02 AMOUNT            PIC 999 VALUE 0.
        01 OUTPUT-FORMAT.
           02 COUSIN1           PIC ZZ9.
           02 COUSIN2           PIC ZZ9.

        PROCEDURE DIVISION.
        BEGIN.
            PERFORM SIEVE.
            PERFORM TEST-COUSINS VARYING P FROM 2 BY 1
                UNTIL P IS GREATER THAN 996.
            MOVE AMOUNT TO COUSIN1.
            DISPLAY COUSIN1 ' pairs found.'
            STOP RUN.

        TEST-COUSINS.
            IF PRIME(P) AND PRIME(P + 4)
                SET X TO P
                MOVE X TO COUSIN1
                ADD X, 4 GIVING COUSIN2
                DISPLAY COUSIN1 ' ' COUSIN2
                ADD 1 TO AMOUNT.

        SIEVE SECTION.
        BEGIN.
            PERFORM FLAG-PRIME VARYING Q FROM 1 BY 1
                UNTIL Q IS GREATER THAN 1000.
            PERFORM SIEVE-PRIME VARYING P FROM 2 BY 1
                UNTIL P IS GREATER THAN 32.
            GO TO DONE.

        SIEVE-PRIME.
            IF PRIME(P)
                SET X TO P
                COMPUTE P-START = X ** 2
                PERFORM UNFLAG-PRIME VARYING Q FROM P-START BY X
                    UNTIL Q IS GREATER THAN 1000.

        FLAG-PRIME.   MOVE 1 TO PRIME-FLAG(Q).
        UNFLAG-PRIME. MOVE 0 TO PRIME-FLAG(Q).
        DONE. EXIT.
