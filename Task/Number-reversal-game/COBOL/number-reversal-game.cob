       IDENTIFICATION DIVISION.
       PROGRAM-ID. REVERSAL.
       AUTHOR.  Bill Gunshannon
       INSTALLATION.  Home.
       DATE-WRITTEN.  11 December 2021
      ****************************************************************
      ** Program Abstract:
      **   Use a Knuth Shuffle to reate our out ot sort array.
      **   Use a procedure called "reverse" to pancake sort the array.
      ****************************************************************

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 RNUM               PIC 9.
       01 TRIES              PIC 99    VALUE 0.
       01 ANSWER     PIC 9(9)  VALUE 123456789.
       01 TBL-LEN    PIC 9    VALUE 9.
       01 TBL.
          05  TZ PIC 9(9).
          05  TA REDEFINES TZ
                 PIC 9 OCCURS 9 TIMES.

       PROCEDURE DIVISION.

       MAIN-pROGRAM.
           MOVE ANSWER TO TBL

           CALL 'KNUTH-SHUFFLE'
                 USING  BY REFERENCE TBL
           END-CALL.

           DISPLAY "TABLE after shuffle: " TBL.

           PERFORM UNTIL TBL = ANSWER
               ADD 1 TO TRIES
               DISPLAY "How many to reverse? "
               ACCEPT RNUM

               CALL 'REVERSE' USING BY CONTENT RNUM,
                      BY REFERENCE TBL
               END-CALL

               DISPLAY "Try #" TRIES "  " TBL
           END-PERFORM.
           DISPLAY "Congratulations.  You did it!"

           STOP RUN.
       END PROGRAM REVERSAL.


       IDENTIFICATION DIVISION.
       PROGRAM-ID. KNUTH-SHUFFLE.

       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01  I                       PIC 9(9).
       01  J                       PIC 9(9).
       01  TEMP                    PIC 9(9).
       01  tABLE-lEN               PIC 9  value 9.

       LINKAGE SECTION.
       01  TTABLE-AREA.
           03  TTABLE              PIC 9 OCCURS 9 TIMES.

       PROCEDURE DIVISION USING ttable-area.
           MOVE FUNCTION RANDOM(FUNCTION CURRENT-DATE (11:6)) TO I

           PERFORM VARYING i FROM Table-Len BY -1 UNTIL i = 0
               COMPUTE j =
                   FUNCTION MOD(FUNCTION RANDOM * 10000, Table-Len) + 1

               MOVE ttable (i) TO temp
               MOVE ttable (j) TO ttable (i)
               MOVE temp TO ttable (j)
           END-PERFORM.

           GOBACK.
           END PROGRAM KNUTH-SHUFFLE.


       IDENTIFICATION DIVISION.
       PROGRAM-ID. REVERSE.

       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01  I                       PIC 9.
       01  J                       PIC 9.
       01  X                       PIC 9.
       01  LOOP-IDX                PIC 9.


       LINKAGE SECTION.
       01  IDX        PIC 9.
       01  TTABLE-AREA.
           03  TTABLE              PIC 9 OCCURS 9 TIMES.

       PROCEDURE DIVISION USING IDX, TTABLE-AREA.

       DIVIDE IDX BY 2 GIVING LOOP-IDx


       MOVE 1 TO I
       MOVE IDX TO J

       PERFORM LOOP-IDX TIMES
           MOVE TTABLE(I) TO X
           MOVE TTABLE(J) TO TTABLE(I)
           MOVE X TO TTABLE(J)
           ADD 1 TO I
           SUBTRACT 1 FROM J
       END-PERFORM.

       GOBACK.
       END PROGRAM REVERSE.
