       IDENTIFICATION DIVISION.
       PROGRAM-ID.  MCNUGGETS.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 NUGGETS.
          03 NUGGET-FLAGS     PIC X OCCURS 100 TIMES.
             88 IS-NUGGET     VALUE 'X'.

       01 A                   PIC 999.
       01 B                   PIC 999.
       01 C                   PIC 999.

       PROCEDURE DIVISION.
       BEGIN.
           MOVE SPACES TO NUGGETS.
           PERFORM A-LOOP VARYING A FROM 0 BY 6
               UNTIL A IS GREATER THAN 100.
           MOVE 100 TO A.

       FIND-LARGEST.
           IF IS-NUGGET(A), SUBTRACT 1 FROM A, GO TO FIND-LARGEST.
           DISPLAY 'Largest non-McNugget number: ', A.
           STOP RUN.

       A-LOOP.
           PERFORM B-LOOP VARYING B FROM A BY 9
               UNTIL B IS GREATER THAN 100.

       B-LOOP.
           PERFORM C-LOOP VARYING C FROM B BY 20
               UNTIL C IS GREATER THAN 100.

       C-LOOP.
           IF C IS NOT EQUAL TO ZERO, MOVE 'X' TO NUGGET-FLAGS(C).
