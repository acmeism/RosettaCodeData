       IDENTIFICATION DIVISION.
       PROGRAM-ID. RPN.
       AUTHOR.  Bill Gunshannon.
       INSTALLATION.
       DATE-WRITTEN.  9 Feb 2020.
      ************************************************************
      ** Program Abstract:
      **   Create a stack-based evaluator for an expression in
      **   reverse Polish notation (RPN)   that also shows the
      **   changes in the stack as each individual token is
      **   processed as a table.
      ************************************************************

       DATA DIVISION.


       WORKING-STORAGE SECTION.

       01  LineIn               PIC X(25).
       01  IP                   PIC 99
                  VALUE 1.
       01  CInNum               PIC XXXX.

       01  Stack                PIC S999999V9999999
               OCCURS  50 times.
       01  SP                   PIC 99
                  VALUE 1.
       01  Operator             PIC X.
       01  Value1               PIC S999999V9999999.
       01  Value2               PIC S999999V9999999.
       01  Result               PIC S999999V9999999.
       01  Idx                  PIC 99.
       01  FormatNum            PIC ZZZZZZ9.9999999.
       01  Zip                  PIC X.

       PROCEDURE DIVISION.

       Main-Program.
            DISPLAY "Enter the RPN Equation: "
                     WITH NO ADVANCING.
            ACCEPT LineIn.

            PERFORM UNTIL IP GREATER THAN
                          FUNCTION STORED-CHAR-LENGTH(LineIn)


            UNSTRING LineIn DELIMITED BY SPACE INTO CInNum
                    WITH POINTER IP

            MOVE CInNum TO Operator

            PERFORM Do-Operation

            PERFORM Show-Stack

            END-PERFORM.

            DISPLAY "End Result: " FormatNum

           STOP RUN.

       Do-Operation.

          EVALUATE Operator
          WHEN "+"
                        PERFORM Pop
                        Compute Result = Value2 + Value1
                        PERFORM Push

          WHEN "-"
                        PERFORM Pop
                        Compute Result = Value2 - Value1
                        PERFORM Push

          WHEN "*"
                        PERFORM Pop
                        Compute Result = Value2 * Value1
                        PERFORM Push

          WHEN "/"
                        PERFORM Pop
                        Compute Result = Value2 / Value1
                        PERFORM Push

          WHEN "^"
                        PERFORM Pop
                        Compute Result = Value2 ** Value1
                        PERFORM Push

          WHEN NUMERIC
                       MOVE Operator TO Result
                       PERFORM Push
          END-EVALUATE.


       Show-Stack.

              DISPLAY "STACK: " WITH NO ADVANCING.
              MOVE 1 TO Idx.
              PERFORM UNTIL (Idx = SP)
                      MOVE Stack(Idx) TO FormatNum
                      IF Stack(Idx) IS NEGATIVE
                         THEN
                              DISPLAY "    -" FUNCTION TRIM(FormatNum)
                                             WITH NO ADVANCING
                         ELSE
                              DISPLAY FormatNum WITH NO ADVANCING
                     END-IF
                      ADD 1 to Idx
              END-PERFORM.
                      DISPLAY " ".

       Push.

             MOVE Result TO Stack(SP)
             ADD 1 TO SP.

       Pop.

            SUBTRACT 1 FROM SP
            MOVE Stack(SP) TO Value1
            SUBTRACT 1 FROM SP
            MOVE Stack(SP) TO Value2.


       END-PROGRAM.
