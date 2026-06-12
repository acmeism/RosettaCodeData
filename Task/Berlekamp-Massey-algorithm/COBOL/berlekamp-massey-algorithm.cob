       IDENTIFICATION DIVISION.
       PROGRAM-ID. BerlekampMasseyTask.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  CONSTANTS.
           05 MAX-SIZE           PIC 9(4) VALUE 50.
           05 MODULUS            PIC 9(4) VALUE 100.
           05 SOURCE-SIZE        PIC 9(4) VALUE 9.

       01  SOURCE-ARRAY.
           05 SOURCE-VAL OCCURS 50 TIMES PIC S9(9) COMP.

       01  RESULT-ARRAY.
           05 RESULT-SIZE        PIC 9(4) VALUE 0.
           05 RESULT-VAL OCCURS 50 TIMES PIC S9(9) COMP.

       01  PREV-RESULT-ARRAY.
           05 PREV-RESULT-SIZE   PIC 9(4) VALUE 0.
           05 PREV-RESULT-VAL OCCURS 50 TIMES PIC S9(9) COMP.

       01  PREV-RESULT-COPY.
           05 PREV-COPY-SIZE     PIC 9(4) VALUE 0.
           05 PREV-COPY-VAL OCCURS 50 TIMES PIC S9(9) COMP.

       01  RESULT-COPY.
           05 RES-COPY-SIZE      PIC 9(4) VALUE 0.
           05 RES-COPY-VAL OCCURS 50 TIMES PIC S9(9) COMP.

       01  BM-VARIABLES.
           05 I-IDX              PIC S9(4) COMP.
           05 J-IDX              PIC S9(4) COMP.
           05 K-IDX              PIC S9(4) COMP.
           05 FAIL-INDEX         PIC S9(4) COMP VALUE -1.
           05 DELTA              PIC S9(9) COMP.
           05 TERM-FAIL-INDEX-P1 PIC S9(9) COMP.
           05 COEFF              PIC S9(9) COMP.
           05 TEMP-CALC          PIC S9(9) COMP.
           05 TEMP-CALC-2        PIC S9(9) COMP.
           05 I-MINUS-FAIL-M1    PIC S9(4) COMP.

       01  COMPUTE-TERM-VARS.
           05 CT-INDEX           PIC S9(9) COMP.
           05 CT-RESULT          PIC S9(9) COMP.
           05 COEFFS-SIZE        PIC 9(4).
           05 COEFFS-VAL OCCURS 50 TIMES PIC S9(9) COMP.
           05 F-SIZE             PIC 9(4).
           05 F-VAL OCCURS 50 TIMES PIC S9(9) COMP.
           05 G-SIZE             PIC 9(4).
           05 G-VAL OCCURS 50 TIMES PIC S9(9) COMP.
           05 CT-POWER           PIC S9(9) COMP.
           05 PM-DEGREE          PIC S9(4) COMP.
           05 IS-F-MUL           PIC 9 VALUE 0.

       01  POLYMULD-VARS.
           05 PM-RES-SIZE        PIC 9(4).
           05 PM-RES-VAL OCCURS 100 TIMES PIC S9(9) COMP.
           05 PM-I               PIC S9(4) COMP.
           05 PM-J               PIC S9(4) COMP.
           05 PM-TERM            PIC S9(9) COMP.
           05 PM-IDX             PIC S9(4) COMP.

       01  MODULO-VARS.
           05 MOD-VAL PIC S9(18) COMP.

       01  PRINT-VARS.
           05 PRINT-I            PIC S9(4) COMP.
           05 PRINT-STR          PIC X(200) VALUE SPACES.
           05 STR-PTR            PIC 9(4) VALUE 1.
           05 NUM-DISP           PIC -Z(9)9.
           05 DEGREE             PIC S9(4) COMP.
           05 SIGN-STR           PIC X(5).
           05 COEFF-ABS          PIC 9(9) COMP.
           05 TERM-STR           PIC X(20).
           05 TERM-LEN           PIC 9(4).
           05 TEMP-DISP          PIC Z(9)9.
           05 DISP-VAR           PIC Z(3)9.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           MOVE 0 TO SOURCE-VAL(1)
           MOVE 1 TO SOURCE-VAL(2)
           MOVE 1 TO SOURCE-VAL(3)
           MOVE 2 TO SOURCE-VAL(4)
           MOVE 3 TO SOURCE-VAL(5)
           MOVE 5 TO SOURCE-VAL(6)
           MOVE 8 TO SOURCE-VAL(7)
           MOVE 13 TO SOURCE-VAL(8)
           MOVE 21 TO SOURCE-VAL(9)

           PERFORM COMPUTE-COEFFS

           PERFORM FORMAT-BM-COEFFS
           MOVE FUNCTION TRIM(PRINT-STR) TO PRINT-STR
           DISPLAY "Berekamp-Massey coefficients: " FUNCTION TRIM(PRINT-STR) " (lowest to highest degree)"

           PERFORM POLYNOMIAL-TO-STRING
           COMPUTE DEGREE = RESULT-SIZE - 1
           MOVE DEGREE TO DISP-VAR
           DISPLAY "The connection polynomial is " FUNCTION TRIM(PRINT-STR) " having degree " FUNCTION TRIM(DISP-VAR)
           DISPLAY " "

           DISPLAY "Terms indexed 35 to 40 from the Fibonacci sequence modulo 100:"
           MOVE SPACES TO PRINT-STR
           MOVE 1 TO STR-PTR

           MOVE 35 TO CT-INDEX
           PERFORM COMPUTE-TERM
           MOVE CT-RESULT TO DISP-VAR
           STRING FUNCTION TRIM(DISP-VAR) " " DELIMITED BY SIZE INTO PRINT-STR WITH POINTER STR-PTR

           MOVE 36 TO CT-INDEX
           PERFORM COMPUTE-TERM
           MOVE CT-RESULT TO DISP-VAR
           STRING FUNCTION TRIM(DISP-VAR) " " DELIMITED BY SIZE INTO PRINT-STR WITH POINTER STR-PTR

           MOVE 37 TO CT-INDEX
           PERFORM COMPUTE-TERM
           MOVE CT-RESULT TO DISP-VAR
           STRING FUNCTION TRIM(DISP-VAR) " " DELIMITED BY SIZE INTO PRINT-STR WITH POINTER STR-PTR

           MOVE 38 TO CT-INDEX
           PERFORM COMPUTE-TERM
           MOVE CT-RESULT TO DISP-VAR
           STRING FUNCTION TRIM(DISP-VAR) " " DELIMITED BY SIZE INTO PRINT-STR WITH POINTER STR-PTR

           MOVE 39 TO CT-INDEX
           PERFORM COMPUTE-TERM
           MOVE CT-RESULT TO DISP-VAR
           STRING FUNCTION TRIM(DISP-VAR) " " DELIMITED BY SIZE INTO PRINT-STR WITH POINTER STR-PTR

           MOVE 40 TO CT-INDEX
           PERFORM COMPUTE-TERM
           MOVE CT-RESULT TO DISP-VAR
           STRING FUNCTION TRIM(DISP-VAR) " " DELIMITED BY SIZE INTO PRINT-STR WITH POINTER STR-PTR

           DISPLAY FUNCTION TRIM(PRINT-STR)

           STOP RUN.

       COMPUTE-COEFFS.
           MOVE 0 TO RESULT-SIZE
           MOVE 0 TO PREV-RESULT-SIZE
           MOVE -1 TO FAIL-INDEX

           PERFORM VARYING I-IDX FROM 0 BY 1 UNTIL I-IDX >= SOURCE-SIZE
               COMPUTE DELTA = SOURCE-VAL(I-IDX + 1)
               PERFORM VARYING J-IDX FROM 1 BY 1 UNTIL J-IDX > RESULT-SIZE
                   COMPUTE TEMP-CALC = I-IDX - J-IDX + 1
                   COMPUTE DELTA = DELTA - RESULT-VAL(J-IDX) * SOURCE-VAL(TEMP-CALC)
               END-PERFORM

               IF DELTA NOT = 0 THEN
                   IF FAIL-INDEX = -1 THEN
                       COMPUTE RESULT-SIZE = I-IDX + 1
                       PERFORM VARYING J-IDX FROM 1 BY 1 UNTIL J-IDX > RESULT-SIZE
                           MOVE 0 TO RESULT-VAL(J-IDX)
                       END-PERFORM
                       MOVE I-IDX TO FAIL-INDEX
                   ELSE
                       MOVE 1 TO PREV-COPY-SIZE
                       MOVE 1 TO PREV-COPY-VAL(1)

                       PERFORM VARYING J-IDX FROM 1 BY 1 UNTIL J-IDX > PREV-RESULT-SIZE
                           ADD 1 TO PREV-COPY-SIZE
                           COMPUTE PREV-COPY-VAL(PREV-COPY-SIZE) = - PREV-RESULT-VAL(J-IDX)
                       END-PERFORM

                       MOVE 0 TO TERM-FAIL-INDEX-P1
                       PERFORM VARYING J-IDX FROM 1 BY 1 UNTIL J-IDX > PREV-COPY-SIZE
                           COMPUTE TEMP-CALC = FAIL-INDEX + 1 - J-IDX + 1
                           COMPUTE TERM-FAIL-INDEX-P1 = TERM-FAIL-INDEX-P1 + PREV-COPY-VAL(J-IDX) * SOURCE-VAL(TEMP-CALC)
                       END-PERFORM

                       COMPUTE COEFF = DELTA / TERM-FAIL-INDEX-P1

                       PERFORM VARYING J-IDX FROM 1 BY 1 UNTIL J-IDX > PREV-COPY-SIZE
                           COMPUTE PREV-COPY-VAL(J-IDX) = PREV-COPY-VAL(J-IDX) * COEFF
                       END-PERFORM

                       COMPUTE I-MINUS-FAIL-M1 = I-IDX - FAIL-INDEX - 1
                       IF I-MINUS-FAIL-M1 > 0 THEN
                           PERFORM VARYING J-IDX FROM PREV-COPY-SIZE BY -1 UNTIL J-IDX < 1
                               COMPUTE TEMP-CALC = J-IDX + I-MINUS-FAIL-M1
                               COMPUTE PREV-COPY-VAL(TEMP-CALC) = PREV-COPY-VAL(J-IDX)
                           END-PERFORM
                           PERFORM VARYING J-IDX FROM 1 BY 1 UNTIL J-IDX > I-MINUS-FAIL-M1
                               MOVE 0 TO PREV-COPY-VAL(J-IDX)
                           END-PERFORM
                           ADD I-MINUS-FAIL-M1 TO PREV-COPY-SIZE
                       END-IF

                       MOVE RESULT-SIZE TO RES-COPY-SIZE
                       PERFORM VARYING J-IDX FROM 1 BY 1 UNTIL J-IDX > RESULT-SIZE
                           MOVE RESULT-VAL(J-IDX) TO RES-COPY-VAL(J-IDX)
                       END-PERFORM

                       PERFORM UNTIL RESULT-SIZE >= PREV-COPY-SIZE
                           ADD 1 TO RESULT-SIZE
                           MOVE 0 TO RESULT-VAL(RESULT-SIZE)
                       END-PERFORM

                       PERFORM VARYING J-IDX FROM 1 BY 1 UNTIL J-IDX > PREV-COPY-SIZE
                           COMPUTE RESULT-VAL(J-IDX) = RESULT-VAL(J-IDX) + PREV-COPY-VAL(J-IDX)
                       END-PERFORM

                       COMPUTE TEMP-CALC = I-IDX - RES-COPY-SIZE
                       COMPUTE TEMP-CALC-2 = FAIL-INDEX - PREV-RESULT-SIZE
                       IF TEMP-CALC > TEMP-CALC-2 THEN
                           MOVE RES-COPY-SIZE TO PREV-RESULT-SIZE
                           PERFORM VARYING J-IDX FROM 1 BY 1 UNTIL J-IDX > RES-COPY-SIZE
                               MOVE RES-COPY-VAL(J-IDX) TO PREV-RESULT-VAL(J-IDX)
                           END-PERFORM
                           MOVE I-IDX TO FAIL-INDEX
                       END-IF
                   END-IF
               END-IF
           END-PERFORM.

       SAFE-MODULO.
           COMPUTE MOD-VAL = FUNCTION MOD(MOD-VAL, MODULUS)
           IF MOD-VAL < 0 THEN
               COMPUTE MOD-VAL = MOD-VAL + MODULUS
               COMPUTE MOD-VAL = FUNCTION MOD(MOD-VAL, MODULUS)
           END-IF.

       COMPUTE-TERM.
           IF RESULT-SIZE = 0 THEN
               MOVE 0 TO CT-RESULT
               EXIT PARAGRAPH
           END-IF

           IF CT-INDEX < SOURCE-SIZE THEN
               COMPUTE MOD-VAL = SOURCE-VAL(CT-INDEX + 1) + MODULUS
               PERFORM SAFE-MODULO
               COMPUTE CT-RESULT = MOD-VAL
               EXIT PARAGRAPH
           END-IF

           MOVE 1 TO COEFFS-SIZE
           COMPUTE COEFFS-VAL(1) = MODULUS - 1
           PERFORM VARYING J-IDX FROM 1 BY 1 UNTIL J-IDX > RESULT-SIZE
               ADD 1 TO COEFFS-SIZE
               MOVE RESULT-VAL(J-IDX) TO COEFFS-VAL(COEFFS-SIZE)
           END-PERFORM

           MOVE RESULT-SIZE TO F-SIZE
           MOVE RESULT-SIZE TO G-SIZE
           PERFORM VARYING J-IDX FROM 1 BY 1 UNTIL J-IDX > RESULT-SIZE
               MOVE 0 TO F-VAL(J-IDX)
               MOVE 0 TO G-VAL(J-IDX)
           END-PERFORM

           MOVE 1 TO F-VAL(1)
           IF RESULT-SIZE = 1 THEN
               MOVE COEFFS-VAL(2) TO G-VAL(1)
           ELSE
               MOVE 1 TO G-VAL(2)
           END-IF

           COMPUTE CT-POWER = CT-INDEX - 1
           PERFORM UNTIL CT-POWER <= 0
               COMPUTE TEMP-CALC = FUNCTION MOD(CT-POWER, 2)
               IF TEMP-CALC = 1 THEN
                   MOVE 1 TO IS-F-MUL
                   PERFORM POLYNOMIAL-MULTIPLY
               END-IF

               MOVE 0 TO IS-F-MUL
               PERFORM POLYNOMIAL-MULTIPLY

               COMPUTE CT-POWER = CT-POWER / 2
           END-PERFORM

           MOVE 0 TO MOD-VAL
           PERFORM VARYING I-IDX FROM 0 BY 1 UNTIL I-IDX >= RESULT-SIZE
               IF I-IDX + 1 < SOURCE-SIZE THEN
                   COMPUTE MOD-VAL = MOD-VAL + SOURCE-VAL(I-IDX + 2) * F-VAL(I-IDX + 1)
                   PERFORM SAFE-MODULO
               END-IF
           END-PERFORM

           COMPUTE MOD-VAL = MOD-VAL + MODULUS
           PERFORM SAFE-MODULO
           COMPUTE CT-RESULT = MOD-VAL.

       POLYNOMIAL-MULTIPLY.
           COMPUTE PM-RES-SIZE = 2 * RESULT-SIZE
           PERFORM VARYING PM-I FROM 1 BY 1 UNTIL PM-I > PM-RES-SIZE
               MOVE 0 TO PM-RES-VAL(PM-I)
           END-PERFORM

           PERFORM VARYING PM-I FROM 0 BY 1 UNTIL PM-I >= RESULT-SIZE
               IF IS-F-MUL = 1 THEN
                   MOVE F-VAL(PM-I + 1) TO PM-TERM
               ELSE
                   MOVE G-VAL(PM-I + 1) TO PM-TERM
               END-IF

               IF PM-TERM NOT = 0 THEN
                   PERFORM VARYING PM-J FROM 0 BY 1 UNTIL PM-J >= RESULT-SIZE
                       MOVE G-VAL(PM-J + 1) TO TEMP-CALC
                       COMPUTE PM-IDX = PM-I + PM-J + 1
                       COMPUTE MOD-VAL = PM-RES-VAL(PM-IDX) + PM-TERM * TEMP-CALC
                       PERFORM SAFE-MODULO
                       COMPUTE PM-RES-VAL(PM-IDX) = MOD-VAL
                   END-PERFORM
               END-IF
           END-PERFORM

           COMPUTE TEMP-CALC = 2 * RESULT-SIZE - 1
           PERFORM VARYING PM-I FROM TEMP-CALC BY -1 UNTIL PM-I <= RESULT-SIZE - 1
               MOVE PM-RES-VAL(PM-I + 1) TO PM-TERM
               IF PM-TERM NOT = 0 THEN
                   MOVE 0 TO PM-RES-VAL(PM-I + 1)
                   PERFORM VARYING PM-J FROM 0 BY 1 UNTIL PM-J > RESULT-SIZE
                       COMPUTE PM-IDX = PM-I - PM-J
                       IF PM-IDX >= 0 THEN
                           COMPUTE MOD-VAL = PM-RES-VAL(PM-IDX + 1) + PM-TERM * COEFFS-VAL(PM-J + 1)
                           PERFORM SAFE-MODULO
                           COMPUTE PM-RES-VAL(PM-IDX + 1) = MOD-VAL
                       END-IF
                   END-PERFORM
               END-IF
           END-PERFORM

           IF IS-F-MUL = 1 THEN
               PERFORM VARYING PM-I FROM 1 BY 1 UNTIL PM-I > RESULT-SIZE
                   COMPUTE MOD-VAL = PM-RES-VAL(PM-I)
                   PERFORM SAFE-MODULO
                   COMPUTE F-VAL(PM-I) = MOD-VAL
               END-PERFORM
           ELSE
               PERFORM VARYING PM-I FROM 1 BY 1 UNTIL PM-I > RESULT-SIZE
                   COMPUTE MOD-VAL = PM-RES-VAL(PM-I)
                   PERFORM SAFE-MODULO
                   COMPUTE G-VAL(PM-I) = MOD-VAL
               END-PERFORM
           END-IF.

       FORMAT-BM-COEFFS.
           MOVE SPACES TO PRINT-STR
           MOVE 1 TO STR-PTR
           STRING "[" DELIMITED BY SIZE INTO PRINT-STR WITH POINTER STR-PTR
           PERFORM VARYING J-IDX FROM 1 BY 1 UNTIL J-IDX > RESULT-SIZE
               MOVE RESULT-VAL(J-IDX) TO NUM-DISP
               STRING FUNCTION TRIM(NUM-DISP) DELIMITED BY SIZE INTO PRINT-STR WITH POINTER STR-PTR
               IF J-IDX < RESULT-SIZE THEN
                   STRING ", " DELIMITED BY SIZE INTO PRINT-STR WITH POINTER STR-PTR
               END-IF
           END-PERFORM
           STRING "]" DELIMITED BY SIZE INTO PRINT-STR WITH POINTER STR-PTR.

       POLYNOMIAL-TO-STRING.
           MOVE SPACES TO PRINT-STR
           MOVE 1 TO STR-PTR
           COMPUTE DEGREE = RESULT-SIZE - 1

           IF DEGREE = 0 THEN
               MOVE RESULT-VAL(1) TO NUM-DISP
               STRING FUNCTION TRIM(NUM-DISP) DELIMITED BY SIZE INTO PRINT-STR
               EXIT PARAGRAPH
           END-IF

           PERFORM VARYING PRINT-I FROM DEGREE BY -1 UNTIL PRINT-I < 0
               MOVE RESULT-VAL(PRINT-I + 1) TO COEFF
               IF COEFF NOT = 0 THEN
                   IF COEFF < 0 AND PRINT-I = DEGREE THEN
                       MOVE "-" TO SIGN-STR
                       MOVE 1 TO TERM-LEN
                   ELSE IF COEFF < 0 THEN
                       MOVE " - " TO SIGN-STR
                       MOVE 3 TO TERM-LEN
                   ELSE IF PRINT-I < DEGREE THEN
                       MOVE " + " TO SIGN-STR
                       MOVE 3 TO TERM-LEN
                   ELSE
                       MOVE "" TO SIGN-STR
                       MOVE 0 TO TERM-LEN
                   END-IF

                   IF TERM-LEN > 0 THEN
                       STRING SIGN-STR(1:TERM-LEN) DELIMITED BY SIZE
                              INTO PRINT-STR WITH POINTER STR-PTR
                   END-IF

                   COMPUTE COEFF-ABS = FUNCTION ABS(COEFF)
                   IF COEFF-ABS > 1 THEN
                       MOVE COEFF-ABS TO TEMP-DISP
                       STRING FUNCTION TRIM(TEMP-DISP) DELIMITED BY SIZE
                              INTO PRINT-STR WITH POINTER STR-PTR
                   END-IF

                   IF PRINT-I > 1 THEN
                       MOVE PRINT-I TO TEMP-DISP
                       STRING "x^" DELIMITED BY SIZE
                              FUNCTION TRIM(TEMP-DISP) DELIMITED BY SIZE
                              INTO PRINT-STR WITH POINTER STR-PTR
                   ELSE IF PRINT-I = 1 THEN
                       STRING "x" DELIMITED BY SIZE
                              INTO PRINT-STR WITH POINTER STR-PTR
                   ELSE IF COEFF-ABS = 1 THEN
                       STRING "1" DELIMITED BY SIZE
                              INTO PRINT-STR WITH POINTER STR-PTR
                   END-IF
               END-IF
           END-PERFORM.

