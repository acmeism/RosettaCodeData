       IDENTIFICATION DIVISION.
       PROGRAM-ID. data-munging.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT input-file ASSIGN TO INPUT-FILE-PATH
               ORGANIZATION LINE SEQUENTIAL
               FILE STATUS file-status.

       DATA DIVISION.
       FILE SECTION.
       FD  input-file.
       01  input-record.
           03  date-stamp          PIC X(10).
           03  FILLER              PIC X.
           *> Curse whoever decided to use tabs and variable length
           *> data in the file!
           03  input-data-pairs    PIC X(300).

       WORKING-STORAGE SECTION.
       78  INPUT-FILE-PATH         VALUE "readings.txt".

       01  file-status             PIC 99.
           88 file-is-ok           VALUE 0.
           88 end-of-file          VALUE 10.

       01  data-pair.
           03  val                 PIC 9(3)V9(3).
           03  flag                PIC S9.
               88  invalid-flag    VALUE -9 THRU 0.

       01  val-length              PIC 9.
       01  flag-length             PIC 9.
       01  offset                  PIC 99.

       01  day-total               PIC 9(5)V9(3).
       01  grand-total             PIC 9(8)V9(3).
       01  mean-val                PIC 9(8)V9(3).

       01  day-rejected            PIC 9(5).
       01  day-accepted            PIC 9(5).

       01  total-rejected          PIC 9(8).
       01  total-accepted          PIC 9(8).

       01  current-data-gap        PIC 9(8).
       01  max-data-gap            PIC 9(8).
       01  max-data-gap-end        PIC X(10).

       PROCEDURE DIVISION.
       DECLARATIVES.
       *> Terminate the program if an error occurs on input-file.
       input-file-error SECTION.
           USE AFTER STANDARD ERROR ON input-file.

           DISPLAY
               "An error occurred while reading input.txt. "
               "File error: " file-status
               ". The program will terminate."
           END-DISPLAY

           GOBACK
           .

       END DECLARATIVES.

       main-line.
           *> Terminate the program if the file cannot be opened.
           OPEN INPUT input-file
           IF NOT file-is-ok
               DISPLAY "File could not be opened. The program will "
                   "terminate."
               GOBACK
           END-IF

           *> Process the data in the file.
           PERFORM FOREVER
               *> Stop processing if at the end of the file.
               READ input-file
                   AT END
                       EXIT PERFORM
               END-READ

               *> Split the data up and process the value-flag pairs.
               PERFORM UNTIL input-data-pairs = SPACES
                   *> Split off the value-flag pair at the front of the
                   *> record.
                   UNSTRING input-data-pairs DELIMITED BY X"09"
                       INTO val COUNT val-length, flag COUNT flag-length

                   COMPUTE offset = val-length + flag-length + 3
                   MOVE input-data-pairs (offset:) TO input-data-pairs

                   *> Process according to flag.
                   IF NOT invalid-flag
                       ADD val TO day-total, grand-total

                       ADD 1 TO day-accepted, total-accepted

                       IF max-data-gap < current-data-gap
                           MOVE current-data-gap TO max-data-gap
                           MOVE date-stamp TO max-data-gap-end
                       END-IF

                       MOVE ZERO TO current-data-gap
                   ELSE
                       ADD 1 TO current-data-gap, day-rejected,
                           total-rejected
                   END-IF
               END-PERFORM

               *> Display day stats.
               DIVIDE day-total BY day-accepted GIVING mean-val
               DISPLAY
                   date-stamp
                   " Reject: " day-rejected
                   " Accept: " day-accepted
                   " Average: " mean-val
               END-DISPLAY

               INITIALIZE day-rejected, day-accepted, mean-val,
                   day-total
           END-PERFORM

           CLOSE input-file

           *> Display overall stats.
           DISPLAY SPACE
           DISPLAY "File:         " INPUT-FILE-PATH
           DISPLAY "Total:        " grand-total
           DISPLAY "Readings:     " total-accepted

           DIVIDE grand-total BY total-accepted GIVING mean-val
           DISPLAY "Average:      " mean-val

           DISPLAY SPACE
           DISPLAY "Bad readings: " total-rejected
           DISPLAY "Maximum number of consecutive bad readings is "
               max-data-gap
           DISPLAY "Ends on date " max-data-gap-end

           GOBACK
           .
