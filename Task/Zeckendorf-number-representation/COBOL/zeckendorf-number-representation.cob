       IDENTIFICATION DIVISION.
       PROGRAM-ID. ZECKENDORF-NUMBERS.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 FIBONACCI.
          03 FIB                  PIC 9(8) OCCURS 50 TIMES,
                                  INDEXED BY F.
       01 ZECK-VARS.
          03 ZECK                 PIC 9(9).
          03 NUM                  PIC 9(9).

       01 LOOP-VARS.
          03 I                    PIC 9(9).

       01 OUTPUT-LINE.
          03 OUT-IDX              PIC Z9.
          03 FILLER               PIC XX VALUE ':'.
          03 OUT-ZECK             PIC Z(9)9.

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM SHOW-ZECK VARYING I FROM 0 BY 1
           UNTIL I IS GREATER THAN 20.
           STOP RUN.

       SHOW-ZECK.
           MOVE I TO NUM.
           PERFORM FIND-ZECK.
           MOVE I TO OUT-IDX.
           MOVE ZECK TO OUT-ZECK.
           DISPLAY OUTPUT-LINE.

       FIND-ZECK.
           MOVE ZERO TO ZECK.
           IF NUM IS NOT EQUAL TO ZERO,
               PERFORM CALC-FIBONACCI,
               PERFORM ZECK-STEP UNTIL F IS ZERO.

       ZECK-STEP.
           MULTIPLY 10 BY ZECK.
           IF FIB(F) IS NOT GREATER THAN NUM,
               SUBTRACT FIB(F) FROM NUM,
               ADD 1 TO ZECK.
           SET F DOWN BY 1.

       CALC-FIBONACCI.
           MOVE 1 TO FIB(1).
           MOVE 2 TO FIB(2).
           SET F TO 2.
           PERFORM FIB-STEP UNTIL FIB(F) IS GREATER THAN NUM.

       FIB-STEP.
           ADD FIB(F), FIB(F - 1) GIVING FIB(F + 1).
           SET F UP BY 1.
