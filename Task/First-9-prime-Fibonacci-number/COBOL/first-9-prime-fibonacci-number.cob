       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRIME-FIBONACCI.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 FIBONACCI-VARS.
          03 FIB                PIC 9(6).
          03 FIB-B              PIC 9(6).
          03 FIB-C              PIC 9(6).
          03 FIB-OUT            PIC Z(5)9.
       01 PRIME-VARS.
          03 PRIME-FLAG         PIC X.
             88 PRIME           VALUE 'X'.
          03 DSOR               PIC 9(4).
          03 DSOR-SQ            PIC 9(6).
          03 DIV-RSLT           PIC 9(6)V9(3).
          03 FILLER             REDEFINES DIV-RSLT.
             05 FILLER          PIC 9(6).
             05 FILLER          PIC 9(3).
                88 DIVISIBLE    VALUE ZERO.

       PROCEDURE DIVISION.
       BEGIN.
           MOVE 1 TO FIB, FIB-B.
           PERFORM FIND-PRIME-FIBONACCI 9 TIMES.
           STOP RUN.

       FIND-PRIME-FIBONACCI.
           ADD FIB, FIB-B GIVING FIB-C.
           MOVE FIB-B TO FIB.
           MOVE FIB-C TO FIB-B.
           PERFORM CHECK-PRIME.
           IF NOT PRIME, GO TO FIND-PRIME-FIBONACCI.
           MOVE FIB TO FIB-OUT.
           DISPLAY FIB-OUT.

       CHECK-PRIME SECTION.
       BEGIN.
           MOVE SPACE TO PRIME-FLAG.
           IF FIB IS LESS THAN 5, GO TO TRIVIAL-PRIME.
           DIVIDE FIB BY 2 GIVING DIV-RSLT.
           IF DIVISIBLE, GO TO DONE.
           DIVIDE FIB BY 3 GIVING DIV-RSLT.
           IF DIVISIBLE, GO TO DONE.
           MOVE 5 TO DSOR.
           MOVE 25 TO DSOR-SQ.
           MOVE 'X' TO PRIME-FLAG.
           PERFORM TEST-DIVISOR
           UNTIL NOT PRIME OR DSOR-SQ IS GREATER THAN FIB.
           GO TO DONE.

       TEST-DIVISOR.
           DIVIDE FIB BY DSOR GIVING DIV-RSLT.
           IF DIVISIBLE, MOVE SPACE TO PRIME-FLAG.
           ADD 2 TO DSOR.
           DIVIDE FIB BY DSOR GIVING DIV-RSLT.
           IF DIVISIBLE, MOVE SPACE TO PRIME-FLAG.
           ADD 4 TO DSOR.
           MULTIPLY DSOR BY DSOR GIVING DSOR-SQ.

       TRIVIAL-PRIME.
           IF FIB IS EQUAL TO 2 OR 3, MOVE 'X' TO PRIME-FLAG.
       DONE.
           EXIT.
