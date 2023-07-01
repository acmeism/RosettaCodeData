       IDENTIFICATION DIVISION.
       PROGRAM-ID.  HAMMING.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 POPCOUNT-VARIABLES.
          03 POPCOUNT-IN       PIC 9(15)V9.
          03 FILLER            REDEFINES POPCOUNT-IN.
             05 POPCOUNT-REST  PIC 9(15).
             05 FILLER         PIC 9.
                88 BIT-IS-SET  VALUE 5.
          03 POPCOUNT-OUT      PIC 99.
          03 FILLER            REDEFINES POPCOUNT-OUT.
             05 FILLER         PIC 9.
             05 FILLER         PIC 9.
                88 EVIL        VALUES 0, 2, 4, 6, 8.
                88 ODIOUS      VALUES 1, 3, 5, 7, 9.

       01 STATE-VARIABLES.
          03 CUR-POWER-3       PIC 9(15) VALUE 1.
          03 CUR-EVIL-NUM      PIC 99 VALUE 0.
          03 CUR-ODIOUS-NUM    PIC 99 VALUE 0.
          03 LINE-INDEX        PIC 99 VALUE 1.

       01 OUTPUT-FORMAT.
          03 LINENO            PIC Z9.
          03 FILLER            PIC X VALUE '.'.
          03 FILLER            PIC XX VALUE SPACES.
          03 OUT-POW3          PIC Z9.
          03 FILLER            PIC X(4) VALUE SPACES.
          03 OUT-EVIL          PIC Z9.
          03 FILLER            PIC X(4) VALUE SPACES.
          03 OUT-ODIOUS        PIC Z9.

       PROCEDURE DIVISION.
       BEGIN.
           DISPLAY "     3^   EVIL   ODD"
           PERFORM MAKE-LINE 30 TIMES.
           STOP RUN.

       MAKE-LINE.
           MOVE LINE-INDEX TO LINENO.
           MOVE CUR-POWER-3 TO POPCOUNT-IN.
           PERFORM FIND-POPCOUNT.
           MOVE POPCOUNT-OUT TO OUT-POW3.
           PERFORM FIND-EVIL.
           MOVE CUR-EVIL-NUM TO OUT-EVIL.
           PERFORM FIND-ODIOUS.
           MOVE CUR-ODIOUS-NUM TO OUT-ODIOUS.
           DISPLAY OUTPUT-FORMAT.
           MULTIPLY 3 BY CUR-POWER-3.
           ADD 1 TO CUR-EVIL-NUM.
           ADD 1 TO CUR-ODIOUS-NUM.
           ADD 1 TO LINE-INDEX.

       FIND-EVIL.
           MOVE CUR-EVIL-NUM TO POPCOUNT-IN.
           PERFORM FIND-POPCOUNT.
           IF NOT EVIL, ADD 1 TO CUR-EVIL-NUM, GO TO FIND-EVIL.

       FIND-ODIOUS.
           MOVE CUR-ODIOUS-NUM TO POPCOUNT-IN.
           PERFORM FIND-POPCOUNT.
           IF NOT ODIOUS, ADD 1 TO CUR-ODIOUS-NUM, GO TO FIND-ODIOUS.

       FIND-POPCOUNT.
           MOVE 0 TO POPCOUNT-OUT.
           PERFORM PROCESS-BIT UNTIL POPCOUNT-IN IS EQUAL TO ZERO.

       PROCESS-BIT.
           DIVIDE 2 INTO POPCOUNT-IN.
           IF BIT-IS-SET, ADD 1 TO POPCOUNT-OUT.
           MOVE POPCOUNT-REST TO POPCOUNT-IN.
