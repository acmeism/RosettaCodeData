       IDENTIFICATION DIVISION.
       PROGRAM-ID. Nth-Root.
       AUTHOR.  Bill Gunshannon.
       INSTALLATION. Home Office.
       DATE-WRITTEN.  26 Mar 2026.
      ************************************************************
      ** Program Abstract:
      **   Compute the Nth Root of a positive real number.
      **
      **   Takes initial value from console.
      **
      **   Prints first ten roots.
      **
      **   Enter 0 for first value to terminate program.
      ************************************************************

       ENVIRONMENT DIVISION.


       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01 Num                          PIC 9(5).
       01 Loop                         PIC 9(5).
       01 Base                         PIC 9(5)V9(5).
       01 Z                            PIC 9(5)V9(5).
       01 Precision                    PIC 9V9(9).

       01  TEMP0                       PIC 9(9)V9(9).
       01  TEMP1                       PIC 9(9)V9(9).
       01  RESULTS.
           05  Field1                  PIC ZZZZ9.
           05  FILLER   VALUE SPACES   PIC X(8).
           05  Field2                  PIC ZZZZ.ZZZZZZZZZ.

       01  HEADER.
           05  FILLER                  PIC X(72)
               VALUE "   Number           Root".

       PROCEDURE DIVISION.

       Main-Program.
           PERFORM FOREVER

              MOVE 0.000001 to Precision
              PERFORM Get-Input

              DISPLAY HEADER
              PERFORM VARYING Loop FROM 1 BY 1 UNTIL Loop  = 10
              MOVE Loop TO Num
              PERFORM Compute-Root

              MOVE Num TO Field1
              MOVE TEMP1 TO Field2
              DISPLAY RESULTS
              END-PERFORM
           END-PERFORM.

       Get-Input.
           DISPLAY "Input Base Number: " WITH NO ADVANCING
           ACCEPT Base
           IF Base EQUALS ZERO
              THEN
                   DISPLAY "Good Bye."
                   STOP RUN
           END-IF.

       Compute-Root.

          MOVE Base TO TEMP0
          DIVIDE Base BY Num GIVING TEMP1

          PERFORM WITH TEST AFTER UNTIL FUNCTION ABS(TEMP1 - TEMP0 )
                                    < Precision
               MOVE TEMP1 TO TEMP0
               COMPUTE TEMP1 = (( Num - 1.0) * TEMP1 + Base /
                                        TEMP1 ** (Num - 1.0)) / Num
          END-PERFORM.

       END-PROGRAM.

<pre>
Output:

Input Base Number: 144
   Number           Root
    1         144.000000000
    2          12.000000000
    3           5.241482788
    4           3.464101615
    5           2.701920077
    6           2.289428485
    7           2.033937009
    8           1.861209718
    9           1.737072938
Input Base Number: 0
Good Bye.

</pre>
