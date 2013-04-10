       IDENTIFICATION DIVISION.
       PROGRAM-ID. 100Doors.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 Current        PIC 9(3)   VALUE ZEROES.
       01 StepSize       PIC 9(3)   VALUE ZEROES.
       01 DoorTable.
          02 Doors       PIC 9(1)   OCCURS 100 TIMES.
       01 Idx            PIC 9(3).

       PROCEDURE DIVISION.
       Begin.
           MOVE 1 TO StepSize
           PERFORM 100 TIMES
             MOVE StepSize TO Current
             PERFORM UNTIL Current > 100
               SUBTRACT Doors(Current) FROM 1 GIVING Doors(Current)
               ADD StepSize TO Current GIVING Current
             END-PERFORM
             ADD 1 TO StepSize GIVING StepSize
           END-PERFORM
           PERFORM VARYING Idx FROM 1 BY 1
                   UNTIL Idx > 100
             IF Doors(Idx) = 0
               DISPLAY Idx " is closed."
             ELSE
               DISPLAY Idx " is open."
             END-IF
           END-PERFORM
           STOP RUN.
