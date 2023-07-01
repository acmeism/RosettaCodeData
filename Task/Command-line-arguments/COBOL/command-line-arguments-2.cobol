       IDENTIFICATION DIVISION.
       PROGRAM-ID. accept-args-one-at-a-time.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  arg                 PIC X(50) VALUE SPACES.

       PROCEDURE DIVISION.
           ACCEPT arg FROM ARGUMENT-VALUE
           PERFORM UNTIL arg = SPACES
               DISPLAY arg
               MOVE SPACES TO arg
               ACCEPT arg FROM ARGUMENT-VALUE
           END-PERFORM

           GOBACK
           .
