       IDENTIFICATION DIVISION.
       PROGRAM-ID. Nth-Root.
       AUTHOR.  Bill Gunshannon.
       INSTALLATION.
       DATE-WRITTEN.  4 Feb 2020.
      ************************************************************
      ** Program Abstract:
      **   Compute the Nth Root of a positive real number.
      **
      **   Takes values from console.  If Precision is left
      **   blank defaults to 0.001.
      **
      **   Enter 0 for first value to terminate program.
      ************************************************************

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
            SELECT Root-File ASSIGN TO "Root-File"
                 ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.

       FD  Root-File
           DATA RECORD IS Parameters.
       01  Parameters.
           05 Root                       PIC 9(5).
           05 Num                        PIC 9(5)V9(5).
           05 Precision                  PIC 9V9(9).


       WORKING-STORAGE SECTION.

       01  TEMP0                         PIC 9(9)V9(9).
       01  TEMP1                         PIC 9(9)V9(9).
       01  RESULTS.
           05  Field1                        PIC ZZZZZ.ZZZZZ.
           05  FILLER                        PIC X(5).
           05  Field2                        PIC ZZZZ9.
           05  FILLER                        PIC X(14).
           05  Field3                        PIC 9.999999999.

       01  HEADER.
           05  FILLER                        PIC X(72)
               VALUE "   Number           Root           Precision.".

       01  Disp-Root                         PIC ZZZZZ.ZZZZZ.

       PROCEDURE DIVISION.

       Main-Program.
           PERFORM FOREVER

              PERFORM Get-Input
              IF Precision = 0.0
                  THEN MOVE 0.001 to Precision
              END-IF

              PERFORM Compute-Root

              MOVE Root TO Field2
              MOVE Num TO Field1
              MOVE Precision TO Field3
              DISPLAY HEADER
              DISPLAY RESULTS
              DISPLAY " "
              MOVE TEMP1 TO Disp-Root
              DISPLAY "The Root is: " Disp-Root
           END-PERFORM.

       Get-Input.
           DISPLAY "Input Base Number: " WITH NO ADVANCING
           ACCEPT Num
           IF Num EQUALS ZERO
              THEN
                   DISPLAY "Good Bye."
                   STOP RUN
           END-IF
           DISPLAY "Input Root: " WITH NO ADVANCING
           ACCEPT Root
           DISPLAY "Input Desired Precision: " WITH NO ADVANCING
           ACCEPT Precision.

       Compute-Root.
          MOVE Root TO TEMP0
          DIVIDE Num BY Root GIVING TEMP1

          PERFORM UNTIL FUNCTION ABS(TEMP0 - TEMP1)
                                    LESS THAN Precision
               MOVE TEMP1 TO TEMP0
               COMPUTE TEMP1 = (( Root - 1.0) * TEMP1 + Num /
                                        TEMP1 ** (Root - 1.0)) / Root
          END-PERFORM.

       END-PROGRAM.
