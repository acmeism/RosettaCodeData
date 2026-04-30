      *>
      *> Tectonics: ./kerighan-earth-quakes <quakes.txt
       IDENTIFICATION DIVISION.
       PROGRAM-ID. quakes.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01 data-line             PICTURE IS X(32768).
          88 no-more            VALUE IS HIGH-VALUES.

       01 date-time             PICTURE IS X(10).
       01 quake                 PICTURE IS X(20).
       01 magnitude             PICTURE IS 99V99.

       PROCEDURE DIVISION.
       show-big-ones.

       ACCEPT data-line ON EXCEPTION SET no-more TO TRUE END-ACCEPT
       PERFORM UNTIL no-more
           UNSTRING data-line DELIMITED BY ALL SPACES
              INTO date-time quake magnitude
           END-UNSTRING

           IF magnitude IS GREATER THAN 6
               DISPLAY date-time SPACE quake SPACE magnitude
           END-IF

           ACCEPT data-line ON EXCEPTION SET no-more TO TRUE END-ACCEPT
       END-PERFORM

       GOBACK.
       END PROGRAM quakes.
