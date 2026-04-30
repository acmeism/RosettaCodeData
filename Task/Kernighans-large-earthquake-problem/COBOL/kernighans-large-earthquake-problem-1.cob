*>
*> Kernighan large earthquake problem
*> Tectonics: cobc -xj kernighan-earth-quakes.cob
*>            quakes.txt with the 3 sample lines
*>            ./kernighan-earth-quakes
*>
 >>SOURCE FORMAT IS FREE
 IDENTIFICATION DIVISION.
 PROGRAM-ID. quakes.

 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 REPOSITORY.
     FUNCTION ALL INTRINSIC.

 INPUT-OUTPUT SECTION.
 FILE-CONTROL.
     SELECT quake-data
         ASSIGN TO command-filename
         ORGANIZATION IS LINE SEQUENTIAL
         STATUS IS quake-fd-status.

 DATA DIVISION.
 FILE SECTION.
 FD quake-data RECORD VARYING DEPENDING ON line-length.
     01 data-line         PICTURE IS X(32768).

 WORKING-STORAGE SECTION.
 01 quake-fd-status       PICTURE IS XX.
    88 ok                 VALUES ARE "00", "01", "02", "03", "04",
                                     "05", "06", "07", "08", "09".
    88 no-more            VALUE IS "10".
    88 io-error           VALUE IS HIGH-VALUE.

 01 line-length           USAGE IS BINARY-LONG.

 01 date-time             PICTURE IS X(10).
 01 quake                 PICTURE IS X(20).
 01 magnitude             PICTURE IS 99V99.

 01 command-filename      PICTURE IS X(80).

 PROCEDURE DIVISION.
 show-big-ones.

     ACCEPT command-filename FROM COMMAND-LINE
     IF command-filename IS EQUAL TO SPACES THEN
         MOVE "data.txt" TO command-filename
     END-IF

     OPEN INPUT quake-data
     PERFORM status-check
     IF io-error THEN
         DISPLAY TRIM(command-filename) " not found" UPON SYSERR
         GOBACK
     END-IF

     READ quake-data
     PERFORM status-check
     PERFORM UNTIL no-more OR io-error
         UNSTRING data-line DELIMITED BY ALL SPACES
            INTO date-time quake magnitude
         END-UNSTRING

         IF magnitude IS GREATER THAN 6
             DISPLAY date-time SPACE quake SPACE magnitude
         END-IF

         READ quake-data
         PERFORM status-check
     END-PERFORM

     CLOSE quake-data
     PERFORM status-check
     GOBACK.
*>   ****

 status-check.
     IF NOT ok AND NOT no-more THEN   *> not normal status, bailing
         DISPLAY "io error: " quake-fd-status UPON SYSERR
         SET io-error TO TRUE
     END-IF
     EXIT PARAGRAPH.

 END PROGRAM quakes.
