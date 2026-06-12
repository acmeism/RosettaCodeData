       IDENTIFICATION DIVISION.
       PROGRAM-ID. SuffixTreeProblem.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 GLOBAL-DATA IS EXTERNAL.
          05 NODE-COUNT             PIC 9(4).
          05 NODES-ARRAY            OCCURS 1000 TIMES.
             10 SUB-LEN             PIC 9(3).
             10 SUB-VAL             PIC X(100).
             10 CHILD-COUNT         PIC 9(3).
             10 CHILD-ARRAY         OCCURS 100 TIMES.
                15 CHILD-NODE-IDX   PIC 9(4).

       01 WS-STR                    PIC X(100).
       01 WS-STR-LEN                PIC 9(3).
       01 WS-I                      PIC 9(3).
       01 WS-SUF                    PIC X(100).
       01 WS-SUF-LEN                PIC 9(3).

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           MOVE "banana$" TO WS-STR
           MOVE 7 TO WS-STR-LEN

           *> Initialize root node
           MOVE 1 TO NODE-COUNT
           MOVE 0 TO SUB-LEN(1)
           MOVE SPACES TO SUB-VAL(1)
           MOVE 0 TO CHILD-COUNT(1)

           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-STR-LEN
               MOVE SPACES TO WS-SUF
               COMPUTE WS-SUF-LEN = WS-STR-LEN - WS-I + 1
               MOVE WS-STR(WS-I : WS-SUF-LEN) TO WS-SUF(1 : WS-SUF-LEN)
               CALL "addSuffix" USING WS-SUF WS-SUF-LEN
           END-PERFORM

           CALL "visualize"

           STOP RUN.
       END PROGRAM SuffixTreeProblem.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. addSuffix.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 GLOBAL-DATA IS EXTERNAL.
          05 NODE-COUNT             PIC 9(4).
          05 NODES-ARRAY            OCCURS 1000 TIMES.
             10 SUB-LEN             PIC 9(3).
             10 SUB-VAL             PIC X(100).
             10 CHILD-COUNT         PIC 9(3).
             10 CHILD-ARRAY         OCCURS 100 TIMES.
                15 CHILD-NODE-IDX   PIC 9(4).

       01 N                         PIC 9(4).
       01 I                         PIC 9(3).
       01 B                         PIC X.
       01 X2                        PIC 9(3).
       01 N2                        PIC 9(4).
       01 N3                        PIC 9(4).
       01 SUB2                      PIC X(100).
       01 SUB2-LEN                  PIC 9(3).
       01 J                         PIC 9(3).
       01 MATCH-FOUND               PIC X.

       LINKAGE SECTION.
       01 L-SUF                     PIC X(100).
       01 L-SUF-LEN                 PIC 9(3).

       PROCEDURE DIVISION USING L-SUF L-SUF-LEN.
       MAIN-LOGIC.
           MOVE 1 TO N
           MOVE 1 TO I

           PERFORM UNTIL I > L-SUF-LEN
               MOVE L-SUF(I:1) TO B
               MOVE 1 TO X2
               MOVE 'N' TO MATCH-FOUND

               PERFORM FOREVER
                   IF X2 > CHILD-COUNT(N)
                       *> no matching child, remainder suf to new node
                       ADD 1 TO NODE-COUNT
                       MOVE NODE-COUNT TO N2
                       MOVE 0 TO CHILD-COUNT(N2)

                       COMPUTE SUB-LEN(N2) = L-SUF-LEN - I + 1
                       MOVE L-SUF(I : SUB-LEN(N2))
                         TO SUB-VAL(N2)(1 : SUB-LEN(N2))

                       ADD 1 TO CHILD-COUNT(N)
                       MOVE N2 TO CHILD-NODE-IDX(N, CHILD-COUNT(N))
                       GOBACK
                   END-IF

                   MOVE CHILD-NODE-IDX(N, X2) TO N2
                   IF SUB-VAL(N2)(1:1) = B
                       MOVE 'Y' TO MATCH-FOUND
                       EXIT PERFORM
                   END-IF
                   ADD 1 TO X2
               END-PERFORM

               *> find prefix of remaining suffix in common with child
               MOVE SUB-VAL(N2) TO SUB2
               MOVE SUB-LEN(N2) TO SUB2-LEN

               MOVE 1 TO J
               MOVE 'Y' TO MATCH-FOUND

               PERFORM UNTIL J > SUB2-LEN
                   IF L-SUF(I + J - 1 : 1) NOT = SUB2(J : 1)
                       *> split n2
                       MOVE N2 TO N3

                       ADD 1 TO NODE-COUNT
                       MOVE NODE-COUNT TO N2
                       MOVE 0 TO CHILD-COUNT(N2)

                       *> temp.sub = sub2.substring(0, j)
                       COMPUTE SUB-LEN(N2) = J - 1
                       IF SUB-LEN(N2) > 0
                           MOVE SPACES TO SUB-VAL(N2)
                           MOVE SUB2(1 : SUB-LEN(N2))
                             TO SUB-VAL(N2)(1 : SUB-LEN(N2))
                       ELSE
                           MOVE SPACES TO SUB-VAL(N2)
                       END-IF

                       *> temp.ch.add(n3)
                       ADD 1 TO CHILD-COUNT(N2)
                       MOVE N3 TO CHILD-NODE-IDX(N2, CHILD-COUNT(N2))

                       *> nodes.get(n3).sub = sub2.substring(j)
                       COMPUTE SUB-LEN(N3) = SUB2-LEN - J + 1
                       MOVE SPACES TO SUB-VAL(N3)
                       MOVE SUB2(J : SUB-LEN(N3))
                         TO SUB-VAL(N3)(1 : SUB-LEN(N3))

                       *> nodes.get(n).ch.set(x2, n2)
                       MOVE N2 TO CHILD-NODE-IDX(N, X2)

                       MOVE 'N' TO MATCH-FOUND
                       EXIT PERFORM
                   END-IF
                   ADD 1 TO J
               END-PERFORM

               COMPUTE I = I + J - 1
               MOVE N2 TO N
           END-PERFORM.

           GOBACK.
       END PROGRAM addSuffix.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. visualize.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 GLOBAL-DATA IS EXTERNAL.
          05 NODE-COUNT             PIC 9(4).
          05 NODES-ARRAY            OCCURS 1000 TIMES.
             10 SUB-LEN             PIC 9(3).
             10 SUB-VAL             PIC X(100).
             10 CHILD-COUNT         PIC 9(3).
             10 CHILD-ARRAY         OCCURS 100 TIMES.
                15 CHILD-NODE-IDX   PIC 9(4).

       01 INIT-PRE            PIC X(1000) VALUE SPACES.
       01 INIT-PRE-LEN        PIC 9(4) VALUE 0.
       01 ROOT-IDX            PIC 9(4) VALUE 1.
       PROCEDURE DIVISION.
       MAIN-LOGIC.
           IF NODE-COUNT = 0
               DISPLAY "<empty>"
               GOBACK
           END-IF
           MOVE 0 TO INIT-PRE-LEN
           CALL "visualize_f" USING BY CONTENT ROOT-IDX
                                    BY REFERENCE INIT-PRE
                                    BY CONTENT INIT-PRE-LEN
           GOBACK.
       END PROGRAM visualize.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. visualize_f IS RECURSIVE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 GLOBAL-DATA IS EXTERNAL.
          05 NODE-COUNT             PIC 9(4).
          05 NODES-ARRAY            OCCURS 1000 TIMES.
             10 SUB-LEN             PIC 9(3).
             10 SUB-VAL             PIC X(100).
             10 CHILD-COUNT         PIC 9(3).
             10 CHILD-ARRAY         OCCURS 100 TIMES.
                15 CHILD-NODE-IDX   PIC 9(4).

       LOCAL-STORAGE SECTION.
       01 I               PIC 9(3).
       01 C-IDX           PIC 9(4).
       01 LAST-CHILD-IDX  PIC 9(4).
       01 NEXT-PRE        PIC X(1000).
       01 NEXT-PRE-LEN    PIC 9(4).
       01 PTR             PIC 9(4).

       LINKAGE SECTION.
       01 L-N             PIC 9(4).
       01 L-PRE           PIC X(1000).
       01 L-PRE-LEN       PIC 9(4).

       PROCEDURE DIVISION USING L-N L-PRE L-PRE-LEN.
       MAIN-LOGIC.
           IF CHILD-COUNT(L-N) = 0
               IF SUB-LEN(L-N) > 0
                   DISPLAY "- " SUB-VAL(L-N)(1:SUB-LEN(L-N))
               ELSE
                   DISPLAY "- "
               END-IF
               GOBACK
           END-IF

           IF SUB-LEN(L-N) > 0
               DISPLAY "+ " SUB-VAL(L-N)(1:SUB-LEN(L-N))
           ELSE
               DISPLAY "+ "
           END-IF

           COMPUTE LAST-CHILD-IDX = CHILD-COUNT(L-N) - 1
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LAST-CHILD-IDX
               MOVE CHILD-NODE-IDX(L-N, I) TO C-IDX

               IF L-PRE-LEN > 0
                   DISPLAY L-PRE(1:L-PRE-LEN) "+-" WITH NO ADVANCING
               ELSE
                   DISPLAY "+-" WITH NO ADVANCING
               END-IF

               MOVE SPACES TO NEXT-PRE
               MOVE 1 TO PTR
               IF L-PRE-LEN > 0
                   STRING L-PRE(1:L-PRE-LEN) DELIMITED BY SIZE
                          "| " DELIMITED BY SIZE
                          INTO NEXT-PRE
                          WITH POINTER PTR
               ELSE
                   STRING "| " DELIMITED BY SIZE
                          INTO NEXT-PRE
                          WITH POINTER PTR
               END-IF
               COMPUTE NEXT-PRE-LEN = PTR - 1

               CALL "visualize_f" USING BY CONTENT C-IDX
                                        BY REFERENCE NEXT-PRE
                                        BY CONTENT NEXT-PRE-LEN
           END-PERFORM

           MOVE CHILD-NODE-IDX(L-N, CHILD-COUNT(L-N)) TO C-IDX

           IF L-PRE-LEN > 0
               DISPLAY L-PRE(1:L-PRE-LEN) "+-" WITH NO ADVANCING
           ELSE
               DISPLAY "+-" WITH NO ADVANCING
           END-IF

           MOVE SPACES TO NEXT-PRE
           MOVE 1 TO PTR
           IF L-PRE-LEN > 0
               STRING L-PRE(1:L-PRE-LEN) DELIMITED BY SIZE
                      "  " DELIMITED BY SIZE
                      INTO NEXT-PRE
                      WITH POINTER PTR
           ELSE
               STRING "  " DELIMITED BY SIZE
                      INTO NEXT-PRE
                      WITH POINTER PTR
           END-IF
           COMPUTE NEXT-PRE-LEN = PTR - 1

           CALL "visualize_f" USING BY CONTENT C-IDX
                                    BY REFERENCE NEXT-PRE
                                    BY CONTENT NEXT-PRE-LEN

           GOBACK.
       END PROGRAM visualize_f.

