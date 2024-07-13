       IDENTIFICATION DIVISION.
       PROGRAM-ID. NIM-GAME.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 MONTON PIC 99 VALUE 12.
       01 LLEVAR PIC 9 VALUE 0.
       01 TEMP   PIC 9.

       PROCEDURE DIVISION.
           PERFORM UNTIL MONTON = 0
               DISPLAY "There are " MONTON " tokens remaining. How many"
       "would you like to take? "
               ACCEPT LLEVAR
               PERFORM UNTIL LLEVAR > 0 AND LLEVAR < 4
                   DISPLAY "You must take 1, 2, or 3 tokens. How many"
       "would you like to take "
                   ACCEPT LLEVAR
               END-PERFORM
               COMPUTE TEMP = 4 - LLEVAR
               DISPLAY "On my turn I will take " TEMP " token(s)."
               SUBTRACT 4 FROM MONTON
           END-PERFORM
           DISPLAY " "
           DISPLAY "I got the last token. I win! Better luck next time."
           STOP RUN.
