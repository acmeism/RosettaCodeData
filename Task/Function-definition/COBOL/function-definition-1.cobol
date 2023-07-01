       IDENTIFICATION DIVISION.
       PROGRAM-ID. myTest.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  x   PIC 9(3) VALUE 3.
       01  y   PIC 9(3) VALUE 2.
       01  z   PIC 9(9).
       PROCEDURE DIVISION.
           CALL "myMultiply" USING
               BY CONTENT x, BY CONTENT y,
               BY REFERENCE z.
           DISPLAY z.
           STOP RUN.
       END PROGRAM myTest.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. myMultiply.
       DATA DIVISION.
       LINKAGE SECTION.
       01  x   PIC 9(3).
       01  y   PIC 9(3).
       01  z   PIC 9(9).
       PROCEDURE DIVISION USING x, y, z.
           MULTIPLY x BY y GIVING z.
           EXIT PROGRAM.
       END PROGRAM myMultiply.
