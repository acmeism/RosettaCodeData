       IDENTIFICATION DIVISION.
       PROGRAM-ID. string-case-extensions.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       78  example VALUE "alphaBETA".

       01  result  PIC X(9).

       PROCEDURE DIVISION.
           DISPLAY "Example: " example

           *> ACUCOBOL-GT
           MOVE example TO result
           CALL "C$TOLOWER" USING result, BY VALUE 9
           DISPLAY "Lower-case: " result

           MOVE example TO result
           CALL "C$TOUPPER" USING result, BY VALUE 9
           DISPLAY "Upper-case: " result

           *> Visual COBOL
           MOVE example TO result
           CALL "CBL_TOLOWER" USING result, BY VALUE 9
           DISPLAY "Lower-case: " result

           MOVE example TO result
           CALL "CBL_TOUPPER" USING result BY VALUE 9
           DISPLAY "Upper-case: " result

           GOBACK
           .
