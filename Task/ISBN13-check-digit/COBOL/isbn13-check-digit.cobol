      ******************************************************************
      * Author: Jay Moseley
      * Date: November 10, 2019
      * Purpose: Testing various subprograms/ functions.
      * Tectonics: cobc -xj testSubs.cbl
      ******************************************************************
       IDENTIFICATION DIVISION.

       PROGRAM-ID. testSubs.
       ENVIRONMENT DIVISION.

       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION ALL INTRINSIC
           FUNCTION validISBN13.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

       DATA DIVISION.

       FILE SECTION.

       WORKING-STORAGE SECTION.

       01  IX                          PIC S9(4) COMP.
       01  TEST-ISBNS.
           02  FILLER                  PIC X(14) VALUE '978-0596528126'.
           02  FILLER                  PIC X(14) VALUE '978-0596528120'.
           02  FILLER                  PIC X(14) VALUE '978-1788399081'.
           02  FILLER                  PIC X(14) VALUE '978-1788399083'.
       01  TEST-ISBN                   REDEFINES TEST-ISBNS
                                       OCCURS 4 TIMES
                                       PIC X(14).

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.

           PERFORM
             VARYING IX
             FROM 1
             BY 1
             UNTIL IX > 4

             DISPLAY TEST-ISBN (IX) '   ' WITH NO ADVANCING
             END-DISPLAY
             IF validISBN13(TEST-ISBN (IX)) = -1
               DISPLAY '(bad)'
             ELSE
               DISPLAY '(good)'
             END-IF

           END-PERFORM.

           GOBACK.

       END PROGRAM testSubs.

      ******************************************************************
      * Author: Jay Moseley
      * Date: May 19, 2016
      * Purpose: validate ISBN-13 (International Standard
      *          Book Number).
      ******************************************************************
       IDENTIFICATION DIVISION.

       FUNCTION-ID. validISBN13.
       ENVIRONMENT DIVISION.

       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION ALL INTRINSIC.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

       DATA DIVISION.

       FILE SECTION.

       WORKING-STORAGE SECTION.

       01  PASSED-SIZE                 PIC S9(6) COMP-5.
       01  IX                          PIC S9(4) COMP.

       01  WORK-FIELDS.
           02  WF-DIGIT                PIC X.
           02  WF-COUNT                PIC 9(2).
               88  WEIGHT-1  VALUE 1, 3, 5, 7, 9, 11, 13.
               88  WEIGHT-3  VALUE 2, 4, 6, 8, 10, 12.
           02  WF-SUM                  PIC S9(8) COMP.

       LINKAGE SECTION.

       01  PASSED-ISBN                 PIC X ANY LENGTH.
       01  RETURN-VALUE                PIC S9.

       PROCEDURE DIVISION USING PASSED-ISBN
                          RETURNING RETURN-VALUE.

           CALL 'C$PARAMSIZE'
             USING 1
             GIVING PASSED-SIZE
           END-CALL.

       COMPUTE-CKDIGIT.

           INITIALIZE WORK-FIELDS.
           PERFORM
             VARYING IX
             FROM 1
             BY 1
             UNTIL IX GREATER THAN PASSED-SIZE

               MOVE PASSED-ISBN (IX:1) TO WF-DIGIT
               IF WF-DIGIT IS NUMERIC
                 ADD 1 TO WF-COUNT
                 IF WEIGHT-1
                   ADD NUMVAL(WF-DIGIT) TO WF-SUM
                 ELSE
                   COMPUTE WF-SUM = WF-SUM +
                     (NUMVAL(WF-DIGIT) * 3)
                   END-COMPUTE
                 END-IF
               END-IF

           END-PERFORM.

           IF MOD(WF-SUM, 10) = 0
             MOVE +0 TO RETURN-VALUE
           ELSE
             MOVE -1 TO RETURN-VALUE
           END-IF.

           GOBACK.
      * - - - - - - - - - - - - - - - - - - - - - - PROGRAM EXIT POINT

       END FUNCTION validISBN13.
