       IDENTIFICATION DIVISION.
       PROGRAM-ID. factorial_test.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION factorial_iterative
           FUNCTION factorial_recursive.

       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01  i      PIC 9(38).

       PROCEDURE DIVISION.
           DISPLAY
               "i = "
               WITH NO ADVANCING
           END-DISPLAY.
           ACCEPT i END-ACCEPT.
           DISPLAY SPACE END-DISPLAY.

           DISPLAY
               "factorial_iterative(i) = "
               factorial_iterative(i)
           END-DISPLAY.

           DISPLAY
               "factorial_recursive(i) = "
               factorial_recursive(i)
           END-DISPLAY.

           GOBACK.

       END PROGRAM factorial_test.
