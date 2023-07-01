      ******************************************************************
      * COBOL solution to Anti-primes challange
      * The program was run on OpenCobolIDE
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ANGLE-PRIMES.

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  ANTI-PRIMES-CTR              PIC 9(3) VALUE 0.
       77  FACTORS-CTR                  PIC 9(3) VALUE 0.
       77  WS-INTEGER                   PIC 9(5) VALUE 1.
       77  WS-MAX                       PIC 9(5) VALUE 0.
       77  WS-I                         PIc 9(5) VALUE 0.
       77  WS-LIMIT                     PIC 9(5) VALUE 1.
       77  WS-REMAINDER                 PIC 9(5).

       01  OUT-HDR         PIC X(23)    VALUE 'SEQ ANTI-PRIME FACTORS'.
       01  OUT-LINE.
           05 OUT-SEQ      PIC 9(3).
           05 FILLER       PIC X(3)     VALUE SPACES.
           05 OUT-ANTI     PIC ZZZZ9.
           05 FILLER       PIC X(4)     VALUE SPACES.
           05 OUT-FACTORS  PIC ZZZZ9.

       PROCEDURE DIVISION.
       000-MAIN.
           DISPLAY OUT-HDR.
           PERFORM 100-GET-ANTI-PRIMES
               VARYING WS-INTEGER FROM 1 By 1
               UNTIL ANTI-PRIMES-CTR >= 20.
           STOP RUN.

       100-GET-ANTI-PRIMES.
           SET FACTORS-CTR TO 0.
           COMPUTE WS-LIMIT = 1 + WS-INTEGER ** .5.
           PERFORM 200-COUNT-FACTORS
               VARYING WS-I FROM 1 BY 1
               UNTIL WS-I >= WS-LIMIT.
           IF FACTORS-CTR > WS-MAX
               ADD 1 TO ANTI-PRIMES-CTR
               COMPUTE WS-MAX = FACTORS-CTR
               MOVE ANTI-PRIMES-CTR TO OUT-SEQ
               MOVE WS-INTEGER TO OUT-ANTI
               MOVE FACTORS-CTR TO OUT-FACTORS
               DISPLAY OUT-LINE
           END-IF.

       200-COUNT-FACTORS.
           COMPUTE WS-REMAINDER =
               FUNCTION MOD(WS-INTEGER WS-I).
           IF WS-REMAINDER = ZERO
               ADD 1 TO FACTORS-CTR
               IF WS-INTEGER NOT = WS-I ** 2
                   ADD 1 TO FACTORS-CTR
               END-IF
           END-IF.

      ******************************************************************
      *    OUTPUT:
      ******************************************************************
      *     SEQ ANTI-PRIME FACTORS
      *     001       1        1
      *     002       2        2
      *     003       4        3
      *     004       6        4
      *     005      12        6
      *     006      24        8
      *     007      36        9
      *     008      48       10
      *     009      60       12
      *     010     120       16
      *     011     180       18
      *     012     240       20
      *     013     360       24
      *     014     720       30
      *     015     840       32
      *     016    1260       36
      *     017    1680       40
      *     018    2520       48
      *     019    5040       60
      *     020    7560       64
      ******************************************************************
