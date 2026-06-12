       IDENTIFICATION DIVISION.
       PROGRAM-ID. DIGITS-CALCULATION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 MAX-IDX       PIC 9(4) VALUE 2000.
       01 I             PIC 9(4).
       01 C             PIC 9(8).
       01 A             PIC 9(4).
       01 CLM           PIC 9(8).
       01 TMP-CALC      PIC 9(8).
       01 MOD-VAL       PIC 9(8).

       01 V-ARRAY.
          02 V OCCURS 2000 TIMES PIC 9(8).

       01 DCOUNT-ARRAY.
          02 DCOUNT OCCURS 10 TIMES PIC 9(8).

       01 OUTPUT-LINE         PIC X(100).

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM INITIALIZE-ARRAYS
           PERFORM MAIN-CALCULATION
           PERFORM DISPLAY-RESULTS
           STOP RUN.

       INITIALIZE-ARRAYS.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > MAX-IDX
               MOVE 1 TO V(I)
           END-PERFORM

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 10
               MOVE 0 TO DCOUNT(I)
           END-PERFORM

           MOVE 1 TO DCOUNT(3).

       MAIN-CALCULATION.
           PERFORM VARYING CLM FROM 0 BY 1
               UNTIL CLM > FUNCTION NUMVAL(MAX-IDX) * 2

               COMPUTE A = MAX-IDX + 1
               MOVE 0 TO C

               PERFORM VARYING I FROM 1 BY 1 UNTIL I > MAX-IDX
                   COMPUTE C = C + (V(I) * 10)
                   DIVIDE C BY A GIVING TMP-CALC REMAINDER MOD-VAL
                   MOVE MOD-VAL TO V(I)
                   MOVE TMP-CALC TO C
                   COMPUTE A = A - 1
               END-PERFORM

               ADD 1 TO DCOUNT(C + 1)
           END-PERFORM.

       DISPLAY-RESULTS.
           MOVE SPACES TO OUTPUT-LINE
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 10
               MOVE DCOUNT(I) TO TMP-CALC
               DISPLAY TMP-CALC WITH NO ADVANCING
               DISPLAY " " WITH NO ADVANCING
           END-PERFORM
           STOP RUN.

