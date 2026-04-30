       IDENTIFICATION DIVISION.
       PROGRAM-ID. DEBRUIJN-PROGRAM.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *>---------------------------------------------------------
      *> Constants
      *>---------------------------------------------------------
       01 C-K                      PIC 9(2)  VALUE 10.
       01 C-N                      PIC 9(2)  VALUE 4.

      *>---------------------------------------------------------
      *> Array A for de Bruijn generation
      *> COBOL index I corresponds to JS index I - 1
      *>---------------------------------------------------------
       01 WS-A-TABLE.
          05 WS-A                  PIC 9     OCCURS 41 TIMES.

      *>---------------------------------------------------------
      *> Sequence accumulator
      *>---------------------------------------------------------
       01 WS-SEQ-TABLE.
          05 WS-SEQ                PIC 9     OCCURS 10000 TIMES.
       01 WS-SEQ-LEN              PIC 9(5)  VALUE 0.

      *>---------------------------------------------------------
      *> Explicit stack for simulating recursion
      *> State 0 = fresh entry
      *> State 1 = returned from db(t+1, p)
      *> State 2 = returned from db(t+1, t) in loop
      *>---------------------------------------------------------
       01 WS-STACK-SIZE            PIC 9(4)  VALUE 0.
       01 WS-STACK-TABLE.
          05 WS-STACK-ENTRY        OCCURS 50 TIMES.
             10 STK-T              PIC 9(4).
             10 STK-P              PIC 9(4).
             10 STK-STATE          PIC 9.
             10 STK-J              PIC 9(4).

      *>---------------------------------------------------------
      *> String buffers
      *>---------------------------------------------------------
       01 WS-DB-STRING             PIC X(10004) VALUE SPACES.
       01 WS-DB-LEN                PIC 9(5)  VALUE 0.
       01 WS-VAL-STRING            PIC X(10004) VALUE SPACES.
       01 WS-VAL-LEN              PIC 9(5)  VALUE 0.
       01 WS-RDB-STRING            PIC X(10004) VALUE SPACES.
       01 WS-OVL-STRING            PIC X(10004) VALUE SPACES.

      *>---------------------------------------------------------
      *> Validation: found array for PINs 0000-9999
      *>---------------------------------------------------------
       01 WS-FOUND-TABLE.
          05 WS-FOUND              PIC 9(4)  OCCURS 10000 TIMES.

      *>---------------------------------------------------------
      *> Working variables
      *>---------------------------------------------------------
       01 WS-I                     PIC 9(5).
       01 WS-I2                    PIC 9(5).
       01 WS-T                     PIC 9(4).
       01 WS-P                     PIC 9(4).
       01 WS-CUR-STATE             PIC 9.
       01 WS-CUR-J                 PIC 9(4).
       01 WS-REMAINDER             PIC 9(5).
       01 WS-SUBSTR4               PIC X(4).
       01 WS-NUM                   PIC 9(4).
       01 WS-NUM-IDX               PIC 9(5).
       01 WS-ERR-COUNT             PIC 9(5)  VALUE 0.
       01 WS-CHAR                  PIC X.
       01 WS-ALL-DIGITS-FLAG       PIC 9     VALUE 1.
       01 WS-TEMP                  PIC 9(5).
       01 WS-A-IDX                 PIC 9(4).
       01 WS-A-IDX2                PIC 9(4).
       01 WS-LOOP-LIMIT            PIC 9(5).
       01 WS-START-POS             PIC 9(5).

      *>---------------------------------------------------------
      *> Display fields
      *>---------------------------------------------------------
       01 WS-LEN-DISPLAY           PIC Z(4)9.
       01 WS-ERR-DISPLAY           PIC Z(4)9.
       01 WS-PIN-DISPLAY           PIC 9(4).
       01 WS-CNT-DISPLAY           PIC Z(3)9.
       01 WS-FIRST130              PIC X(130).
       01 WS-LAST130               PIC X(130).

       PROCEDURE DIVISION.

      *>= ========================================================
       MAIN-PARAGRAPH.
      *>= ========================================================
           PERFORM GENERATE-DEBRUIJN

           MOVE WS-DB-LEN TO WS-LEN-DISPLAY
           DISPLAY "The length of the de Bruijn sequence"
               " is " WS-LEN-DISPLAY
           DISPLAY SPACE

           MOVE WS-DB-STRING(1:130) TO WS-FIRST130
           DISPLAY "The first 130 digits of the de Bruijn"
               " sequence are:"
           DISPLAY WS-FIRST130

           COMPUTE WS-START-POS = WS-DB-LEN - 129
           MOVE WS-DB-STRING(WS-START-POS:130)
               TO WS-LAST130
           DISPLAY SPACE
           DISPLAY "The last 130 digits of the de Bruijn"
               " sequence are:"
           DISPLAY WS-LAST130
           DISPLAY SPACE

           DISPLAY "Validating the de Bruijn sequence:"
           MOVE WS-DB-STRING TO WS-VAL-STRING
           MOVE WS-DB-LEN TO WS-VAL-LEN
           PERFORM VALIDATE-SEQUENCE

           DISPLAY SPACE
           DISPLAY "Validating the reversed de Bruijn"
               " sequence:"
           PERFORM REVERSE-DB-STRING
           MOVE WS-RDB-STRING TO WS-VAL-STRING
           MOVE WS-DB-LEN TO WS-VAL-LEN
           PERFORM VALIDATE-SEQUENCE

           DISPLAY SPACE
           DISPLAY "Validating the overlaid de Bruijn"
               " sequence:"
           MOVE WS-DB-STRING TO WS-OVL-STRING
           MOVE '.' TO WS-OVL-STRING(4444:1)
           MOVE WS-OVL-STRING TO WS-VAL-STRING
           MOVE WS-DB-LEN TO WS-VAL-LEN
           PERFORM VALIDATE-SEQUENCE

           STOP RUN
           .

      *>= ========================================================
       GENERATE-DEBRUIJN.
      *>= ========================================================
           INITIALIZE WS-A-TABLE
           MOVE 0 TO WS-SEQ-LEN

      *>    Push initial call: db(1, 1)
           MOVE 0 TO WS-STACK-SIZE
           ADD 1 TO WS-STACK-SIZE
           MOVE 1 TO STK-T(WS-STACK-SIZE)
           MOVE 1 TO STK-P(WS-STACK-SIZE)
           MOVE 0 TO STK-STATE(WS-STACK-SIZE)
           MOVE 0 TO STK-J(WS-STACK-SIZE)

      *>    Process stack until empty
           PERFORM PROCESS-STACK
               UNTIL WS-STACK-SIZE = 0

      *>    Build output string from sequence digits
           MOVE SPACES TO WS-DB-STRING
           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > WS-SEQ-LEN
               MOVE WS-SEQ(WS-I)
                   TO WS-DB-STRING(WS-I:1)
           END-PERFORM

      *>    Append first n-1 chars for wrap-around
           COMPUTE WS-TEMP = WS-SEQ-LEN + 1
           MOVE WS-DB-STRING(1:3)
               TO WS-DB-STRING(WS-TEMP:3)
           COMPUTE WS-DB-LEN = WS-SEQ-LEN + 3
           .

      *>= ========================================================
       PROCESS-STACK.
      *> Read current top-of-stack and dispatch by state
      *>= ========================================================
           MOVE STK-T(WS-STACK-SIZE)     TO WS-T
           MOVE STK-P(WS-STACK-SIZE)     TO WS-P
           MOVE STK-STATE(WS-STACK-SIZE) TO WS-CUR-STATE
           MOVE STK-J(WS-STACK-SIZE)     TO WS-CUR-J

           EVALUATE WS-CUR-STATE
               WHEN 0
                   PERFORM STACK-STATE-0
               WHEN 1
                   PERFORM STACK-STATE-1
               WHEN 2
                   PERFORM STACK-STATE-2
           END-EVALUATE
           .

      *>= ========================================================
       STACK-STATE-0.
      *> Fresh entry for db(t, p)
      *>= ========================================================
           IF WS-T > C-N
      *>        Base case: t > n
               COMPUTE WS-REMAINDER =
                   FUNCTION MOD(C-N, WS-P)
               IF WS-REMAINDER = 0
      *>            Append a[1..p] to seq
      *>            JS a[i] = COBOL WS-A(i + 1)
                   PERFORM VARYING WS-I FROM 1 BY 1
                       UNTIL WS-I > WS-P
                       ADD 1 TO WS-SEQ-LEN
                       COMPUTE WS-A-IDX = WS-I + 1
                       MOVE WS-A(WS-A-IDX)
                           TO WS-SEQ(WS-SEQ-LEN)
                   END-PERFORM
               END-IF
      *>        Return (pop)
               SUBTRACT 1 FROM WS-STACK-SIZE
           ELSE
      *>        a[t] = a[t - p]
               COMPUTE WS-A-IDX  = WS-T + 1
               COMPUTE WS-A-IDX2 = WS-T - WS-P + 1
               MOVE WS-A(WS-A-IDX2)
                   TO WS-A(WS-A-IDX)

      *>        Mark state 1 for return, push db(t+1,p)
               MOVE 1 TO STK-STATE(WS-STACK-SIZE)
               ADD 1 TO WS-STACK-SIZE
               COMPUTE STK-T(WS-STACK-SIZE) =
                   WS-T + 1
               MOVE WS-P TO STK-P(WS-STACK-SIZE)
               MOVE 0 TO STK-STATE(WS-STACK-SIZE)
               MOVE 0 TO STK-J(WS-STACK-SIZE)
           END-IF
           .

      *>= ========================================================
       STACK-STATE-1.
      *> Returned from db(t+1, p); init loop j = a[t-p]+1
      *>= ========================================================
           COMPUTE WS-A-IDX2 = WS-T - WS-P + 1
           COMPUTE WS-CUR-J  = WS-A(WS-A-IDX2) + 1
           PERFORM STACK-LOOP-CHECK
           .

      *>= ========================================================
       STACK-STATE-2.
      *> Returned from db(t+1, t) in loop; increment j
      *>= ========================================================
           ADD 1 TO WS-CUR-J
           PERFORM STACK-LOOP-CHECK
           .

      *>= ========================================================
       STACK-LOOP-CHECK.
      *> If j < k, set a[t] = j, push db(t+1, t)
      *> Otherwise pop (loop finished)
      *>= ========================================================
           IF WS-CUR-J < C-K
               COMPUTE WS-A-IDX = WS-T + 1
               MOVE WS-CUR-J TO WS-A(WS-A-IDX)

               MOVE WS-CUR-J
                   TO STK-J(WS-STACK-SIZE)
               MOVE 2 TO STK-STATE(WS-STACK-SIZE)

               ADD 1 TO WS-STACK-SIZE
               COMPUTE STK-T(WS-STACK-SIZE) =
                   WS-T + 1
               MOVE WS-T TO STK-P(WS-STACK-SIZE)
               MOVE 0 TO STK-STATE(WS-STACK-SIZE)
               MOVE 0 TO STK-J(WS-STACK-SIZE)
           ELSE
               SUBTRACT 1 FROM WS-STACK-SIZE
           END-IF
           .

      *>= ========================================================
       VALIDATE-SEQUENCE.
      *>= ========================================================
           INITIALIZE WS-FOUND-TABLE
           MOVE 0 TO WS-ERR-COUNT

      *>    Scan all 4-character substrings
           COMPUTE WS-LOOP-LIMIT = WS-VAL-LEN - 3
           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > WS-LOOP-LIMIT
               MOVE WS-VAL-STRING(WS-I:4)
                   TO WS-SUBSTR4

      *>        Check if all 4 chars are digits
               MOVE 1 TO WS-ALL-DIGITS-FLAG
               PERFORM VARYING WS-I2 FROM 1 BY 1
                   UNTIL WS-I2 > 4
                   MOVE WS-SUBSTR4(WS-I2:1)
                       TO WS-CHAR
                   IF WS-CHAR < '0' OR WS-CHAR > '9'
                       MOVE 0 TO WS-ALL-DIGITS-FLAG
                   END-IF
               END-PERFORM

               IF WS-ALL-DIGITS-FLAG = 1
                   MOVE WS-SUBSTR4 TO WS-NUM
                   COMPUTE WS-NUM-IDX = WS-NUM + 1
                   ADD 1 TO WS-FOUND(WS-NUM-IDX)
               END-IF
           END-PERFORM

      *>    Count errors
           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > 10000
               IF WS-FOUND(WS-I) NOT = 1
                   ADD 1 TO WS-ERR-COUNT
               END-IF
           END-PERFORM

      *>    Display results
           IF WS-ERR-COUNT = 0
               DISPLAY "  No errors found"
           ELSE
               MOVE WS-ERR-COUNT TO WS-ERR-DISPLAY
               IF WS-ERR-COUNT = 1
                   DISPLAY "  " WS-ERR-DISPLAY
                       " error found:"
               ELSE
                   DISPLAY "  " WS-ERR-DISPLAY
                       " errors found:"
               END-IF

               PERFORM VARYING WS-I FROM 1 BY 1
                   UNTIL WS-I > 10000
                   COMPUTE WS-TEMP = WS-I - 1
                   IF WS-FOUND(WS-I) = 0
                       MOVE WS-TEMP TO WS-PIN-DISPLAY
                       DISPLAY
                           "    PIN number "
                           WS-PIN-DISPLAY
                           " missing"
                   ELSE
                       IF WS-FOUND(WS-I) > 1
                           MOVE WS-TEMP
                               TO WS-PIN-DISPLAY
                           MOVE WS-FOUND(WS-I)
                               TO WS-CNT-DISPLAY
                           DISPLAY
                               "    PIN number "
                               WS-PIN-DISPLAY
                               " occurs "
                               WS-CNT-DISPLAY
                               " times"
                       END-IF
                   END-IF
               END-PERFORM
           END-IF
           .

      *>= ========================================================
       REVERSE-DB-STRING.
      *>= ========================================================
           MOVE SPACES TO WS-RDB-STRING
           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > WS-DB-LEN
               COMPUTE WS-TEMP =
                   WS-DB-LEN - WS-I + 1
               MOVE WS-DB-STRING(WS-TEMP:1)
                   TO WS-RDB-STRING(WS-I:1)
           END-PERFORM
           .
