       IDENTIFICATION DIVISION.
       PROGRAM-ID. McNaughton.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 TEST-DATA.
           05 INFIX-ARRAY.
               10 FILLER PIC X(20) VALUE "a.b.c*".
               10 FILLER PIC X(20) VALUE "a.(b|d).c*".
               10 FILLER PIC X(20) VALUE "(a.(b|d))*".
               10 FILLER PIC X(20) VALUE "a.(b.b)*.c".
           05 INFIX-TABLE REDEFINES INFIX-ARRAY.
               10 INFIX-STR OCCURS 4 TIMES PIC X(20).

           05 STRING-ARRAY.
               10 FILLER PIC X(20) VALUE "                   ".
               10 FILLER PIC X(20) VALUE "abc                 ".
               10 FILLER PIC X(20) VALUE "abbc                ".
               10 FILLER PIC X(20) VALUE "abcc                ".
               10 FILLER PIC X(20) VALUE "abad                ".
               10 FILLER PIC X(20) VALUE "abbbc               ".
           05 STRING-TABLE REDEFINES STRING-ARRAY.
               10 TEST-STR OCCURS 6 TIMES PIC X(20).

       01 WORK-VARIABLES.
           05 LOOP-I           PIC 9(4) COMP.
           05 LOOP-J           PIC 9(4) COMP.
           05 I                PIC 9(4) COMP.
           05 J                PIC 9(4) COMP.
           05 CURR-INFIX       PIC X(20).
           05 INFIX-LEN        PIC 9(4) COMP.
           05 CURR-STR         PIC X(20).
           05 STR-LEN          PIC 9(4) COMP.
           05 MATCH-RESULT     PIC 9 COMP.
           05 PRINT-RES        PIC X(10).
           05 DISP-INFIX       PIC X(20).
           05 DISP-STR         PIC X(20).

       01 SHUNT-DATA.
           05 POSTFIX          PIC X(50).
           05 POSTFIX-LEN      PIC 9(4) COMP.
           05 C-VAL            PIC X.
           05 VAL-PREC         PIC X.
           05 PREC-VAL         PIC 9(2) COMP.
           05 PREC-C           PIC 9(2) COMP.
           05 PREC-TOP         PIC 9(2) COMP.

       01 CHAR-STACK-DATA.
           05 CHAR-STACK-TOP   PIC 9(4) COMP VALUE 0.
           05 CHAR-STACK OCCURS 500 TIMES.
               10 CHAR-VAL     PIC X.

       01 NFA-DATA.
           05 STATE-COUNT      PIC 9(4) COMP VALUE 0.
           05 NFA-STATES OCCURS 1000 TIMES.
               10 STATE-LABEL  PIC X VALUE X"00".
               10 EDGE-1       PIC 9(4) COMP VALUE 0.
               10 EDGE-2       PIC 9(4) COMP VALUE 0.

       01 NFA-STACK-DATA.
           05 NFA-STACK-TOP    PIC 9(4) COMP VALUE 0.
           05 NFA-STACK OCCURS 500 TIMES.
               10 NFA-INITIAL  PIC 9(4) COMP VALUE 0.
               10 NFA-ACCEPT   PIC 9(4) COMP VALUE 0.

       01 COMPILE-VARS.
           05 NEW-STATE-ID     PIC 9(4) COMP.
           05 N1               PIC 9(4) COMP.
           05 N2               PIC 9(4) COMP.
           05 L-INITIAL        PIC 9(4) COMP.
           05 L-ACCEPT         PIC 9(4) COMP.
           05 FINAL-NFA        PIC 9(4) COMP.
           05 NFA-START-NODE   PIC 9(4) COMP.
           05 NFA-END-NODE     PIC 9(4) COMP.

       01 MATCH-DATA.
           05 CLOSURE-SET-ARR  PIC X(1000) VALUE LOW-VALUES.
           05 CLOSURE-SET-TBL REDEFINES CLOSURE-SET-ARR.
               10 CLOSURE-SET OCCURS 1000 TIMES PIC X.
           05 CURRENT-SET-ARR  PIC X(1000) VALUE LOW-VALUES.
           05 CURRENT-SET-TBL REDEFINES CURRENT-SET-ARR.
               10 CURRENT-SET OCCURS 1000 TIMES PIC X.
           05 NEXT-SET-ARR     PIC X(1000) VALUE LOW-VALUES.
           05 NEXT-SET-TBL REDEFINES NEXT-SET-ARR.
               10 NEXT-SET OCCURS 1000 TIMES PIC X.

           05 CLOSURE-STACK-TOP PIC 9(4) COMP VALUE 0.
           05 CLOSURE-STACK OCCURS 1000 TIMES.
               10 C-STATE       PIC 9(4) COMP VALUE 0.
           05 START-STATE       PIC 9(4) COMP VALUE 0.
           05 CURR-STATE        PIC 9(4) COMP VALUE 0.
           05 STR-IDX           PIC 9(4) COMP VALUE 1.
           05 STR-CH            PIC X.
           05 S                 PIC 9(4) COMP VALUE 1.
           05 NS                PIC 9(4) COMP VALUE 1.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           PERFORM VARYING LOOP-I FROM 1 BY 1 UNTIL LOOP-I > 4
               MOVE INFIX-STR(LOOP-I) TO CURR-INFIX
               PERFORM GET-INFIX-LEN

               PERFORM VARYING LOOP-J FROM 1 BY 1 UNTIL LOOP-J > 6
                   MOVE TEST-STR(LOOP-J) TO CURR-STR
                   PERFORM GET-STR-LEN

                   PERFORM MATCH-REGEX

                   IF MATCH-RESULT = 1
                       MOVE "True  " TO PRINT-RES
                   ELSE
                       MOVE "False " TO PRINT-RES
                   END-IF

                   MOVE CURR-INFIX TO DISP-INFIX
                   MOVE CURR-STR TO DISP-STR

                   DISPLAY FUNCTION TRIM(PRINT-RES TRAILING) " "
                           FUNCTION TRIM(DISP-INFIX TRAILING) " "
                           FUNCTION TRIM(DISP-STR TRAILING)
               END-PERFORM
               DISPLAY " "
           END-PERFORM.
           STOP RUN.

       GET-INFIX-LEN.
           MOVE 20 TO INFIX-LEN.
           PERFORM UNTIL INFIX-LEN = 0
               IF CURR-INFIX(INFIX-LEN:1) NOT = SPACE
                   EXIT PERFORM
               END-IF
               SUBTRACT 1 FROM INFIX-LEN
           END-PERFORM.

       GET-STR-LEN.
           MOVE 20 TO STR-LEN.
           PERFORM UNTIL STR-LEN = 0
               IF CURR-STR(STR-LEN:1) NOT = SPACE
                   EXIT PERFORM
               END-IF
               SUBTRACT 1 FROM STR-LEN
           END-PERFORM.

       GET-PRECEDENCE.
           EVALUATE VAL-PREC
               WHEN "*" MOVE 60 TO PREC-VAL
               WHEN "+" MOVE 55 TO PREC-VAL
               WHEN "?" MOVE 50 TO PREC-VAL
               WHEN "." MOVE 40 TO PREC-VAL
               WHEN "|" MOVE 20 TO PREC-VAL
               WHEN OTHER MOVE 0 TO PREC-VAL
           END-EVALUATE.

       SHUNT-REGEX.
           MOVE 0 TO CHAR-STACK-TOP.
           MOVE 1 TO POSTFIX-LEN.
           MOVE SPACES TO POSTFIX.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > INFIX-LEN
               MOVE CURR-INFIX(I:1) TO C-VAL
               EVALUATE C-VAL
                   WHEN "("
                       ADD 1 TO CHAR-STACK-TOP
                       MOVE C-VAL TO CHAR-VAL(CHAR-STACK-TOP)
                   WHEN ")"
                       PERFORM UNTIL CHAR-STACK-TOP = 0
                           IF CHAR-VAL(CHAR-STACK-TOP) = "("
                               EXIT PERFORM
                           END-IF
                           MOVE CHAR-VAL(CHAR-STACK-TOP) TO POSTFIX(POSTFIX-LEN:1)
                           ADD 1 TO POSTFIX-LEN
                           SUBTRACT 1 FROM CHAR-STACK-TOP
                       END-PERFORM
                       IF CHAR-STACK-TOP > 0
                           SUBTRACT 1 FROM CHAR-STACK-TOP
                       END-IF
                   WHEN "*"
                       PERFORM PROCESS-OPERATOR
                   WHEN "+"
                       PERFORM PROCESS-OPERATOR
                   WHEN "?"
                       PERFORM PROCESS-OPERATOR
                   WHEN "."
                       PERFORM PROCESS-OPERATOR
                   WHEN "|"
                       PERFORM PROCESS-OPERATOR
                   WHEN OTHER
                       MOVE C-VAL TO POSTFIX(POSTFIX-LEN:1)
                       ADD 1 TO POSTFIX-LEN
               END-EVALUATE
           END-PERFORM.

           PERFORM UNTIL CHAR-STACK-TOP = 0
               MOVE CHAR-VAL(CHAR-STACK-TOP) TO POSTFIX(POSTFIX-LEN:1)
               ADD 1 TO POSTFIX-LEN
               SUBTRACT 1 FROM CHAR-STACK-TOP
           END-PERFORM.
           SUBTRACT 1 FROM POSTFIX-LEN.

       PROCESS-OPERATOR.
           MOVE C-VAL TO VAL-PREC.
           PERFORM GET-PRECEDENCE.
           MOVE PREC-VAL TO PREC-C.
           PERFORM UNTIL CHAR-STACK-TOP = 0
               MOVE CHAR-VAL(CHAR-STACK-TOP) TO VAL-PREC
               PERFORM GET-PRECEDENCE
               MOVE PREC-VAL TO PREC-TOP
               IF CHAR-VAL(CHAR-STACK-TOP) = "("
                   EXIT PERFORM
               END-IF
               IF PREC-C > PREC-TOP
                   EXIT PERFORM
               END-IF
               MOVE CHAR-VAL(CHAR-STACK-TOP) TO POSTFIX(POSTFIX-LEN:1)
               ADD 1 TO POSTFIX-LEN
               SUBTRACT 1 FROM CHAR-STACK-TOP
           END-PERFORM.
           ADD 1 TO CHAR-STACK-TOP.
           MOVE C-VAL TO CHAR-VAL(CHAR-STACK-TOP).

       NEW-STATE.
           ADD 1 TO STATE-COUNT.
           MOVE STATE-COUNT TO NEW-STATE-ID.
           MOVE X"00" TO STATE-LABEL(NEW-STATE-ID).
           MOVE 0 TO EDGE-1(NEW-STATE-ID).
           MOVE 0 TO EDGE-2(NEW-STATE-ID).

       POP-NFA1.
           MOVE NFA-STACK-TOP TO N1.
           SUBTRACT 1 FROM NFA-STACK-TOP.

       POP-NFA2.
           MOVE NFA-STACK-TOP TO N2.
           SUBTRACT 1 FROM NFA-STACK-TOP.

       PUSH-NFA-L.
           ADD 1 TO NFA-STACK-TOP.
           MOVE L-INITIAL TO NFA-INITIAL(NFA-STACK-TOP).
           MOVE L-ACCEPT TO NFA-ACCEPT(NFA-STACK-TOP).

       COMPILE-REGEX.
           MOVE 0 TO STATE-COUNT.
           MOVE 0 TO NFA-STACK-TOP.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > POSTFIX-LEN
               MOVE POSTFIX(I:1) TO C-VAL
               EVALUATE C-VAL
                   WHEN "*"
                       PERFORM POP-NFA1
                       PERFORM NEW-STATE
                       MOVE NEW-STATE-ID TO L-INITIAL
                       PERFORM NEW-STATE
                       MOVE NEW-STATE-ID TO L-ACCEPT

                       MOVE NFA-INITIAL(N1) TO EDGE-1(L-INITIAL)
                       MOVE L-ACCEPT TO EDGE-2(L-INITIAL)

                       MOVE NFA-INITIAL(N1) TO EDGE-1(NFA-ACCEPT(N1))
                       MOVE L-ACCEPT TO EDGE-2(NFA-ACCEPT(N1))

                       PERFORM PUSH-NFA-L
                   WHEN "."
                       PERFORM POP-NFA2
                       PERFORM POP-NFA1
                       MOVE NFA-INITIAL(N2) TO EDGE-1(NFA-ACCEPT(N1))

                       MOVE NFA-INITIAL(N1) TO L-INITIAL
                       MOVE NFA-ACCEPT(N2) TO L-ACCEPT
                       PERFORM PUSH-NFA-L
                   WHEN "|"
                       PERFORM POP-NFA2
                       PERFORM POP-NFA1
                       PERFORM NEW-STATE
                       MOVE NEW-STATE-ID TO L-INITIAL
                       PERFORM NEW-STATE
                       MOVE NEW-STATE-ID TO L-ACCEPT

                       MOVE NFA-INITIAL(N1) TO EDGE-1(L-INITIAL)
                       MOVE NFA-INITIAL(N2) TO EDGE-2(L-INITIAL)

                       MOVE L-ACCEPT TO EDGE-1(NFA-ACCEPT(N1))
                       MOVE L-ACCEPT TO EDGE-1(NFA-ACCEPT(N2))

                       PERFORM PUSH-NFA-L
                   WHEN "+"
                       PERFORM POP-NFA1
                       PERFORM NEW-STATE
                       MOVE NEW-STATE-ID TO L-INITIAL
                       PERFORM NEW-STATE
                       MOVE NEW-STATE-ID TO L-ACCEPT

                       MOVE NFA-INITIAL(N1) TO EDGE-1(L-INITIAL)
                       MOVE NFA-INITIAL(N1) TO EDGE-1(NFA-ACCEPT(N1))
                       MOVE L-ACCEPT TO EDGE-2(NFA-ACCEPT(N1))

                       PERFORM PUSH-NFA-L
                   WHEN "?"
                       PERFORM POP-NFA1
                       PERFORM NEW-STATE
                       MOVE NEW-STATE-ID TO L-INITIAL
                       PERFORM NEW-STATE
                       MOVE NEW-STATE-ID TO L-ACCEPT

                       MOVE NFA-INITIAL(N1) TO EDGE-1(L-INITIAL)
                       MOVE L-ACCEPT TO EDGE-2(L-INITIAL)
                       MOVE L-ACCEPT TO EDGE-1(NFA-ACCEPT(N1))

                       PERFORM PUSH-NFA-L
                   WHEN OTHER
                       PERFORM NEW-STATE
                       MOVE NEW-STATE-ID TO L-INITIAL
                       MOVE C-VAL TO STATE-LABEL(L-INITIAL)
                       PERFORM NEW-STATE
                       MOVE NEW-STATE-ID TO L-ACCEPT

                       MOVE L-ACCEPT TO EDGE-1(L-INITIAL)

                       PERFORM PUSH-NFA-L
               END-EVALUATE
           END-PERFORM.
           MOVE NFA-STACK-TOP TO FINAL-NFA.
           MOVE NFA-INITIAL(FINAL-NFA) TO NFA-START-NODE.
           MOVE NFA-ACCEPT(FINAL-NFA) TO NFA-END-NODE.

       FOLLOWES-PROC.
           MOVE LOW-VALUES TO CLOSURE-SET-ARR.
           MOVE 0 TO CLOSURE-STACK-TOP.

           ADD 1 TO CLOSURE-STACK-TOP.
           MOVE START-STATE TO C-STATE(CLOSURE-STACK-TOP).

           PERFORM UNTIL CLOSURE-STACK-TOP = 0
               MOVE C-STATE(CLOSURE-STACK-TOP) TO CURR-STATE
               SUBTRACT 1 FROM CLOSURE-STACK-TOP
               IF CLOSURE-SET(CURR-STATE) = X"00"
                   MOVE X"01" TO CLOSURE-SET(CURR-STATE)
                   IF STATE-LABEL(CURR-STATE) = X"00" OR SPACE
                       IF EDGE-1(CURR-STATE) > 0
                           ADD 1 TO CLOSURE-STACK-TOP
                           MOVE EDGE-1(CURR-STATE) TO C-STATE(CLOSURE-STACK-TOP)
                       END-IF
                       IF EDGE-2(CURR-STATE) > 0
                           ADD 1 TO CLOSURE-STACK-TOP
                           MOVE EDGE-2(CURR-STATE) TO C-STATE(CLOSURE-STACK-TOP)
                       END-IF
                   END-IF
               END-IF
           END-PERFORM.

       MATCH-REGEX.
           PERFORM SHUNT-REGEX.
           PERFORM COMPILE-REGEX.

           MOVE LOW-VALUES TO CURRENT-SET-ARR.

           MOVE NFA-START-NODE TO START-STATE.
           PERFORM FOLLOWES-PROC.

           PERFORM VARYING S FROM 1 BY 1 UNTIL S > STATE-COUNT
               MOVE CLOSURE-SET(S) TO CURRENT-SET(S)
           END-PERFORM.

           IF STR-LEN = 0
               CONTINUE
           ELSE
               PERFORM VARYING STR-IDX FROM 1 BY 1 UNTIL STR-IDX > STR-LEN
                   MOVE CURR-STR(STR-IDX:1) TO STR-CH

                   MOVE LOW-VALUES TO NEXT-SET-ARR

                   PERFORM VARYING S FROM 1 BY 1 UNTIL S > STATE-COUNT
                       IF CURRENT-SET(S) = X"01"
                           IF STATE-LABEL(S) = STR-CH
                               MOVE EDGE-1(S) TO START-STATE
                               PERFORM FOLLOWES-PROC
                               PERFORM VARYING NS FROM 1 BY 1 UNTIL NS > STATE-COUNT
                                   IF CLOSURE-SET(NS) = X"01"
                                       MOVE X"01" TO NEXT-SET(NS)
                                   END-IF
                               END-PERFORM
                           END-IF
                       END-IF
                   END-PERFORM

                   PERFORM VARYING S FROM 1 BY 1 UNTIL S > STATE-COUNT
                       MOVE NEXT-SET(S) TO CURRENT-SET(S)
                   END-PERFORM
               END-PERFORM
           END-IF.

           IF CURRENT-SET(NFA-END-NODE) = X"01"
               MOVE 1 TO MATCH-RESULT
           ELSE
               MOVE 0 TO MATCH-RESULT
           END-IF.

