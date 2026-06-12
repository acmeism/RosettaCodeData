       IDENTIFICATION DIVISION.
       PROGRAM-ID. XMASNY.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WEEKDAYS.
          03 DAY-NAMES.
             05 FILLER   PIC X(9) VALUE "Saturday ".
             05 FILLER   PIC X(9) VALUE "Sunday   ".
             05 FILLER   PIC X(9) VALUE "Monday   ".
             05 FILLER   PIC X(9) VALUE "Tuesday  ".
             05 FILLER   PIC X(9) VALUE "Wednesday".
             05 FILLER   PIC X(9) VALUE "Thursday ".
             05 FILLER   PIC X(9) VALUE "Friday   ".
          03 DAYS        PIC X(9) OCCURS 7 TIMES,
                         REDEFINES DAY-NAMES.
       01 OUT-FMT.
          03 OUT-MONTH   PIC 99.
          03 FILLER      PIC X VALUE "/".
          03 OUT-DAY     PIC 99.
          03 FILLER      PIC X VALUE "/".
          03 OUT-YEAR    PIC 9(4).
          03 FILLER      PIC X(6) VALUE " is a ".
          03 OUT-DAYNAME PIC X(9).

       01 VARIABLES.
          03 CDATE.
             05 D-MONTH  PIC 99.
             05 D-DAY    PIC 99.
             05 D-YEAR   PIC 9999.
          03 ZELLER-DATA.
             05 M        PIC 99.
             05 Y        PIC 99.
             05 D        PIC 999.
             05 D7       PIC 999.
             05 J        PIC 99.
             05 K        PIC 99.
             05 DAY-NAME PIC X(9).

       PROCEDURE DIVISION.
       BEGIN.
           MOVE "25122021" TO CDATE.
           PERFORM SHOW-WEEKDAY.
           MOVE "01012022" TO CDATE.
           PERFORM SHOW-WEEKDAY.
           STOP RUN.

       SHOW-WEEKDAY.
           MOVE D-MONTH TO OUT-MONTH.
           MOVE D-DAY TO OUT-DAY.
           MOVE D-YEAR TO OUT-YEAR.
           PERFORM ZELLER.
           MOVE DAY-NAME TO OUT-DAYNAME.
           DISPLAY OUT-FMT.

       ZELLER.
           MOVE D-MONTH TO M.
           MOVE D-YEAR TO Y.
           IF M IS NOT GREATER THAN 2,
               ADD 12 TO M,
               SUBTRACT 1 FROM Y.
           DIVIDE Y BY 100 GIVING J.
           COMPUTE K = Y - J * 100.
           COMPUTE D = (M + 1) * 26.
           DIVIDE 10 INTO D.
           ADD K TO D.
           DIVIDE 4 INTO K.
           ADD K TO D.
           COMPUTE D = D + 5 * J.
           DIVIDE 4 INTO J.
           COMPUTE D = D + J + D-DAY.
           DIVIDE D BY 7 GIVING D7.
           MULTIPLY 7 BY D7.
           COMPUTE D = D - D7 + 1.
           MOVE DAYS(D) TO DAY-NAME.
