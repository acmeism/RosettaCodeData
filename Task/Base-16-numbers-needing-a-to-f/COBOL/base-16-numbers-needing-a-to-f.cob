        IDENTIFICATION DIVISION.
        PROGRAM-ID. BASE-16.

        DATA DIVISION.
        WORKING-STORAGE SECTION.
        01 VARIABLES        COMP.
           02 STRP          PIC 99 VALUE 1.
           02 N             PIC 999.
           02 NTEMP         PIC 999.
           02 N16           PIC 999.
           02 NMOD16        PIC 99.
           02 BASE16-FLAG   PIC 9.
              88 BASE16     VALUE 1.
           02 AMOUNT        PIC 999 VALUE 0.

        01 OUTPUT-FORMAT.
           02 LINESTR       PIC X(72).
           02 OUTN          PIC BZZ9.

        PROCEDURE DIVISION.
        BEGIN.
            PERFORM NONDEC VARYING N FROM 1 BY 1
                UNTIL N IS GREATER THAN 500.
            PERFORM DISPLAY-LINE.
            DISPLAY ' '.
            MOVE AMOUNT TO OUTN.
            DISPLAY OUTN ' numbers found.'
            STOP RUN.

        NONDEC.
            MOVE N TO NTEMP.
            PERFORM IS-NONDEC.
            IF BASE16
                MOVE N TO OUTN
                STRING OUTN DELIMITED BY SIZE INTO LINESTR
                    WITH POINTER STRP
                ADD 1 TO AMOUNT
                IF STRP IS EQUAL TO 73 PERFORM DISPLAY-LINE.

        DISPLAY-LINE.
            IF STRP IS NOT EQUAL TO 1 DISPLAY LINESTR.
            MOVE 1 TO STRP.
            MOVE ' ' TO LINESTR.

        IS-NONDEC.
            IF NTEMP IS EQUAL TO ZERO
                MOVE 0 TO BASE16-FLAG
            ELSE
                DIVIDE NTEMP BY 16 GIVING N16
                COMPUTE NMOD16 = NTEMP - N16 * 16
                IF NMOD16 IS NOT LESS THAN 10
                    MOVE 1 TO BASE16-FLAG
                ELSE
                    MOVE N16 TO NTEMP
                    GO TO IS-NONDEC.
