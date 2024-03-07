      * Pointing out some interesting things:
      *    - BY 0 subclause of VARYING (illegal in some COBOL dialects)
      *    - PERFORM THROUGH with internal/external GO TOs
      *    - using non-reserved keywords (END, DATA)
      *    - ALTER (works the same way in COBOL)
      *    - fall-through from MANY-BOTTLES
      *    - the last NEXT SENTENCE does nothing (plays the role of EXIT)
       IDENTIFICATION DIVISION.
           PROGRAM-ID. 99 BOTTLES.
       DATA DIVISION.
       01 DATA PICTURE IS 999.
       PROCEDURE DIVISION.
           LOOP VARYING DATA FROM 99 BY 0
               PERFORM COUNT-BOTTLES THROUGH END
               DISPLAY DATA "bottles of beer"
               DISPLAY "Take one down, pass it around"
               SUBTRACT 1 FROM DATA
               IF DATA = 1
               THEN ALTER COUNT-BOTTLES TO PROCEED TO SINGLE-BOTTLE
               END
               PERFORM COUNT-BOTTLES THROUGH END
               DISPLAY ""
           END.
       NO-BOTTLES-LEFT.
           DISPLAY "No bottles of beer on the wall"
           DISPLAY ""
           DISPLAY "Go to the store and buy some more"
           DISPLAY "99 bottles of beer on the wall".
           STOP.
       COUNT-BOTTLES.
           GO TO MANY-BOTTLES.
       SINGLE-BOTTLE.
           DISPLAY DATA "bottle of beer on the wall".
           GO TO NO-BOTTLES-LEFT.
       MANY-BOTTLES.
           DISPLAY DATA "bottles of beer on the wall".
       END.
           NEXT SENTENCE.
