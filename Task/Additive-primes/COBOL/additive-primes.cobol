       IDENTIFICATION DIVISION.
       PROGRAM-ID. ADDITIVE-PRIMES.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 VARIABLES.
          03 MAXIMUM            PIC 999.
          03 AMOUNT             PIC 999.
          03 CANDIDATE          PIC 999.
          03 DIGIT              PIC 9 OCCURS 3 TIMES,
                                REDEFINES CANDIDATE.
          03 DIGITSUM           PIC 99.

       01 PRIME-DATA.
          03 COMPOSITE-FLAG     PIC X OCCURS 500 TIMES.
             88 PRIME           VALUE ' '.
          03 SIEVE-PRIME        PIC 999.
          03 SIEVE-COMP-START   PIC 999.
          03 SIEVE-COMP         PIC 999.
          03 SIEVE-MAX          PIC 999.

       01 OUT-FMT.
          03 NUM-FMT            PIC ZZZ9.
          03 OUT-LINE           PIC X(40).
          03 OUT-PTR            PIC 99.

       PROCEDURE DIVISION.
       BEGIN.
           MOVE 500 TO MAXIMUM.
           MOVE 1 TO OUT-PTR.
           PERFORM SIEVE.
           MOVE ZERO TO AMOUNT.
           PERFORM TEST-NUMBER
               VARYING CANDIDATE FROM 2 BY 1
               UNTIL CANDIDATE IS GREATER THAN MAXIMUM.
           DISPLAY OUT-LINE.
           DISPLAY SPACES.
           MOVE AMOUNT TO NUM-FMT.
           DISPLAY 'Amount of additive primes found: ' NUM-FMT.
           STOP RUN.

       TEST-NUMBER.
           ADD DIGIT(1), DIGIT(2), DIGIT(3) GIVING DIGITSUM.
           IF PRIME(CANDIDATE) AND PRIME(DIGITSUM),
               ADD 1 TO AMOUNT,
               PERFORM WRITE-NUMBER.

       WRITE-NUMBER.
           MOVE CANDIDATE TO NUM-FMT.
           STRING NUM-FMT DELIMITED BY SIZE INTO OUT-LINE
               WITH POINTER OUT-PTR.
           IF OUT-PTR IS GREATER THAN 40,
               DISPLAY OUT-LINE,
               MOVE SPACES TO OUT-LINE,
               MOVE 1 TO OUT-PTR.

       SIEVE.
           MOVE SPACES TO PRIME-DATA.
           DIVIDE MAXIMUM BY 2 GIVING SIEVE-MAX.
           PERFORM SIEVE-OUTER-LOOP
               VARYING SIEVE-PRIME FROM 2 BY 1
               UNTIL SIEVE-PRIME IS GREATER THAN SIEVE-MAX.

       SIEVE-OUTER-LOOP.
           IF PRIME(SIEVE-PRIME),
               MULTIPLY SIEVE-PRIME BY 2 GIVING SIEVE-COMP-START,
               PERFORM SIEVE-INNER-LOOP
                   VARYING SIEVE-COMP
                       FROM SIEVE-COMP-START BY SIEVE-PRIME
                   UNTIL SIEVE-COMP IS GREATER THAN MAXIMUM.

       SIEVE-INNER-LOOP.
           MOVE 'X' TO COMPOSITE-FLAG(SIEVE-COMP).
