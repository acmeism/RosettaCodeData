       IDENTIFICATION DIVISION.
       PROGRAM-ID. myTest.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION myMultiply.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  x   PIC 9(3) VALUE 3.
       01  y   PIC 9(3) VALUE 2.
       PROCEDURE DIVISION.
           DISPLAY myMultiply(x, y).
           STOP RUN.
       END PROGRAM myTest.

       IDENTIFICATION DIVISION.
       FUNCTION-ID. myMultiply.
       DATA DIVISION.
       LINKAGE SECTION.
       01  x   PIC 9(3).
       01  y   PIC 9(3).
       01  z   pic 9(9).
       PROCEDURE DIVISION USING x, y RETURNING z.
           MULTIPLY x BY y GIVING z.
           EXIT FUNCTION.
       END FUNCTION myMultiply.
