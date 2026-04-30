       IDENTIFICATION DIVISION.
       PROGRAM-ID. file-io.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT in-file ASSIGN "input.txt"
               ORGANIZATION LINE SEQUENTIAL.

           SELECT OPTIONAL out-file ASSIGN "output.txt"
               ORGANIZATION LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  in-file.
       01  in-line                 PIC X(256).

       FD  out-file.
       01  out-line                PIC X(256).

       PROCEDURE DIVISION.
       DECLARATIVES.
       in-file-error SECTION.
           USE AFTER ERROR ON in-file.
           DISPLAY "An error occurred while using input.txt."
           GOBACK
           .
       out-file-error SECTION.
           USE AFTER ERROR ON out-file.
           DISPLAY "An error occurred while using output.txt."
           GOBACK
           .
       END DECLARATIVES.

       mainline.
           OPEN INPUT in-file
           OPEN OUTPUT out-file

           PERFORM FOREVER
               READ in-file
                   AT END
                       EXIT PERFORM
               END-READ
               WRITE out-line FROM in-line
           END-PERFORM

           CLOSE in-file, out-file
           .
