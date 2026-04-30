       IDENTIFICATION DIVISION.
       PROGRAM-ID.          recurse RECURSIVE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  Starter          PIC S9(8) VALUE 1.
       PROCEDURE DIVISION.
       Program-Recurse.
           CALL "recurse-sub" USING Starter
           STOP RUN.

       IDENTIFICATION DIVISION.
       PROGRAM-ID.          recurse-sub.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01  Countr                      PIC S9(8).
       PROCEDURE DIVISION USING Countr.
       Program-Recursive.
           DISPLAY Countr
           ADD 1   TO Countr
           CALL "recurse-sub" USING Countr

           EXIT PROGRAM.
       END PROGRAM recurse-sub.
       END PROGRAM recurse.
