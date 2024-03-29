       IDENTIFICATION DIVISION.
       PROGRAM-ID. ATTRACTIVE-NUMBERS.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77 MAXIMUM         PIC 999 VALUE 120.
       01 SIEVE-DATA      VALUE SPACES.
          03 MARKER       PIC X OCCURS 120 TIMES.
             88 PRIME     VALUE SPACE.
          03 SIEVE-MAX    PIC 999.
          03 COMPOSITE    PIC 999.
          03 CANDIDATE    PIC 999.

       01 FACTORIZE-DATA.
          03 FACTOR-NUM   PIC 999.
          03 FACTORS      PIC 999.
          03 FACTOR       PIC 999.
          03 QUOTIENT     PIC 999V999.
          03 FILLER       REDEFINES QUOTIENT.
             05 FILLER    PIC 999.
             05 DECIMAL   PIC 999.

       01 OUTPUT-FORMAT.
          03 OUT-NUM      PIC ZZZ9.
          03 OUT-LINE     PIC X(72) VALUE SPACES.
          03 COL-PTR      PIC 99 VALUE 1.

       PROCEDURE DIVISION.
       BEGIN.
           PERFORM SIEVE.
           PERFORM CHECK-ATTRACTIVE
               VARYING CANDIDATE FROM 2 BY 1
               UNTIL CANDIDATE IS GREATER THAN MAXIMUM.
           PERFORM WRITE-LINE.
           STOP RUN.

       CHECK-ATTRACTIVE.
           MOVE CANDIDATE TO FACTOR-NUM.
           PERFORM FACTORIZE.
           IF PRIME(FACTORS), PERFORM ADD-TO-OUTPUT.

       ADD-TO-OUTPUT.
           MOVE CANDIDATE TO OUT-NUM.
           STRING OUT-NUM DELIMITED BY SIZE INTO OUT-LINE
               WITH POINTER COL-PTR.
           IF COL-PTR IS EQUAL TO 73, PERFORM WRITE-LINE.

       WRITE-LINE.
           DISPLAY OUT-LINE.
           MOVE SPACES TO OUT-LINE.
           MOVE 1 TO COL-PTR.

       FACTORIZE SECTION.
       BEGIN.
           MOVE ZERO TO FACTORS.
           PERFORM DIVIDE-PRIME
               VARYING FACTOR FROM 2 BY 1
               UNTIL FACTOR IS GREATER THAN MAXIMUM.
           GO TO DONE.

       DIVIDE-PRIME.
           IF PRIME(FACTOR),
               DIVIDE FACTOR-NUM BY FACTOR GIVING QUOTIENT,
               IF DECIMAL IS EQUAL TO ZERO,
                   ADD 1 TO FACTORS,
                   MOVE QUOTIENT TO FACTOR-NUM,
                   GO TO DIVIDE-PRIME.
       DONE.
           EXIT.

       SIEVE SECTION.
       BEGIN.
           MOVE 'X' TO MARKER(1).
           DIVIDE MAXIMUM BY 2 GIVING SIEVE-MAX.
           PERFORM SET-COMPOSITES THRU SET-COMPOSITES-LOOP
               VARYING CANDIDATE FROM 2 BY 1
               UNTIL CANDIDATE IS GREATER THAN SIEVE-MAX.
           GO TO DONE.

       SET-COMPOSITES.
           MULTIPLY CANDIDATE BY 2 GIVING COMPOSITE.
       SET-COMPOSITES-LOOP.
           IF COMPOSITE IS NOT GREATER THAN MAXIMUM,
               MOVE 'X' TO MARKER(COMPOSITE),
               ADD CANDIDATE TO COMPOSITE,
               GO TO SET-COMPOSITES-LOOP.
       DONE.
           EXIT.
