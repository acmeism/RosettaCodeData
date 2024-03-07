      * NB: the implementation is rather vanilla
      * besides using the idiomatic buffer overrun.
      * LOOP is what PERFORM in COBOL is, with defaults.
      * MOVE in this language acts like OVE CORRESPONDING,
      * which is actually good here.
       IDENTIFICATION DIVISION.
           PROGRAM-ID. ONE HUNDRED DOORS.
       DATA DIVISION.
       01 I PICTURE IS 9(3).
       01 J LIKE I.
       01 DOOR PICTURE IS 9 OCCURS 100 TIMES.
       01 STOP LIKE DOOR.
       PROCEDURE DIVISION.
      * Initialise the data
           MOVE HIGH-VALUES TO STOP
           MOVE SPACES TO DOOR.
      * Do the main algorithm
           LOOP VARYING I UNTIL DOOR(I) = 9
               LOOP VARYING J FROM I TO 100 BY I
                   SUBTRACT DOOR (J) FROM 1 GIVING DOOR (J)
               END
           END.
      * Print the results
           LOOP VARYING I UNTIL DOOR(I) = 9
               DISPLAY "Door" I "is" WITH NO ADVANCING
               IF DOOR (I) = 1
               THEN DISPLAY "open"
               ELSE DISPLAY "closed".
           END.
