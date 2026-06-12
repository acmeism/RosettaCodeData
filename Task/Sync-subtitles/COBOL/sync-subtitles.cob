       IDENTIFICATION DIVISION.
       PROGRAM-ID. SubtitleSync.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO "movie.srt".
           SELECT OUTPUT-FILE ASSIGN TO "movie_corrected.srt".
       DATA DIVISION.
       FILE SECTION.
       FD INPUT-FILE.
       01 IN-REC PIC X(100).
       FD OUTPUT-FILE.
       01 OUT-REC PIC X(100).
       WORKING-STORAGE SECTION.
       01 WS-SECS PIC S9(4) COMP VALUE 0.
       01 WS-LINE PIC X(100) VALUE SPACES.
       01 WS-START-TIME PIC X(12) VALUE SPACES.
       01 WS-END-TIME PIC X(12) VALUE SPACES.
       01 WS-HH PIC 99 VALUE 0.
       01 WS-MM PIC 99 VALUE 0.
       01 WS-SS PIC 99 VALUE 0.
       01 WS-TTT PIC 999 VALUE 0.
       PROCEDURE DIVISION.
           DISPLAY "After fast-forwarding 9 seconds:"
           MOVE 9 TO WS-SECS
           OPEN INPUT INPUT-FILE
           OPEN OUTPUT OUTPUT-FILE
           PERFORM syncSubtitles
           CLOSE INPUT-FILE
           CLOSE OUTPUT-FILE
           DISPLAY "After rolling-back 9 seconds:"
           MOVE -9 TO WS-SECS
           OPEN INPUT INPUT-FILE
           OPEN OUTPUT OUTPUT-FILE
           PERFORM syncSubtitles
           CLOSE INPUT-FILE
           CLOSE OUTPUT-FILE
           STOP RUN.

       syncSubtitles SECTION.
           READ INPUT-FILE AT END GO TO CLOSE-FILES
               IF WS-LINE(1:3) = "-->" THEN
                   MOVE WS-LINE(1:12) TO WS-START-TIME
                   MOVE WS-LINE(18:12) TO WS-END-TIME
                   PERFORM addSeconds
                   MOVE WS-START-TIME TO WS-LINE(1:12)
                   PERFORM addSeconds
                   MOVE WS-END-TIME TO WS-LINE(18:12)
                   STRING WS-START-TIME DELIMITED BY SIZE " --> "
       DELIMITED BY SIZE WS-END-TIME DELIMITED BY SIZE INTO OUT-REC
                   WRITE OUT-REC
               ELSE
                   MOVE WS-LINE TO OUT-REC
                   WRITE OUT-REC
               END-IF
           END-READ
           CLOSE INPUT-FILE
           CLOSE OUTPUT-FILE
           EXIT.

       addSeconds SECTION.
           MOVE WS-START-TIME(1:2) TO WS-HH
           MOVE WS-START-TIME(4:2) TO WS-MM
           MOVE WS-START-TIME(7:2) TO WS-SS
           MOVE WS-START-TIME(10:3) TO WS-TTT
           ADD WS-SECS TO WS-SS
           IF WS-SS < 0
               ADD 60 TO WS-SS
               SUBTRACT 1 FROM WS-MM
           END-IF
           IF WS-MM < 0
               ADD 60 TO WS-MM
               SUBTRACT 1 FROM WS-HH
           END-IF
           IF WS-HH < 0
               ADD 24 TO WS-HH
           END-IF
           DIVIDE WS-SS BY 60 GIVING WS-MM REMAINDER WS-SS
           DIVIDE WS-MM BY 60 GIVING WS-HH REMAINDER WS-MM
           MOVE WS-HH TO WS-START-TIME(1:2)
           MOVE WS-MM TO WS-START-TIME(4:2)
           MOVE WS-SS TO WS-START-TIME(7:2)
           MOVE WS-TTT TO WS-START-TIME(10:3)
           EXIT.
       CLOSE-FILES SECTION.
           CLOSE INPUT-FILE
           CLOSE OUTPUT-FILE
           EXIT.

