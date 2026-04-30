       IDENTIFICATION DIVISION.
       PROGRAM-ID. string-case-85.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  example PIC X(9) VALUE "alphaBETA".

       01  result  PIC X(9).

       PROCEDURE DIVISION.
           DISPLAY "Example: " example

           *> Using the intrinsic functions.
           DISPLAY "Lower-case: " FUNCTION LOWER-CASE(example)

           DISPLAY "Upper-case: " FUNCTION UPPER-CASE(example)

           *> Using INSPECT
           MOVE example TO result
           INSPECT result CONVERTING "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
               TO "abcdefghijklmnopqrstuvwxyz"
           DISPLAY "Lower-case: " result

           MOVE example TO result
           INSPECT result CONVERTING "abcdefghijklmnopqrstuvwxyz"
               TO  "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
           DISPLAY "Upper-case: " result

           GOBACK
           .
