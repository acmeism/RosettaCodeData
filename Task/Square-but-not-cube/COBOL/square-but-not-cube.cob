        IDENTIFICATION DIVISION.
        PROGRAM-ID. SQUARE-NOT-CUBE.

        DATA DIVISION.
        WORKING-STORAGE SECTION.
        01 COMPUTATION.
           02 SQ-ROOT       PIC 9999 COMP VALUE 1.
           02 CUBE-ROOT     PIC 9999 COMP VALUE 1.
           02 SQUARE        PIC 9999 COMP VALUE 1.
           02 CUBE          PIC 9999 COMP VALUE 1.
           02 SEEN          PIC 99   COMP VALUE 0.
        01 OUTPUT-FORMAT.
           02 OUT-NUM       PIC ZZZ9.

        PROCEDURE DIVISION.
        SQUARE-STEP.
            COMPUTE SQUARE = SQ-ROOT ** 2.
        CUBE-STEP.
            IF SQUARE IS GREATER THAN CUBE
                ADD 1 TO CUBE-ROOT
                COMPUTE CUBE = CUBE-ROOT ** 3
                GO TO CUBE-STEP.
            IF SQUARE IS NOT EQUAL TO CUBE
                ADD 1 TO SEEN
                MOVE SQUARE TO OUT-NUM
                DISPLAY OUT-NUM.
            ADD 1 TO SQ-ROOT.
            IF SEEN IS LESS THAN 30 GO TO SQUARE-STEP.
            STOP RUN.
