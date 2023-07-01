       PROGRAM-ID. NARCISSIST-NUMS.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

           01 num-length PIC 9(2) value 0.
           01 in-sum PIC  9(9) value 0.
           01 counter PIC  9(9) value 0.
           01 current-number PIC  9(9) value 0.
           01 narcissist PIC Z(9).
           01 temp PIC  9(9) value 0.
           01 modulo PIC  9(9) value 0.
           01 answer PIC  9 .

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           DISPLAY "the first 20 narcissist numbers:" .

           MOVE 20 TO counter.
           PERFORM UNTIL counter=0

               PERFORM 000-NARCISSIST-PARA

                   IF answer = 1
                       SUBTRACT 1 from counter
                       GIVING counter
                       MOVE current-number TO narcissist
                       DISPLAY narcissist
                   END-IF

                   ADD 1 TO current-number

               END-PERFORM

            STOP RUN.

       000-NARCISSIST-PARA.

             MOVE ZERO TO in-sum.
             MOVE current-number TO temp.
             COMPUTE num-length =1+  FUNCTION Log10(temp)

             PERFORM  UNTIL temp=0

                  DIVIDE temp BY 10 GIVING temp
                            REMAINDER  modulo

                  COMPUTE modulo=modulo**num-length
                  ADD modulo to in-sum GIVING in-sum

            END-PERFORM.

               IF current-number=in-sum
                   MOVE 1 TO answer
                   ELSE MOVE 0 TO answer
               END-IF.

       END PROGRAM NARCISSIST-NUMS.
