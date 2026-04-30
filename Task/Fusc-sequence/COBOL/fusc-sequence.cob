IDENTIFICATION DIVISION.
       PROGRAM-ID. FUSC-SEQUENCE.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  FUSC-MAX                  PIC 9(8) COMP VALUE 2000.
       01  FUSC-TABLE.
           05  FUSC-VAL OCCURS 2000 TIMES
                                     PIC 9(8) COMP.

       01  WS-N                      PIC 9(8) COMP.
       01  WS-I                      PIC 9(2) COMP.
       01  WS-J                      PIC 9(8) COMP.
       01  WS-START                  PIC 9(8) COMP.
       01  WS-VAL                    PIC S9(8) COMP.
       01  WS-HALF                   PIC 9(8) COMP.
       01  WS-HALF-MINUS             PIC 9(8) COMP.
       01  WS-HALF-PLUS              PIC 9(8) COMP.
       01  WS-POWER                  PIC 9(8) COMP.
       01  WS-IDX                    PIC 9(8) COMP.
       01  WS-FOUND                  PIC X VALUE 'N'.
       01  WS-DISPLAY-IDX            PIC Z(7)9.
       01  WS-DISPLAY-VAL            PIC Z(7)9.

       PROCEDURE DIVISION.

       000-MAIN SECTION.
       MAIN-PARA.
           PERFORM 100-INIT-FUSC
           PERFORM 200-DISPLAY-FIRST-61
           PERFORM 300-DISPLAY-LENGTH-RECORDS
           STOP RUN.

      *>----------------------------------------------------------------
      *> Initialize the FUSC array
      *>----------------------------------------------------------------
       100-INIT-FUSC SECTION.
           MOVE 0 TO FUSC-VAL(1)
           MOVE 1 TO FUSC-VAL(2)
           PERFORM VARYING WS-N FROM 3 BY 1
               UNTIL WS-N > FUSC-MAX
               EVALUATE TRUE
                   WHEN FUNCTION MOD(WS-N - 1, 2) = 0
                       COMPUTE WS-HALF = (WS-N - 1) / 2 + 1
                       MOVE FUSC-VAL(WS-HALF) TO FUSC-VAL(WS-N)
                   WHEN OTHER
                       COMPUTE WS-HALF-MINUS =
                           (WS-N - 2) / 2 + 1
                       COMPUTE WS-HALF-PLUS  =
                           WS-N / 2 + 1
                       COMPUTE FUSC-VAL(WS-N) =
                           FUSC-VAL(WS-HALF-MINUS) +
                           FUSC-VAL(WS-HALF-PLUS)
               END-EVALUATE
           END-PERFORM.

      *>----------------------------------------------------------------
      *> Display first 61 fusc numbers (0-based index 0..60)
      *>----------------------------------------------------------------
       200-DISPLAY-FIRST-61 SECTION.
           DISPLAY "Show the first 61 fusc numbers "
               "(starting at zero) in a horizontal format"
           PERFORM VARYING WS-N FROM 1 BY 1
               UNTIL WS-N > 61
               MOVE FUSC-VAL(WS-N) TO WS-DISPLAY-VAL
               DISPLAY FUNCTION TRIM(WS-DISPLAY-VAL
                   LEADING) " " WITH NO ADVANCING
           END-PERFORM
           DISPLAY " ".

      *>----------------------------------------------------------------
      *> Display fusc numbers whose value first exceeds 10^i
      *>----------------------------------------------------------------
       300-DISPLAY-LENGTH-RECORDS SECTION.
           DISPLAY " "
           DISPLAY "Show the fusc number (and its index) whose "
               "length is greater than any previous fusc number length."
           MOVE 1 TO WS-START
           PERFORM VARYING WS-I FROM 0 BY 1
               UNTIL WS-I > 5
               EVALUATE WS-I
                   WHEN 0
                       MOVE -1 TO WS-VAL
                   WHEN OTHER
                       MOVE 1 TO WS-POWER
                       PERFORM VARYING WS-IDX FROM 1 BY 1
                           UNTIL WS-IDX > WS-I
                           MULTIPLY 10 BY WS-POWER
                       END-PERFORM
                       MOVE WS-POWER TO WS-VAL
               END-EVALUATE
               MOVE 'N' TO WS-FOUND
               PERFORM VARYING WS-J FROM WS-START BY 1
                   UNTIL WS-J > FUSC-MAX OR WS-FOUND = 'Y'
                   IF FUSC-VAL(WS-J) > WS-VAL
                       COMPUTE WS-N = WS-J - 1
                       MOVE WS-N           TO WS-DISPLAY-IDX
                       MOVE FUSC-VAL(WS-J) TO WS-DISPLAY-VAL
                       DISPLAY "fusc["
                           FUNCTION TRIM(WS-DISPLAY-IDX LEADING)
                           "] = "
                           FUNCTION TRIM(WS-DISPLAY-VAL LEADING)
                       MOVE WS-J TO WS-START
                       MOVE 'Y' TO WS-FOUND
                   END-IF
               END-PERFORM
           END-PERFORM.
