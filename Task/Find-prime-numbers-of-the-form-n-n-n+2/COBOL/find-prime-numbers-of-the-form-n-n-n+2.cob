       IDENTIFICATION DIVISION.
       PROGRAM-ID. N3-PLUS-2-PRIMES.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 VARIABLES.
          03 N                  PIC 9(3).
          03 N3PLUS2            PIC 9(7).
          03 DIVISOR            PIC 9(4).
          03 DIV-SQ             PIC 9(8).
          03 DIV-CHECK          PIC 9(4)V9(4).
          03 FILLER             REDEFINES DIV-CHECK.
             05 FILLER          PIC 9(4).
             05 FILLER          PIC 9(4).
                88 DIVISIBLE    VALUE ZERO.
          03 FILLER             REDEFINES N3PLUS2.
             05 FILLER          PIC 9(6).
             05 FILLER          PIC 9.
                88 EVEN         VALUE 0, 2, 4, 6, 8.
          03 PRIME-FLAG         PIC X.
             88 PRIME           VALUE '*'.

       01 FORMAT.
          03 FILLER             PIC X(4)  VALUE "N = ".
          03 N-OUT              PIC ZZ9.
          03 FILLER             PIC X(17) VALUE " => N ** 3 + 2 = ".
          03 N3PLUS2-OUT        PIC Z(6)9.

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM TRY-N VARYING N FROM 1 BY 1
           UNTIL N IS GREATER THAN 200.
           STOP RUN.

       TRY-N.
           COMPUTE N3PLUS2 = N ** 3 + 2.
           PERFORM CHECK-PRIME.
           IF PRIME,
               MOVE N TO N-OUT,
               MOVE N3PLUS2 TO N3PLUS2-OUT,
               DISPLAY FORMAT.

       CHECK-PRIME SECTION.
       BEGIN.
           MOVE SPACE TO PRIME-FLAG.
           IF N3PLUS2 IS LESS THAN 5, GO TO TRIVIAL.
           IF EVEN, GO TO CHECK-PRIME-DONE.
           DIVIDE N3PLUS2 BY 3 GIVING DIV-CHECK.
           IF DIVISIBLE, GO TO CHECK-PRIME-DONE.
           MOVE ZERO TO DIV-SQ.
           MOVE 5 TO DIVISOR.
           MOVE '*' TO PRIME-FLAG.
           PERFORM CHECK-DIVISOR
               UNTIL NOT PRIME OR DIV-SQ IS GREATER THAN N3PLUS2.
           GO TO CHECK-PRIME-DONE.

       CHECK-DIVISOR.
           MULTIPLY DIVISOR BY DIVISOR GIVING DIV-SQ.
           DIVIDE N3PLUS2 BY DIVISOR GIVING DIV-CHECK.
           IF DIVISIBLE, MOVE SPACE TO PRIME-FLAG.
           ADD 2 TO DIVISOR.
           DIVIDE N3PLUS2 BY DIVISOR GIVING DIV-CHECK.
           IF DIVISIBLE, MOVE SPACE TO PRIME-FLAG.
           ADD 4 TO DIVISOR.

       TRIVIAL.
           IF N3PLUS2 IS EQUAL TO 2 OR EQUAL TO 3,
               MOVE '*' TO PRIME-FLAG.

       CHECK-PRIME-DONE.
           EXIT.
