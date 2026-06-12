       IDENTIFICATION DIVISION.
       PROGRAM-ID. AhoCorasickAlgorithm.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 TEXT-STRING PIC X(8) VALUE "abaaabaa".
       01 TEXT-LEN    PIC 9(4) VALUE 8.

       01 TARGETS.
          05 T-01 PIC X(5) VALUE "a    ".
          05 L-01 PIC 9(2) VALUE 1.
          05 T-02 PIC X(5) VALUE "bb   ".
          05 L-02 PIC 9(2) VALUE 2.
          05 T-03 PIC X(5) VALUE "aa   ".
          05 L-03 PIC 9(2) VALUE 2.
          05 T-04 PIC X(5) VALUE "abaa ".
          05 L-04 PIC 9(2) VALUE 4.
          05 T-05 PIC X(5) VALUE "abaaa".
          05 L-05 PIC 9(2) VALUE 5.

       01 TARGET-ARRAY-DEF REDEFINES TARGETS.
          05 TARGET-ENTRY OCCURS 5 TIMES.
             10 TARGET-STR PIC X(5).
             10 TARGET-LEN PIC 9(2).

       01 NUM-TARGETS PIC 9(4) VALUE 5.

       01 MAX-STATES PIC 9(4) VALUE 15.
       01 NEXT-STATE-ID PIC 9(4) VALUE 2.

       01 TRIE-TABLE.
          05 TRIE-NODE OCCURS 50 TIMES.
             10 NEXT-STATE OCCURS 26 TIMES PIC 9(4) VALUE 0.

       01 FAILURES-TABLE.
          05 FAILURE-STATE OCCURS 50 TIMES PIC 9(4) VALUE 0.

       01 RESULTS-MAP.
          05 RM-STATE OCCURS 50 TIMES.
             10 RM-TARGET OCCURS 5 TIMES PIC 9 VALUE 0.

       01 QUEUE-TABLE.
          05 QUEUE-ITEM OCCURS 100 TIMES PIC 9(4) VALUE 0.
       01 QUEUE-HEAD PIC 9(4) VALUE 1.
       01 QUEUE-TAIL PIC 9(4) VALUE 1.

       01 I PIC 9(4).
       01 J PIC 9(4).
       01 CH-IDX PIC 9(4).
       01 CURR-STATE PIC 9(4).
       01 NEXT-ST PIC 9(4).
       01 FAIL-ST PIC 9(4).
       01 TEMP-ST PIC 9(4).
       01 CHAR-CODE PIC 9(4).

       01 PRINT-RESULTS-TABLE.
          05 PR-TARGET OCCURS 5 TIMES.
             10 PR-MATCH OCCURS 20 TIMES.
                15 PR-INDEX PIC 9(4) VALUE 0.
             10 PR-COUNT PIC 9(4) VALUE 0.

       01 DISP-NUM PIC Z(3)9.
       01 LEAD-SPACES PIC 9(4).
       01 NUM-LEN PIC 9(4).
       01 LIST-MSG PIC X(100).
       01 LIST-POS PIC 9(4).

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM BUILD-MACHINE.
           PERFORM BUILD-FAILURES.
           PERFORM SEARCH-TARGETS.
           PERFORM PRINT-RESULTS.
           STOP RUN.

       BUILD-MACHINE.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > NUM-TARGETS
               MOVE 1 TO CURR-STATE
               PERFORM VARYING J FROM 1 BY 1 UNTIL J > TARGET-LEN(I)
                   COMPUTE CHAR-CODE =
                       FUNCTION ORD(TARGET-STR(I)(J:1)) -
                       FUNCTION ORD('a') + 1

                   IF NEXT-STATE(CURR-STATE, CHAR-CODE) = 0
                       MOVE NEXT-STATE-ID TO
                            NEXT-STATE(CURR-STATE, CHAR-CODE)
                       ADD 1 TO NEXT-STATE-ID
                   END-IF

                   MOVE NEXT-STATE(CURR-STATE, CHAR-CODE) TO CURR-STATE
               END-PERFORM

               MOVE 1 TO RM-TARGET(CURR-STATE, I)
           END-PERFORM.

       BUILD-FAILURES.
           PERFORM VARYING CH-IDX FROM 1 BY 1 UNTIL CH-IDX > 26
               IF NEXT-STATE(1, CH-IDX) > 0
                   MOVE 1 TO FAILURE-STATE(NEXT-STATE(1, CH-IDX))
                   MOVE NEXT-STATE(1, CH-IDX) TO QUEUE-ITEM(QUEUE-TAIL)
                   ADD 1 TO QUEUE-TAIL
               END-IF
           END-PERFORM

           PERFORM UNTIL QUEUE-HEAD = QUEUE-TAIL
               MOVE QUEUE-ITEM(QUEUE-HEAD) TO CURR-STATE
               ADD 1 TO QUEUE-HEAD

               PERFORM VARYING CH-IDX FROM 1 BY 1 UNTIL CH-IDX > 26
                   IF NEXT-STATE(CURR-STATE, CH-IDX) > 0
                       MOVE NEXT-STATE(CURR-STATE, CH-IDX) TO NEXT-ST
                       MOVE FAILURE-STATE(CURR-STATE) TO FAIL-ST

                       PERFORM UNTIL NEXT-STATE(FAIL-ST, CH-IDX) > 0
                                  OR FAIL-ST = 1
                           MOVE FAILURE-STATE(FAIL-ST) TO FAIL-ST
                       END-PERFORM

                       IF NEXT-STATE(FAIL-ST, CH-IDX) > 0
                           MOVE NEXT-STATE(FAIL-ST, CH-IDX)
                             TO FAILURE-STATE(NEXT-ST)
                       ELSE
                           MOVE 1 TO FAILURE-STATE(NEXT-ST)
                       END-IF

                       MOVE FAILURE-STATE(NEXT-ST) TO TEMP-ST
                       PERFORM VARYING I FROM 1 BY 1
                                 UNTIL I > NUM-TARGETS
                           IF RM-TARGET(TEMP-ST, I) = 1
                               MOVE 1 TO RM-TARGET(NEXT-ST, I)
                           END-IF
                       END-PERFORM

                       MOVE NEXT-ST TO QUEUE-ITEM(QUEUE-TAIL)
                       ADD 1 TO QUEUE-TAIL
                   END-IF
               END-PERFORM
           END-PERFORM.

       SEARCH-TARGETS.
           MOVE 1 TO CURR-STATE
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > TEXT-LEN
               COMPUTE CH-IDX =
                   FUNCTION ORD(TEXT-STRING(I:1)) -
                   FUNCTION ORD('a') + 1

               PERFORM UNTIL NEXT-STATE(CURR-STATE, CH-IDX) > 0
                          OR CURR-STATE = 1
                   MOVE FAILURE-STATE(CURR-STATE) TO CURR-STATE
               END-PERFORM

               IF NEXT-STATE(CURR-STATE, CH-IDX) > 0
                   MOVE NEXT-STATE(CURR-STATE, CH-IDX) TO CURR-STATE
               ELSE
                   MOVE 1 TO CURR-STATE
               END-IF

               PERFORM VARYING J FROM 1 BY 1 UNTIL J > NUM-TARGETS
                   IF RM-TARGET(CURR-STATE, J) = 1
                       ADD 1 TO PR-COUNT(J)
                       COMPUTE PR-INDEX(J, PR-COUNT(J)) =
                           I - TARGET-LEN(J)
                   END-IF
               END-PERFORM
           END-PERFORM.

       PRINT-RESULTS.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > NUM-TARGETS
               MOVE SPACES TO LIST-MSG
               MOVE 1 TO LIST-POS
               MOVE "[" TO LIST-MSG(LIST-POS:1)
               ADD 1 TO LIST-POS

               IF PR-COUNT(I) > 0
                   PERFORM VARYING J FROM 1 BY 1 UNTIL J > PR-COUNT(I)
                       MOVE PR-INDEX(I, J) TO DISP-NUM
                       MOVE 0 TO LEAD-SPACES
                       INSPECT DISP-NUM TALLYING LEAD-SPACES
                                        FOR LEADING " "
                       ADD 1 TO LEAD-SPACES
                       COMPUTE NUM-LEN = 4 - LEAD-SPACES + 1

                       IF J > 1
                           STRING ", " DELIMITED BY SIZE
                                  DISP-NUM(LEAD-SPACES : NUM-LEN)
                                           DELIMITED BY SIZE
                                  INTO LIST-MSG WITH POINTER LIST-POS
                           END-STRING
                       ELSE
                           STRING DISP-NUM(LEAD-SPACES : NUM-LEN)
                                           DELIMITED BY SIZE
                                  INTO LIST-MSG WITH POINTER LIST-POS
                           END-STRING
                       END-IF
                   END-PERFORM
               END-IF

               STRING "]" DELIMITED BY SIZE
                      INTO LIST-MSG WITH POINTER LIST-POS

               DISPLAY 'The word "' TARGET-STR(I)(1:TARGET-LEN(I))
                       '" appears in "' TEXT-STRING
                       '" starting at indexes '
                       LIST-MSG(1:LIST-POS - 1)
           END-PERFORM.

