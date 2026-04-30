       IDENTIFICATION DIVISION.
       PROGRAM-ID. accept-all-args.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  args                   PIC X(50).

       PROCEDURE DIVISION.
       main-line.
           ACCEPT args FROM COMMAND-LINE
           DISPLAY args

           GOBACK
           .
