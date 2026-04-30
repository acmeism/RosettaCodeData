       IDENTIFICATION DIVISION.
       PROGRAM-ID. Loop-N-And-Half.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  I    PIC 99.
       01  List PIC X(45).

       PROCEDURE DIVISION.
           PERFORM FOREVER
               *> The list to display must be built up because using
               *> DISPLAY adds an endline at the end automatically.
               STRING FUNCTION TRIM(List) " "  I  INTO List

               IF I = 10
                   EXIT PERFORM
               END-IF

               STRING FUNCTION TRIM(List) "," INTO List

               ADD 1 TO I
           END-PERFORM

           DISPLAY List

           GOBACK
           .
