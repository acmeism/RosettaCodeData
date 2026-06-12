IDENTIFICATION DIVISION.
       PROGRAM-ID. SumOfTwoAdjacentNumsArePrimes.
       AUTHOR. Converted from Java.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-VARIABLES.
           05  WS-LIMIT            PIC 9(8) VALUE 20000000.
           05  WS-HALF-LIMIT       PIC 9(8).
           05  WS-PRIME-COUNT      PIC 9(8) VALUE 0.
           05  WS-MAX-PRIMES       PIC 9(8) VALUE 10000100.
           05  WS-IDX              PIC 9(8).
           05  WS-IDX-A            PIC 9(8).
           05  WS-P                PIC 9(8).
           05  WS-PRIME            PIC 9(8).
           05  WS-HALF-PRIME       PIC 9(8).
           05  WS-I                PIC 9(2).

       01  WS-COMPOSITE-ARRAY.
           05  WS-COMPOSITE OCCURS 10000000 TIMES
               INDEXED BY COMP-IDX
               PIC X VALUE 'N'.

       01  WS-PRIMES-ARRAY.
           05  WS-PRIME-NUM OCCURS 1000000 TIMES
               INDEXED BY PRIME-IDX
               PIC 9(8).

       01  WS-OUTPUT-LINE.
           05  WS-OUT-NUM1         PIC ZZZ,ZZZ,ZZ9.
           05  FILLER              PIC X(4) VALUE ' + '.
           05  WS-OUT-NUM2         PIC ZZZ,ZZZ,ZZ9.
           05  FILLER              PIC X(4) VALUE ' = '.
           05  WS-OUT-SUM          PIC ZZZ,ZZZ,ZZ9.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           DISPLAY 'Generating primes...'
           PERFORM GENERATE-PRIMES

           DISPLAY 'The first 20 pairs of natural numbers whose sum'
                   ' is prime:'
           PERFORM DISPLAY-FIRST-20-PAIRS
           DISPLAY ' '

           IF WS-PRIME-COUNT >= 1000000
               DISPLAY 'The 1 millionth such pair is:'
               PERFORM DISPLAY-MILLIONTH-PAIR
           ELSE
               DISPLAY 'Found ' WS-PRIME-COUNT ' primes (need more)'
           END-IF

           STOP RUN.

       GENERATE-PRIMES.
           MOVE 1 TO WS-PRIME-COUNT
           MOVE 2 TO WS-PRIME-NUM(1)

           COMPUTE WS-HALF-LIMIT = (WS-LIMIT + 1) / 2

           MOVE 1 TO WS-IDX
           MOVE 3 TO WS-P

           PERFORM UNTIL WS-IDX >= WS-HALF-LIMIT
                      OR WS-PRIME-COUNT >= 1000000
               IF WS-COMPOSITE(WS-IDX) = 'N'
                   ADD 1 TO WS-PRIME-COUNT
                   MOVE WS-P TO WS-PRIME-NUM(WS-PRIME-COUNT)

                   COMPUTE WS-IDX-A = WS-IDX + WS-P
                   PERFORM UNTIL WS-IDX-A >= WS-HALF-LIMIT
                       MOVE 'Y' TO WS-COMPOSITE(WS-IDX-A)
                       ADD WS-P TO WS-IDX-A
                   END-PERFORM
               END-IF

               ADD 2 TO WS-P
               ADD 1 TO WS-IDX
           END-PERFORM

           DISPLAY 'Generated ' WS-PRIME-COUNT ' primes'
           .

       DISPLAY-FIRST-20-PAIRS.
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 20
               COMPUTE WS-IDX = WS-I + 1
               MOVE WS-PRIME-NUM(WS-IDX) TO WS-PRIME
               DIVIDE WS-PRIME BY 2 GIVING WS-HALF-PRIME

               MOVE WS-HALF-PRIME TO WS-OUT-NUM1
               ADD 1 TO WS-HALF-PRIME GIVING WS-OUT-NUM2
               MOVE WS-PRIME TO WS-OUT-SUM

               DISPLAY WS-OUTPUT-LINE
           END-PERFORM
           .

       DISPLAY-MILLIONTH-PAIR.
           MOVE WS-PRIME-NUM(1000000) TO WS-PRIME
           DIVIDE WS-PRIME BY 2 GIVING WS-HALF-PRIME

           MOVE WS-HALF-PRIME TO WS-OUT-NUM1
           ADD 1 TO WS-HALF-PRIME GIVING WS-OUT-NUM2
           MOVE WS-PRIME TO WS-OUT-SUM

           DISPLAY WS-OUTPUT-LINE
           .
