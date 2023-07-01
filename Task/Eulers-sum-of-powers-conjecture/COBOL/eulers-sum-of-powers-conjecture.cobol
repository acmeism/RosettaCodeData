       IDENTIFICATION DIVISION.
       PROGRAM-ID. EULER.
       DATA DIVISION.
       FILE SECTION.
       WORKING-STORAGE SECTION.
       1   TABLE-LENGTH CONSTANT 250.
       1   SEARCHING-FLAG     PIC 9.
        88  FINISHED-SEARCHING VALUE IS 1
                               WHEN SET TO FALSE IS 0.
       1  CALC.
        3  A               PIC 999 USAGE COMPUTATIONAL-5.
        3  B               PIC 999 USAGE COMPUTATIONAL-5.
        3  C               PIC 999 USAGE COMPUTATIONAL-5.
        3  D               PIC 999 USAGE COMPUTATIONAL-5.
        3  ABCD            PIC 9(18) USAGE COMPUTATIONAL-5.
        3  FIFTH-ROOT-OFFS PIC 999 USAGE COMPUTATIONAL-5.
        3  POWER-COUNTER   PIC 999 USAGE COMPUTATIONAL-5.
        88 POWER-MAX       VALUE TABLE-LENGTH.

       1   PRETTY.
        3  A               PIC ZZ9.
        3  FILLER          VALUE "^5 + ".
        3  B               PIC ZZ9.
        3  FILLER          VALUE "^5 + ".
        3  C               PIC ZZ9.
        3  FILLER          VALUE "^5 + ".
        3  D               PIC ZZ9.
        3  FILLER          VALUE "^5 = ".
        3  FIFTH-ROOT-OFFS PIC ZZ9.
        3  FILLER          VALUE "^5.".

       1   FIFTH-POWER-TABLE   OCCURS TABLE-LENGTH TIMES
                               ASCENDING KEY IS FIFTH-POWER
                               INDEXED BY POWER-INDEX.
        3  FIFTH-POWER PIC 9(18) USAGE COMPUTATIONAL-5.


       PROCEDURE DIVISION.
       MAIN-PARAGRAPH.
           SET FINISHED-SEARCHING TO FALSE.
           PERFORM POWERS-OF-FIVE-TABLE-INIT.
           PERFORM VARYING
               A IN CALC
               FROM 1 BY 1 UNTIL A IN CALC = TABLE-LENGTH

               AFTER B IN CALC
               FROM 1 BY 1 UNTIL B IN CALC = A IN CALC

               AFTER C IN CALC
               FROM 1 BY 1 UNTIL C IN CALC = B IN CALC

               AFTER D IN CALC
               FROM 1 BY 1 UNTIL D IN CALC = C IN CALC

               IF FINISHED-SEARCHING
                   STOP RUN
               END-IF

               PERFORM POWER-COMPUTATIONS

           END-PERFORM.

       POWER-COMPUTATIONS.

           MOVE ZERO TO ABCD IN CALC.

           ADD FIFTH-POWER(A IN CALC)
               FIFTH-POWER(B IN CALC)
               FIFTH-POWER(C IN CALC)
               FIFTH-POWER(D IN CALC)
                   TO ABCD IN CALC.

           SET POWER-INDEX TO 1.

           SEARCH ALL FIFTH-POWER-TABLE
               WHEN FIFTH-POWER(POWER-INDEX) = ABCD IN CALC
                      MOVE POWER-INDEX TO FIFTH-ROOT-OFFS IN CALC
                      MOVE CORRESPONDING CALC TO PRETTY
                      DISPLAY PRETTY END-DISPLAY
                      SET FINISHED-SEARCHING TO TRUE
           END-SEARCH

           EXIT PARAGRAPH.

       POWERS-OF-FIVE-TABLE-INIT.
           PERFORM VARYING POWER-COUNTER FROM 1 BY 1 UNTIL POWER-MAX
               COMPUTE FIFTH-POWER(POWER-COUNTER) =
                   POWER-COUNTER *
                   POWER-COUNTER *
                   POWER-COUNTER *
                   POWER-COUNTER *
                   POWER-COUNTER
               END-COMPUTE
           END-PERFORM.
           EXIT PARAGRAPH.

       END PROGRAM EULER.
