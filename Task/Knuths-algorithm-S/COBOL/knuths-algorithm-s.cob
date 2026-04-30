       IDENTIFICATION DIVISION.
       PROGRAM-ID. RESERVOIR-SAMPLING.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       *> ---------------------------------------------------------
       *> Test Parameters
       *> ---------------------------------------------------------
       01  TEST-PARAMETERS.
           05 CURRENT-N        PIC 99.
           05 CURRENT-M        PIC 99.

       *> ---------------------------------------------------------
       *> Loop and Array Indices
       *> ---------------------------------------------------------
       01  LOOP-COUNTERS.
           05 ITER-IDX         PIC 9(6).
           05 ITEM-VAL         PIC 99.
           05 IDX              PIC 99.
           05 FREQ-IDX         PIC 99.
           05 SAMPLE-IDX       PIC 99.

       *> ---------------------------------------------------------
       *> Reservoir Class Equivalent State
       *> ---------------------------------------------------------
       01  RESERVOIR-STATE.
           05 RES-M            PIC 9(6).
           05 RES-S-COUNT      PIC 99.
           05 RES-SAMPLE       OCCURS 10 TIMES PIC 99.

       *> ---------------------------------------------------------
       *> Output / Frequency Array
       *> ---------------------------------------------------------
       01  RESULTS-DATA.
           05 FREQS            OCCURS 10 TIMES PIC 9(6) VALUE 0.

       *> ---------------------------------------------------------
       *> Random Number Variables
       *> ---------------------------------------------------------
       01  RANDOM-DATA.
           05 SEED             PIC 9(7).
           05 DUMMY            PIC V9(9).
           05 RAND-INT         PIC 9(6).

       *> ---------------------------------------------------------
       *> String Formatting Variables
       *> ---------------------------------------------------------
       01  DISPLAY-FORMATTING.
           05 OUT-BUFFER       PIC X(120).
           05 PTR              PIC 999.
           05 DISP-N           PIC 9.
           05 DISP-M           PIC Z9.
           05 DISP-FREQ        PIC Z(5)9.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           *> Seed the random number generator using system time
           MOVE FUNCTION CURRENT-DATE(10:7) TO SEED
           COMPUTE DUMMY = FUNCTION RANDOM(SEED)

           *> Execute First Test Case: n=3, m=3
           MOVE 3 TO CURRENT-N
           MOVE 3 TO CURRENT-M
           PERFORM RUN-TEST-CASE

           *> Execute Second Test Case: n=3, m=10
           MOVE 3 TO CURRENT-N
           MOVE 10 TO CURRENT-M
           PERFORM RUN-TEST-CASE

           STOP RUN.

       *> ---------------------------------------------------------
       *> Handles 100,000 iterations for a specific test case
       *> ---------------------------------------------------------
       RUN-TEST-CASE.
           *> Reset frequencies array to zeros
           PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > CURRENT-M
               MOVE 0 TO FREQS(IDX)
           END-PERFORM

           *> Run simulation loop 1e5 (100,000) times
           PERFORM VARYING ITER-IDX FROM 1 BY 1 UNTIL ITER-IDX > 100000
               PERFORM RUN-SINGLE-ITERATION
           END-PERFORM

           PERFORM PRINT-RESULTS.

       *> ---------------------------------------------------------
       *> One single iteration (creating a new reservoir simulation)
       *> ---------------------------------------------------------
       RUN-SINGLE-ITERATION.
           *> Initialize class variables
           MOVE CURRENT-N TO RES-M
           MOVE 0 TO RES-S-COUNT

           *> Loop over items x from 0 to m-1
           PERFORM VARYING ITEM-VAL FROM 0 BY 1
                     UNTIL ITEM-VAL = CURRENT-M
               PERFORM ADD-TO-RESERVOIR
           END-PERFORM

           *> Count frequencies in our resulting sample array
           PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > CURRENT-N
               *> COBOL arrays are 1-indexed, map item value to 1-index
               COMPUTE FREQ-IDX = RES-SAMPLE(IDX) + 1
               ADD 1 TO FREQS(FREQ-IDX)
           END-PERFORM.

       *> ---------------------------------------------------------
       *> The `add(item)` method logic
       *> ---------------------------------------------------------
       ADD-TO-RESERVOIR.
           IF RES-S-COUNT < CURRENT-N
               *> Array isn't full yet, add item
               ADD 1 TO RES-S-COUNT
               MOVE ITEM-VAL TO RES-SAMPLE(RES-S-COUNT)
           ELSE
               *> Increment items seen
               ADD 1 TO RES-M

               *> Math.floor(Math.random() * ++this.m)
               COMPUTE RAND-INT =
                   FUNCTION INTEGER(FUNCTION RANDOM * RES-M)

               *> If random number is less than n, replace an item
               IF RAND-INT < CURRENT-N
                   *> Convert 0-based random to 1-based COBOL index
                   COMPUTE SAMPLE-IDX = RAND-INT + 1
                   MOVE ITEM-VAL TO RES-SAMPLE(SAMPLE-IDX)
               END-IF
           END-IF.

       *> ---------------------------------------------------------
       *> Formats and Prints the array (equivalent to console.log)
       *> ---------------------------------------------------------
       PRINT-RESULTS.
           MOVE SPACES TO OUT-BUFFER
           MOVE 1 TO PTR
           MOVE CURRENT-N TO DISP-N
           MOVE CURRENT-M TO DISP-M

           *> Build the string prefix
           STRING "Results for n=" DELIMITED BY SIZE
                  DISP-N DELIMITED BY SIZE
                  ", m=" DELIMITED BY SIZE
                  DISP-M DELIMITED BY SIZE
                  ": [" DELIMITED BY SIZE
                  INTO OUT-BUFFER WITH POINTER PTR

           *> Join the array numbers
           PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > CURRENT-M
               MOVE FREQS(IDX) TO DISP-FREQ
               IF IDX = CURRENT-M
                   STRING DISP-FREQ DELIMITED BY SIZE
                          "]" DELIMITED BY SIZE
                          INTO OUT-BUFFER WITH POINTER PTR
               ELSE
                   STRING DISP-FREQ DELIMITED BY SIZE
                          "," DELIMITED BY SIZE
                          INTO OUT-BUFFER WITH POINTER PTR
               END-IF
           END-PERFORM

           DISPLAY OUT-BUFFER.
