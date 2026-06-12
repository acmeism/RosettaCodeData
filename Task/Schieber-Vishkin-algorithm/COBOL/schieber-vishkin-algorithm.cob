IDENTIFICATION DIVISION.
       PROGRAM-ID. JAVA-TO-COBOL.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  VARS.
           05 N-IN PIC S9(9) COMP.
           05 Q-COUNT PIC S9(9) COMP.
           05 I PIC S9(9) COMP.
           05 J PIC S9(9) COMP.
           05 Q-IDX PIC S9(9) COMP.
           05 N-TOTAL PIC S9(9) COMP.
           05 COUNT-VAL PIC S9(9) COMP.
           05 OLDX PIC S9(9) COMP.
           05 X-VAL PIC S9(9) COMP.
           05 Y-VAL PIC S9(9) COMP.
           05 Z-VAL PIC S9(9) COMP.
           05 VAL1 PIC S9(9) COMP.
           05 VAL2 PIC S9(9) COMP.
           05 X-PLUS PIC S9(9) COMP.
           05 NCA-X PIC S9(9) COMP.
           05 NCA-Y PIC S9(9) COMP.
           05 NCA-RES PIC S9(9) COMP.
           05 IDX-N PIC S9(9) COMP.
           05 IDX-NCA PIC S9(9) COMP.
           05 IDX-X PIC S9(9) COMP.
           05 IDX-Y PIC S9(9) COMP.
           05 N PIC S9(9) COMP.
           05 T PIC S9(9) COMP.
           05 V PIC S9(9) COMP.
           05 U PIC S9(9) COMP.
           05 LOOP-DONE PIC S9(9) COMP.
           05 IDX-V PIC S9(9) COMP.
           05 IDX-T PIC S9(9) COMP.
           05 IDX-U PIC S9(9) COMP.
           05 P-VAR PIC S9(9) COMP.
           05 N-VAR PIC S9(9) COMP.
           05 TRAVERSAL-DONE PIC S9(9) COMP.
           05 S3-DONE PIC S9(9) COMP.
           05 S4-DONE PIC S9(9) COMP.
           05 HALF-N PIC S9(9) COMP.
           05 IDX-HALF PIC S9(9) COMP.
           05 IDX-P PIC S9(9) COMP.
           05 IDX-BETA-P PIC S9(9) COMP.
           05 H-VAR PIC S9(9) COMP.
           05 K-VAR PIC S9(9) COMP.
           05 L-VAR PIC S9(9) COMP.
           05 J-VAR PIC S9(9) COMP.
           05 TEMP-K PIC S9(9) COMP.
           05 MASK-VAL PIC S9(9) COMP.
           05 IDX-AND PIC S9(9) COMP.
           05 IDX-TAU PIC S9(9) COMP.
           05 ALFA-NODE PIC S9(9) COMP.
           05 CURR-NODE PIC S9(9) COMP.
           05 ALFA-DONE PIC S9(9) COMP.
           05 BACKTRACK-DONE PIC S9(9) COMP.
           05 IDX-CURR PIC S9(9) COMP.
           05 IDX-PARENT PIC S9(9) COMP.

       01  BIT-VARS.
           05 BIT-A PIC S9(9) COMP.
           05 BIT-B PIC S9(9) COMP.
           05 BIT-RES PIC S9(9) COMP.
           05 BIT-MUL PIC S9(9) COMP.
           05 TEMP-A PIC S9(9) COMP.
           05 TEMP-B PIC S9(9) COMP.
           05 REM-A PIC S9(9) COMP.
           05 REM-B PIC S9(9) COMP.
           05 BIT-IDX PIC S9(9) COMP.
           05 BIT-VAL PIC S9(9) COMP.
           05 BIT-SHIFT PIC S9(9) COMP.
           05 BIT-DIV PIC S9(9) COMP.

       01  ARRAYS.
           05 VALUES-ARR OCCURS 10005 TIMES PIC S9(9) COMP.
           05 QUERY-I OCCURS 10005 TIMES PIC S9(9) COMP.
           05 QUERY-J OCCURS 10005 TIMES PIC S9(9) COMP.
           05 EXPECTED-ARR OCCURS 10005 TIMES PIC S9(9) COMP.
           05 RESULTS-ARR OCCURS 10005 TIMES PIC S9(9) COMP.
           05 A-ARR OCCURS 10005 TIMES PIC S9(9) COMP.
           05 R-ARR OCCURS 10005 TIMES PIC S9(9) COMP.
           05 B-ARR OCCURS 10005 TIMES PIC S9(9) COMP.

       01  TREE-ARRAYS.
           05 PI-ARR OCCURS 10005 TIMES PIC S9(9) COMP.
           05 BETA-ARR OCCURS 10005 TIMES PIC S9(9) COMP.
           05 ALFA-ARR OCCURS 10005 TIMES PIC S9(9) COMP.
           05 TAU-ARR OCCURS 10005 TIMES PIC S9(9) COMP.
           05 LAM-ARR OCCURS 10005 TIMES PIC S9(9) COMP.
           05 NODES OCCURS 10005 TIMES.
              10 NODE-CHILD PIC S9(9) COMP VALUE 0.
              10 NODE-SIB PIC S9(9) COMP VALUE 0.
              10 NODE-PARENT PIC S9(9) COMP VALUE 0.

       01  DISP-VARS.
           05 DISP-NUM PIC -9(9).
           05 TEMP-STR-I PIC X(15).
           05 TEMP-STR-J PIC X(15).
           05 TEMP-STR-RES PIC X(15).
           05 TEMP-STR-EXP PIC X(15).

       PROCEDURE DIVISION.
       MAIN-PARA.
           MOVE 10 TO N-IN
           MOVE 3 TO Q-COUNT
           MOVE -1 TO VALUES-ARR(1)
           MOVE -1 TO VALUES-ARR(2)
           MOVE 1 TO VALUES-ARR(3)
           MOVE 1 TO VALUES-ARR(4)
           MOVE 1 TO VALUES-ARR(5)
           MOVE 1 TO VALUES-ARR(6)
           MOVE 3 TO VALUES-ARR(7)
           MOVE 10 TO VALUES-ARR(8)
           MOVE 10 TO VALUES-ARR(9)
           MOVE 10 TO VALUES-ARR(10)

           MOVE 2 TO QUERY-I(1)
           MOVE 3 TO QUERY-J(1)
           MOVE 1 TO EXPECTED-ARR(1)

           MOVE 1 TO QUERY-I(2)
           MOVE 10 TO QUERY-J(2)
           MOVE 4 TO EXPECTED-ARR(2)

           MOVE 5 TO QUERY-I(3)
           MOVE 10 TO QUERY-J(3)
           MOVE 3 TO EXPECTED-ARR(3)

           DISPLAY "Test Case 1:"
           DISPLAY "Size: " N-IN ", Queries: " Q-COUNT
           DISPLAY "Values: -1 -1 1 1 1 1 3 10 10 10"

           PERFORM SOLVE-TEST-CASE

           DISPLAY "Queries and Results:"
           PERFORM VARYING Q-IDX FROM 1 BY 1 UNTIL Q-IDX > Q-COUNT
               MOVE QUERY-I(Q-IDX) TO DISP-NUM
               MOVE DISP-NUM TO TEMP-STR-I
               MOVE QUERY-J(Q-IDX) TO DISP-NUM
               MOVE DISP-NUM TO TEMP-STR-J
               DISPLAY "Query: " FUNCTION TRIM(TEMP-STR-I)
                       " " FUNCTION TRIM(TEMP-STR-J)

               MOVE RESULTS-ARR(Q-IDX) TO DISP-NUM
               MOVE DISP-NUM TO TEMP-STR-RES
               MOVE EXPECTED-ARR(Q-IDX) TO DISP-NUM
               MOVE DISP-NUM TO TEMP-STR-EXP
               DISPLAY "Result: " FUNCTION TRIM(TEMP-STR-RES)
                       " (Expected: " FUNCTION TRIM(TEMP-STR-EXP) ")"

               IF RESULTS-ARR(Q-IDX) NOT = EXPECTED-ARR(Q-IDX)
                   DISPLAY "  WARNING: Result doesn't match expected"
               END-IF
           END-PERFORM

           STOP RUN.

       SOLVE-TEST-CASE.
           MOVE 2147483647 TO A-ARR(1)
           MOVE 1 TO N-TOTAL
           MOVE 0 TO COUNT-VAL
           MOVE -999999 TO OLDX

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > N-IN
               MOVE VALUES-ARR(I) TO X-VAL
               IF I > 1 AND X-VAL NOT = OLDX
                   COMPUTE IDX-N = N-TOTAL + 1
                   MOVE COUNT-VAL TO A-ARR(IDX-N)
                   MOVE I TO R-ARR(IDX-N)
                   ADD 1 TO N-TOTAL
                   MOVE 0 TO COUNT-VAL
               END-IF
               MOVE N-TOTAL TO B-ARR(I)
               ADD 1 TO COUNT-VAL
               MOVE X-VAL TO OLDX
           END-PERFORM

           COMPUTE IDX-N = N-TOTAL + 1
           MOVE COUNT-VAL TO A-ARR(IDX-N)
           COMPUTE R-ARR(IDX-N) = N-IN + 1

           MOVE N-TOTAL TO N
           PERFORM PROCESS-PARA

           PERFORM VARYING Q-IDX FROM 1 BY 1 UNTIL Q-IDX > Q-COUNT
               MOVE QUERY-I(Q-IDX) TO I
               MOVE QUERY-J(Q-IDX) TO J
               MOVE B-ARR(I) TO X-VAL
               MOVE B-ARR(J) TO Y-VAL

               IF X-VAL = Y-VAL
                   COMPUTE Z-VAL = J - I + 1
               ELSE
                   COMPUTE X-PLUS = X-VAL + 1
                   IF X-PLUS NOT = Y-VAL
                       COMPUTE NCA-X = X-VAL + 1
                       COMPUTE NCA-Y = Y-VAL - 1
                       PERFORM NCA-PARA
                       COMPUTE IDX-NCA = NCA-RES + 1
                       MOVE A-ARR(IDX-NCA) TO Z-VAL
                   ELSE
                       MOVE 0 TO Z-VAL
                   END-IF

                   COMPUTE IDX-X = X-VAL + 1
                   COMPUTE VAL1 = R-ARR(IDX-X) - I
                   COMPUTE IDX-Y = Y-VAL + 1
                   COMPUTE VAL2 = A-ARR(IDX-Y) - R-ARR(IDX-Y) + J + 1

                   IF VAL1 > Z-VAL
                       MOVE VAL1 TO Z-VAL
                   END-IF
                   IF VAL2 > Z-VAL
                       MOVE VAL2 TO Z-VAL
                   END-IF
               END-IF

               MOVE Z-VAL TO RESULTS-ARR(Q-IDX)
           END-PERFORM.

       PROCESS-PARA.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > N + 1
               MOVE 0 TO NODE-CHILD(I)
               MOVE 0 TO NODE-SIB(I)
               MOVE 0 TO NODE-PARENT(I)
           END-PERFORM

           MOVE 0 TO T
           PERFORM VARYING V FROM N BY -1 UNTIL V <= 0
               MOVE 0 TO U
               MOVE 0 TO LOOP-DONE
               PERFORM UNTIL LOOP-DONE = 1
                   COMPUTE IDX-V = V + 1
                   COMPUTE IDX-T = T + 1
                   IF A-ARR(IDX-V) > A-ARR(IDX-T) OR
                     (A-ARR(IDX-V) = A-ARR(IDX-T) AND V > T)
                       MOVE T TO U
                       MOVE NODE-PARENT(IDX-T) TO T
                   ELSE
                       MOVE 1 TO LOOP-DONE
                   END-IF
               END-PERFORM

               COMPUTE IDX-V = V + 1
               COMPUTE IDX-T = T + 1
               COMPUTE IDX-U = U + 1
               IF U NOT = 0
                   MOVE NODE-SIB(IDX-U) TO NODE-SIB(IDX-V)
                   MOVE 0 TO NODE-SIB(IDX-U)
                   MOVE V TO NODE-PARENT(IDX-U)
                   MOVE U TO NODE-CHILD(IDX-V)
               ELSE
                   MOVE NODE-CHILD(IDX-T) TO NODE-SIB(IDX-V)
               END-IF

               MOVE V TO NODE-CHILD(IDX-T)
               MOVE T TO NODE-PARENT(IDX-V)
               MOVE V TO T
           END-PERFORM

           MOVE NODE-CHILD(1) TO P-VAR
           MOVE 0 TO N-VAR
           MOVE -1 TO LAM-ARR(1)

           MOVE 0 TO TRAVERSAL-DONE
           PERFORM UNTIL TRAVERSAL-DONE = 1
               PERFORM TRAVERSAL-PARA
           END-PERFORM

           MOVE NODE-CHILD(1) TO P-VAR
           COMPUTE IDX-N = N-VAR + 1
           MOVE LAM-ARR(IDX-N) TO LAM-ARR(1)
           MOVE 0 TO PI-ARR(1)
           MOVE 0 TO BETA-ARR(1)
           MOVE 0 TO ALFA-ARR(1)

           IF P-VAR NOT = 0
               MOVE P-VAR TO ALFA-NODE
               PERFORM COMPUTE-ALFA
           END-IF.

       TRAVERSAL-PARA.
           MOVE 0 TO S3-DONE
           PERFORM UNTIL S3-DONE = 1
               ADD 1 TO N-VAR
               COMPUTE IDX-P = P-VAR + 1
               MOVE N-VAR TO PI-ARR(IDX-P)
               COMPUTE IDX-N = N-VAR + 1
               MOVE 0 TO TAU-ARR(IDX-N)
               COMPUTE HALF-N = N-VAR / 2
               COMPUTE IDX-HALF = HALF-N + 1
               COMPUTE LAM-ARR(IDX-N) = 1 + LAM-ARR(IDX-HALF)

               IF NODE-CHILD(IDX-P) NOT = 0
                   MOVE NODE-CHILD(IDX-P) TO P-VAR
               ELSE
                   MOVE N-VAR TO BETA-ARR(IDX-P)
                   MOVE 1 TO S3-DONE
               END-IF
           END-PERFORM

           MOVE 0 TO S4-DONE
           PERFORM UNTIL S4-DONE = 1
               COMPUTE IDX-P = P-VAR + 1
               COMPUTE IDX-BETA-P = BETA-ARR(IDX-P) + 1
               MOVE NODE-PARENT(IDX-P) TO TAU-ARR(IDX-BETA-P)

               IF NODE-SIB(IDX-P) NOT = 0
                   MOVE NODE-SIB(IDX-P) TO P-VAR
                   MOVE 1 TO S4-DONE
                   MOVE 0 TO TRAVERSAL-DONE
                   EXIT PARAGRAPH
               END-IF

               MOVE NODE-PARENT(IDX-P) TO P-VAR
               COMPUTE IDX-P = P-VAR + 1
               IF P-VAR NOT = 0
                   MOVE N-VAR TO BIT-A
                   COMPUTE BIT-B = 0 - PI-ARR(IDX-P)
                   PERFORM DO-BIT-AND
                   COMPUTE IDX-AND = BIT-RES + 1
                   MOVE LAM-ARR(IDX-AND) TO H-VAR

                   COMPUTE BIT-VAL = N-VAR
                   COMPUTE BIT-SHIFT = H-VAR
                   PERFORM DO-BIT-SHIFT-RIGHT
                   MOVE BIT-RES TO BIT-A
                   MOVE 1 TO BIT-B
                   PERFORM DO-BIT-OR
                   MOVE BIT-RES TO BIT-VAL
                   COMPUTE BIT-SHIFT = H-VAR
                   PERFORM DO-BIT-SHIFT-LEFT
                   MOVE BIT-RES TO BETA-ARR(IDX-P)
               ELSE
                   MOVE 1 TO S4-DONE
                   MOVE 1 TO TRAVERSAL-DONE
                   EXIT PARAGRAPH
               END-IF
           END-PERFORM.

       COMPUTE-ALFA.
           MOVE ALFA-NODE TO CURR-NODE
           MOVE 0 TO ALFA-DONE
           PERFORM UNTIL ALFA-DONE = 1
               COMPUTE IDX-CURR = CURR-NODE + 1
               COMPUTE IDX-PARENT = NODE-PARENT(IDX-CURR) + 1

               MOVE BETA-ARR(IDX-CURR) TO BIT-A
               COMPUTE BIT-B = 0 - BETA-ARR(IDX-CURR)
               PERFORM DO-BIT-AND

               MOVE ALFA-ARR(IDX-PARENT) TO BIT-A
               MOVE BIT-RES TO BIT-B
               PERFORM DO-BIT-OR
               MOVE BIT-RES TO ALFA-ARR(IDX-CURR)

               IF NODE-CHILD(IDX-CURR) NOT = 0
                   MOVE NODE-CHILD(IDX-CURR) TO CURR-NODE
               ELSE
                   IF NODE-SIB(IDX-CURR) NOT = 0
                       MOVE NODE-SIB(IDX-CURR) TO CURR-NODE
                   ELSE
                       MOVE 0 TO BACKTRACK-DONE
                       PERFORM UNTIL BACKTRACK-DONE = 1
                           IF CURR-NODE = 0 OR
                             NODE-SIB(IDX-CURR) NOT = 0
                               MOVE 1 TO BACKTRACK-DONE
                           ELSE
                               MOVE NODE-PARENT(IDX-CURR) TO CURR-NODE
                               COMPUTE IDX-CURR = CURR-NODE + 1
                           END-IF
                       END-PERFORM

                       IF CURR-NODE = 0
                           MOVE 1 TO ALFA-DONE
                       ELSE
                           MOVE NODE-SIB(IDX-CURR) TO CURR-NODE
                       END-IF
                   END-IF
               END-IF
           END-PERFORM.

       NCA-PARA.
           COMPUTE IDX-X = NCA-X + 1
           COMPUTE IDX-Y = NCA-Y + 1

           IF BETA-ARR(IDX-X) <= BETA-ARR(IDX-Y)
               MOVE BETA-ARR(IDX-Y) TO BIT-A
               COMPUTE BIT-B = 0 - BETA-ARR(IDX-X)
               PERFORM DO-BIT-AND
               COMPUTE IDX-AND = BIT-RES + 1
               MOVE LAM-ARR(IDX-AND) TO H-VAR
           ELSE
               MOVE BETA-ARR(IDX-X) TO BIT-A
               COMPUTE BIT-B = 0 - BETA-ARR(IDX-Y)
               PERFORM DO-BIT-AND
               COMPUTE IDX-AND = BIT-RES + 1
               MOVE LAM-ARR(IDX-AND) TO H-VAR
           END-IF

           MOVE ALFA-ARR(IDX-X) TO BIT-A
           MOVE ALFA-ARR(IDX-Y) TO BIT-B
           PERFORM DO-BIT-AND
           MOVE BIT-RES TO TEMP-K

           COMPUTE BIT-VAL = 1
           COMPUTE BIT-SHIFT = H-VAR
           PERFORM DO-BIT-SHIFT-LEFT
           MOVE TEMP-K TO BIT-A
           COMPUTE BIT-B = 0 - BIT-RES
           PERFORM DO-BIT-AND
           MOVE BIT-RES TO K-VAR

           MOVE K-VAR TO BIT-A
           COMPUTE BIT-B = 0 - K-VAR
           PERFORM DO-BIT-AND
           COMPUTE IDX-AND = BIT-RES + 1
           MOVE LAM-ARR(IDX-AND) TO H-VAR

           COMPUTE BIT-VAL = BETA-ARR(IDX-X)
           COMPUTE BIT-SHIFT = H-VAR
           PERFORM DO-BIT-SHIFT-RIGHT
           MOVE BIT-RES TO BIT-A
           MOVE 1 TO BIT-B
           PERFORM DO-BIT-OR
           MOVE BIT-RES TO BIT-VAL
           COMPUTE BIT-SHIFT = H-VAR
           PERFORM DO-BIT-SHIFT-LEFT
           MOVE BIT-RES TO J-VAR

           IF J-VAR NOT = BETA-ARR(IDX-X)
               COMPUTE BIT-VAL = 1
               COMPUTE BIT-SHIFT = H-VAR
               PERFORM DO-BIT-SHIFT-LEFT
               COMPUTE MASK-VAL = BIT-RES - 1

               MOVE ALFA-ARR(IDX-X) TO BIT-A
               MOVE MASK-VAL TO BIT-B
               PERFORM DO-BIT-AND

               COMPUTE IDX-AND = BIT-RES + 1
               MOVE LAM-ARR(IDX-AND) TO L-VAR

               COMPUTE BIT-VAL = BETA-ARR(IDX-X)
               COMPUTE BIT-SHIFT = L-VAR
               PERFORM DO-BIT-SHIFT-RIGHT
               MOVE BIT-RES TO BIT-A
               MOVE 1 TO BIT-B
               PERFORM DO-BIT-OR
               MOVE BIT-RES TO BIT-VAL
               COMPUTE BIT-SHIFT = L-VAR
               PERFORM DO-BIT-SHIFT-LEFT
               COMPUTE IDX-TAU = BIT-RES + 1
               MOVE TAU-ARR(IDX-TAU) TO NCA-X
               COMPUTE IDX-X = NCA-X + 1
           END-IF

           IF J-VAR NOT = BETA-ARR(IDX-Y)
               COMPUTE BIT-VAL = 1
               COMPUTE BIT-SHIFT = H-VAR
               PERFORM DO-BIT-SHIFT-LEFT
               COMPUTE MASK-VAL = BIT-RES - 1

               MOVE ALFA-ARR(IDX-Y) TO BIT-A
               MOVE MASK-VAL TO BIT-B
               PERFORM DO-BIT-AND

               COMPUTE IDX-AND = BIT-RES + 1
               MOVE LAM-ARR(IDX-AND) TO L-VAR

               COMPUTE BIT-VAL = BETA-ARR(IDX-Y)
               COMPUTE BIT-SHIFT = L-VAR
               PERFORM DO-BIT-SHIFT-RIGHT
               MOVE BIT-RES TO BIT-A
               MOVE 1 TO BIT-B
               PERFORM DO-BIT-OR
               MOVE BIT-RES TO BIT-VAL
               COMPUTE BIT-SHIFT = L-VAR
               PERFORM DO-BIT-SHIFT-LEFT
               COMPUTE IDX-TAU = BIT-RES + 1
               MOVE TAU-ARR(IDX-TAU) TO NCA-Y
               COMPUTE IDX-Y = NCA-Y + 1
           END-IF

           IF PI-ARR(IDX-X) <= PI-ARR(IDX-Y)
               MOVE NCA-X TO NCA-RES
           ELSE
               MOVE NCA-Y TO NCA-RES
           END-IF.

       DO-BIT-AND.
           MOVE 0 TO BIT-RES
           MOVE 1 TO BIT-MUL
           MOVE BIT-A TO TEMP-A
           MOVE BIT-B TO TEMP-B
           PERFORM UNTIL TEMP-A >= 0
               COMPUTE TEMP-A = TEMP-A + 65536
           END-PERFORM
           PERFORM UNTIL TEMP-B >= 0
               COMPUTE TEMP-B = TEMP-B + 65536
           END-PERFORM
           PERFORM VARYING BIT-IDX FROM 1 BY 1 UNTIL BIT-IDX > 16
               DIVIDE TEMP-A BY 2 GIVING TEMP-A REMAINDER REM-A
               DIVIDE TEMP-B BY 2 GIVING TEMP-B REMAINDER REM-B
               IF REM-A = 1 AND REM-B = 1
                   COMPUTE BIT-RES = BIT-RES + BIT-MUL
               END-IF
               COMPUTE BIT-MUL = BIT-MUL * 2
           END-PERFORM.

       DO-BIT-OR.
           MOVE 0 TO BIT-RES
           MOVE 1 TO BIT-MUL
           MOVE BIT-A TO TEMP-A
           MOVE BIT-B TO TEMP-B
           PERFORM UNTIL TEMP-A >= 0
               COMPUTE TEMP-A = TEMP-A + 65536
           END-PERFORM
           PERFORM UNTIL TEMP-B >= 0
               COMPUTE TEMP-B = TEMP-B + 65536
           END-PERFORM
           PERFORM VARYING BIT-IDX FROM 1 BY 1 UNTIL BIT-IDX > 16
               DIVIDE TEMP-A BY 2 GIVING TEMP-A REMAINDER REM-A
               DIVIDE TEMP-B BY 2 GIVING TEMP-B REMAINDER REM-B
               IF REM-A = 1 OR REM-B = 1
                   COMPUTE BIT-RES = BIT-RES + BIT-MUL
               END-IF
               COMPUTE BIT-MUL = BIT-MUL * 2
           END-PERFORM.

       DO-BIT-SHIFT-LEFT.
           COMPUTE BIT-MUL = 2 ** BIT-SHIFT
           COMPUTE BIT-RES = BIT-VAL * BIT-MUL
           DIVIDE BIT-RES BY 65536 GIVING BIT-DIV REMAINDER BIT-RES.

       DO-BIT-SHIFT-RIGHT.
           COMPUTE BIT-MUL = 2 ** BIT-SHIFT
           DIVIDE BIT-VAL BY BIT-MUL GIVING BIT-RES.
