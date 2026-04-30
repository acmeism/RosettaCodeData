       IDENTIFICATION DIVISION.
       PROGRAM-ID. myTest.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  x   PICTURE IS 9(3) VALUE IS 3.
       01  y   PICTURE IS 9(3) VALUE IS 2.
       01  z   PICTURE IS 9(9).
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
       01  x   PICTURE IS 9(3).
       01  y   PICTURE IS 9(3).
       01  z   PICTURE IS 9(9).
       PROCEDURE DIVISION USING BY REFERENCE x, y, z.
           MULTIPLY x BY y GIVING z.
           EXIT PROGRAM.
       END PROGRAM myMultiply.
