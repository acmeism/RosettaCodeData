IDENTIFICATION DIVISION.
       PROGRAM-ID. FAREY-SEQUENCE.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *> Fraction storage
       01 WS-MAX-FRACS        PIC 9(6) VALUE 600000.
       01 WS-FRAC-TABLE.
          05 WS-FRAC OCCURS 600000 TIMES.
             10 WS-NUM        PIC 9(6).
             10 WS-DEN        PIC 9(6).
             10 WS-VAL        PIC S9(6)V9(9) COMP-3.

      *> Dedup value table (parallel arrays for map simulation)
       01 WS-SEEN-TABLE.
          05 WS-SEEN OCCURS 600000 TIMES.
             10 WS-SEEN-VAL   PIC S9(6)V9(9) COMP-3.
             10 WS-SEEN-USED  PIC X VALUE 'N'.

       01 WS-FRAC-COUNT       PIC 9(6) VALUE 0.
       01 WS-SEEN-COUNT       PIC 9(6) VALUE 0.

      *> Loop counters (renamed to avoid ambiguity with table fields)
       01 WS-I                PIC 9(4).
       01 WS-LOOP-DEN         PIC 9(4).
       01 WS-LOOP-NUM         PIC 9(4).
       01 WS-K                PIC 9(6).
       01 WS-J                PIC 9(6).

      *> Computed value
       01 WS-CURR-VAL         PIC S9(6)V9(9) COMP-3.
       01 WS-FOUND            PIC X VALUE 'N'.

      *> Sorting temporaries
       01 WS-TEMP-NUM         PIC 9(6).
       01 WS-TEMP-DEN         PIC 9(6).
       01 WS-TEMP-VAL         PIC S9(6)V9(9) COMP-3.

      *> Output
       01 WS-OUT-LINE         PIC X(2000).
       01 WS-FRAC-STR         PIC X(20).

      *> Numeric editing
       01 WS-EDIT-NUM         PIC Z(5)9.
       01 WS-EDIT-I           PIC Z(3)9.
       01 WS-EDIT-CNT         PIC Z(5)9.

      *> Pointer for STRING
       01 WS-POS              PIC 9(4).

       PROCEDURE DIVISION.

       MAIN-PARA.
      *> Print F1 through F11
           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > 11
               PERFORM GEN-FAREY
               PERFORM PRINT-FAREY-LIST
           END-PERFORM

      *> Print counts for F100 to F1000 by 100
           PERFORM VARYING WS-I FROM 100 BY 100
               UNTIL WS-I > 1000
               PERFORM GEN-FAREY
               PERFORM PRINT-FAREY-COUNT
           END-PERFORM

           STOP RUN.

      *>-  -----------------------------------------------------------
      *> GEN-FAREY: builds sorted unique fraction list for order WS-I
      *>-  -----------------------------------------------------------
       GEN-FAREY.
           MOVE 0 TO WS-FRAC-COUNT
           MOVE 0 TO WS-SEEN-COUNT

      *> Clear seen flags
           PERFORM VARYING WS-K FROM 1 BY 1
               UNTIL WS-K > 600000
               MOVE 'N' TO WS-SEEN-USED(WS-K)
           END-PERFORM

      *> Generate fractions
           PERFORM VARYING WS-LOOP-DEN FROM 1 BY 1
               UNTIL WS-LOOP-DEN > WS-I
               PERFORM VARYING WS-LOOP-NUM FROM 0 BY 1
                   UNTIL WS-LOOP-NUM > WS-LOOP-DEN

                   COMPUTE WS-CURR-VAL =
                       WS-LOOP-NUM / WS-LOOP-DEN

                   PERFORM CHECK-SEEN
                   IF WS-FOUND = 'N'
                       ADD 1 TO WS-FRAC-COUNT
                       MOVE WS-LOOP-NUM TO WS-NUM(WS-FRAC-COUNT)
                       MOVE WS-LOOP-DEN TO WS-DEN(WS-FRAC-COUNT)
                       MOVE WS-CURR-VAL TO WS-VAL(WS-FRAC-COUNT)
                       ADD 1 TO WS-SEEN-COUNT
                       MOVE WS-CURR-VAL
                           TO WS-SEEN-VAL(WS-SEEN-COUNT)
                       MOVE 'Y'
                           TO WS-SEEN-USED(WS-SEEN-COUNT)
                   END-IF

               END-PERFORM
           END-PERFORM

      *> Bubble sort by value
           PERFORM VARYING WS-K FROM 1 BY 1
               UNTIL WS-K >= WS-FRAC-COUNT
               PERFORM VARYING WS-J FROM 1 BY 1
                   UNTIL WS-J >= WS-FRAC-COUNT - WS-K + 1
                   IF WS-VAL(WS-J) > WS-VAL(WS-J + 1)
                       MOVE WS-NUM(WS-J)     TO WS-TEMP-NUM
                       MOVE WS-DEN(WS-J)     TO WS-TEMP-DEN
                       MOVE WS-VAL(WS-J)     TO WS-TEMP-VAL
                       MOVE WS-NUM(WS-J + 1) TO WS-NUM(WS-J)
                       MOVE WS-DEN(WS-J + 1) TO WS-DEN(WS-J)
                       MOVE WS-VAL(WS-J + 1) TO WS-VAL(WS-J)
                       MOVE WS-TEMP-NUM      TO WS-NUM(WS-J + 1)
                       MOVE WS-TEMP-DEN      TO WS-DEN(WS-J + 1)
                       MOVE WS-TEMP-VAL      TO WS-VAL(WS-J + 1)
                   END-IF
               END-PERFORM
           END-PERFORM.

      *>-  -----------------------------------------------------------
      *> CHECK-SEEN: sets WS-FOUND = 'Y' if WS-CURR-VAL already seen
      *>-  -----------------------------------------------------------
       CHECK-SEEN.
           MOVE 'N' TO WS-FOUND
           PERFORM VARYING WS-K FROM 1 BY 1
               UNTIL WS-K > WS-SEEN-COUNT
               IF WS-SEEN-USED(WS-K) = 'Y' AND
                  WS-SEEN-VAL(WS-K) = WS-CURR-VAL
                   MOVE 'Y' TO WS-FOUND
                   MOVE WS-SEEN-COUNT TO WS-K
               END-IF
           END-PERFORM.

      *>-  -----------------------------------------------------------
      *> PRINT-FAREY-LIST: outputs "Fi: [a/b, c/d, ...]"
      *>-  -----------------------------------------------------------
       PRINT-FAREY-LIST.
           MOVE SPACES TO WS-OUT-LINE
           MOVE 1 TO WS-POS

           MOVE WS-I TO WS-EDIT-I
           STRING 'F'                                DELIMITED SIZE
                  FUNCTION TRIM(WS-EDIT-I LEADING)  DELIMITED SIZE
                  ': ['                              DELIMITED SIZE
               INTO WS-OUT-LINE
               WITH POINTER WS-POS
           END-STRING

           PERFORM VARYING WS-K FROM 1 BY 1
               UNTIL WS-K > WS-FRAC-COUNT

               MOVE SPACES TO WS-FRAC-STR
               MOVE WS-NUM(WS-K) TO WS-EDIT-NUM
               STRING
                   FUNCTION TRIM(WS-EDIT-NUM LEADING) DELIMITED SIZE
                   '/'                                DELIMITED SIZE
                   INTO WS-FRAC-STR
               END-STRING
               MOVE WS-DEN(WS-K) TO WS-EDIT-NUM
               STRING
                   FUNCTION TRIM(WS-FRAC-STR TRAILING) DELIMITED SIZE
                   FUNCTION TRIM(WS-EDIT-NUM LEADING)  DELIMITED SIZE
                   INTO WS-FRAC-STR
               END-STRING

               IF WS-K < WS-FRAC-COUNT
                   STRING
                       FUNCTION TRIM(WS-FRAC-STR TRAILING) DELIMITED
                           SIZE
                       ', '                                 DELIMITED
                           SIZE
                       INTO WS-OUT-LINE
                       WITH POINTER WS-POS
                   END-STRING
               ELSE
                   STRING
                       FUNCTION TRIM(WS-FRAC-STR TRAILING) DELIMITED
                           SIZE
                       INTO WS-OUT-LINE
                       WITH POINTER WS-POS
                   END-STRING
               END-IF

           END-PERFORM

           STRING ']' DELIMITED SIZE
               INTO WS-OUT-LINE
               WITH POINTER WS-POS
           END-STRING

           DISPLAY FUNCTION TRIM(WS-OUT-LINE TRAILING).

      *>-  -----------------------------------------------------------
      *> PRINT-FAREY-COUNT: outputs "Fi: N members"
      *>-  -----------------------------------------------------------
       PRINT-FAREY-COUNT.
           MOVE WS-I          TO WS-EDIT-I
           MOVE WS-FRAC-COUNT TO WS-EDIT-CNT
           DISPLAY 'F'
                   FUNCTION TRIM(WS-EDIT-I   LEADING)
                   ': '
                   FUNCTION TRIM(WS-EDIT-CNT LEADING)
                   ' members'.
