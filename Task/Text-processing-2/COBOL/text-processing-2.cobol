       IDENTIFICATION DIVISION.
       PROGRAM-ID. text-processing-2.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT readings ASSIGN Input-File-Path
               ORGANIZATION LINE SEQUENTIAL
               FILE STATUS file-status.

       DATA DIVISION.
       FILE SECTION.
       FD  readings.
       01  reading-record.
           03  date-stamp          PIC X(10).
           03  FILLER              PIC X.
           03  input-data          PIC X(300).

       LOCAL-STORAGE SECTION.
       78  Input-File-Path         VALUE "readings.txt".
       78  Num-Data-Points         VALUE 48.

       01  file-status             PIC XX.

       01  current-line            PIC 9(5).

       01  num-date-stamps-read    PIC 9(5).
       01  read-date-stamps-area.
           03  read-date-stamps    PIC X(10) OCCURS 1 TO 10000 TIMES
                                   DEPENDING ON num-date-stamps-read
                                   INDEXED BY date-stamp-idx.

       01  offset                  PIC 999.
       01  data-len                PIC 999.
       01  data-flag               PIC X.
           88  data-not-found      VALUE "N".

       01  data-field              PIC X(25).

       01  i                       PIC 99.

       01  num-good-readings       PIC 9(5).

       01  reading-flag            PIC X.
           88 bad-reading          VALUE "B".

       01  delim                   PIC X.

       PROCEDURE DIVISION.
       DECLARATIVES.
       readings-error SECTION.
           USE AFTER ERROR ON readings

           DISPLAY "An error occurred while using " Input-File-Path
           DISPLAY "Error code " file-status
           DISPLAY "The program will terminate."

           CLOSE readings
           GOBACK
           .
       END DECLARATIVES.

       main-line.
           OPEN INPUT readings

           *> Process each line of the file.
           PERFORM FOREVER
               READ readings
                   AT END
                       EXIT PERFORM
               END-READ

               ADD 1 TO current-line

               IF reading-record = SPACES
                   DISPLAY "Line " current-line " is blank."
                   EXIT PERFORM CYCLE
               END-IF

               PERFORM check-duplicate-date-stamp

               *> Check there are 24 data pairs and see if all the
               *> readings are ok.
               INITIALIZE offset, reading-flag, data-flag
               PERFORM VARYING i FROM 1 BY 1 UNTIL Num-Data-Points < i
                   PERFORM get-next-field
                   IF data-not-found
                       DISPLAY "Line " current-line " has missing "
                           "fields."
                       SET bad-reading TO TRUE
                       EXIT PERFORM
                   END-IF

                   *> Every other data field is the instrument flag.
                   IF FUNCTION MOD(i, 2) = 0 AND NOT bad-reading
                       IF FUNCTION NUMVAL(data-field) <= 0
                           SET bad-reading TO TRUE
                       END-IF
                   END-IF

                   ADD data-len TO offset
               END-PERFORM

               IF NOT bad-reading
                   ADD 1 TO num-good-readings
               END-IF
           END-PERFORM

           CLOSE readings

           *> Display results.
           DISPLAY SPACE
           DISPLAY current-line " lines read."
           DISPLAY num-good-readings " have good readings for all "
               "instruments."

           GOBACK
           .
       check-duplicate-date-stamp.
           SEARCH read-date-stamps
               AT END
                   ADD 1 TO num-date-stamps-read
                   MOVE date-stamp
                       TO read-date-stamps (num-date-stamps-read)

               WHEN read-date-stamps (date-stamp-idx) = date-stamp
                   DISPLAY "Date " date-stamp " is duplicated at "
                       "line " current-line "."
           END-SEARCH
           .
       get-next-field.
           INSPECT input-data (offset:) TALLYING offset
               FOR LEADING X"09"

           *> The fields are normally delimited by a tab.
           MOVE X"09" TO delim
           PERFORM find-num-chars-before-delim

           *> If the delimiter was not found...
           IF FUNCTION SUM(data-len, offset) > 300
               *> The data may be delimited by a space if it is at the
               *> end of the line.
               MOVE SPACE TO delim
               PERFORM find-num-chars-before-delim

               IF FUNCTION SUM(data-len, offset) > 300
                   SET data-not-found TO TRUE
                   EXIT PARAGRAPH
               END-IF
           END-IF

           IF data-len = 0
               SET data-not-found TO TRUE
               EXIT PARAGRAPH
           END-IF

           MOVE input-data (offset:data-len) TO data-field
           .
       find-num-chars-before-delim.
           INITIALIZE data-len
           INSPECT input-data (offset:) TALLYING data-len
               FOR CHARACTERS BEFORE delim
           .
