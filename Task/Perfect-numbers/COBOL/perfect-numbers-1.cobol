      $set REPOSITORY "UPDATE ON"

       IDENTIFICATION DIVISION.
       PROGRAM-ID. perfect-main.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION perfect
           .
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  i                      PIC 9(8).

       PROCEDURE DIVISION.
           PERFORM VARYING i FROM 2 BY 1 UNTIL 33550337 = i
               IF FUNCTION perfect(i) = 0
                   DISPLAY i
               END-IF
           END-PERFORM

           GOBACK
           .
       END PROGRAM perfect-main.
