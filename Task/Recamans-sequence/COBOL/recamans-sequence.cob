        IDENTIFICATION DIVISION.
        PROGRAM-ID. RECAMAN.

        DATA DIVISION.
        WORKING-STORAGE SECTION.
        01 RECAMAN-SEQUENCE COMP.
           02 A     PIC 999 OCCURS 99 TIMES INDEXED BY I.
           02 N     PIC 999 VALUE 0.

        01 VARIABLES COMP.
           02 ADDC  PIC S999.
           02 SUBC  PIC S999.
           02 SPTR  PIC 99 VALUE 1.

        01 OUTPUT-FORMAT.
           02 OUTI  PIC Z9.
           02 OUTN  PIC BZ9.
           02 OUTS  PIC X(79).

        PROCEDURE DIVISION.
        BEGIN.
            PERFORM GENERATE-NEXT-ITEM 15 TIMES.
            PERFORM COLLATE-ITEM VARYING I FROM 1 BY 1
                UNTIL I IS GREATER THAN 15.
            DISPLAY 'First 15 items:' OUTS.

        FIND-REPEATING.
            PERFORM GENERATE-NEXT-ITEM.
            SET I TO 1.
            SEARCH A VARYING I
                WHEN I IS NOT LESS THAN N
                    NEXT SENTENCE
                WHEN A(I) IS EQUAL TO A(N)
                    SUBTRACT 1 FROM N GIVING OUTI
                    MOVE A(N) TO OUTN
                    DISPLAY 'First repeated item: A(' OUTI ') =' OUTN
                    STOP RUN.
            GO TO FIND-REPEATING.

        GENERATE-NEXT-ITEM.
            IF N IS EQUAL TO ZERO
                MOVE ZERO TO A(1)
            ELSE
                ADD N, A(N) GIVING ADDC
                SUBTRACT N FROM A(N) GIVING SUBC
                IF SUBC IS NOT GREATER THAN ZERO
                    MOVE ADDC TO A(N + 1)
                ELSE
                    SET I TO 1
                    SEARCH A VARYING I
                        WHEN I IS NOT LESS THAN N
                            MOVE SUBC TO A(N + 1)
                        WHEN A(I) IS EQUAL TO SUBC
                            MOVE ADDC TO A(N + 1).
            ADD 1 TO N.

        COLLATE-ITEM.
            MOVE A(I) TO OUTN.
            STRING OUTN DELIMITED BY SIZE INTO OUTS WITH POINTER SPTR.
