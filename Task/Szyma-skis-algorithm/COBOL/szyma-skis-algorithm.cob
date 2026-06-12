IDENTIFICATION DIVISION.
       PROGRAM-ID. SZYMANSKI.

      *>================================================================
      *> Szymanski's Mutual Exclusion Algorithm
      *> Simulated multi-threading via cooperative round-robin scheduling
      *>================================================================

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *> Constants
       01  MAX-THREADS            PIC 99 VALUE 20.
       01  MAX-ID                 PIC 99 VALUE 20.

      *> Shared critical value (equivalent to Java's criticalValue)
       01  CRITICAL-VALUE         PIC S9(9) VALUE 1.

      *> Flag table: FLAGS(i) = flag for thread i (0..4)
      *> Index 1..20 maps to thread IDs 1..20
       01  FLAGS-TABLE.
           05  FLAGS              PIC 9 OCCURS 20 TIMES VALUE 0.

      *> Thread state table
      *>   STATE: 0=NOT-STARTED, 1=RUNNING, 2=DONE
       01  THREAD-TABLE.
           05  THREAD-ENTRY       OCCURS 20 TIMES.
               10  THREAD-ID      PIC 99.
               10  THREAD-STATE   PIC 9.
               10  THREAD-PC      PIC 99.
                                          *> Program Counter
               10  THREAD-PHASE   PIC 99.
                                          *> Sub-step within phase

      *> Scheduler variables
       01  ACTIVE-COUNT           PIC 99.
       01  SCHED-IDX              PIC 99.
       01  CURRENT-ID             PIC 99.
       01  ALL-DONE               PIC 9.

      *> Temporaries used by thread logic
       01  TMP-FLAG               PIC 9.
       01  TMP-T                  PIC 99.
       01  TMP-IDX                PIC 99.
       01  TMP-BOOL               PIC 9.
                                          *> 0=false,1=true
       01  OTHERS-HAS-GE3         PIC 9.
       01  OTHERS-HAS-EQ1         PIC 9.
       01  OTHERS-HAS-EQ4         PIC 9.
       01  LOWER-DONE             PIC 9.
       01  UPPER-DONE             PIC 9.
       01  TMP-CALC               PIC S9(9).
       01  TMP-REMAINDER          PIC S9(9).
       01  DISPLAY-ID             PIC 99.
       01  DISPLAY-VAL            PIC S9(9).

      *> Phase constants (program counter values = steps in runSzymanski)
      *>  PC 01: Set flag=1, check others < 3
      *>  PC 02: Spin: any other flag >= 3?
      *>  PC 03: Set flag=3, check if any other == 1
      *>  PC 04: If needed set flag=2, wait for any other == 4
      *>  PC 05: Spin: any other flag == 4?
      *>  PC 06: Set flag=4
      *>  PC 07: Wait for lower-ID threads: flag(t) <= 1
      *>  PC 08: Spin lower-ID
      *>  PC 09: CRITICAL SECTION
      *>  PC 10: Exit - wait for higher-ID threads
      *>  PC 11: Spin higher-ID
      *>  PC 12: Set flag=0, mark DONE

       01  PC-INIT                PIC 99 VALUE 1.
       01  PC-SPIN-GE3            PIC 99 VALUE 2.
       01  PC-DOORWAY             PIC 99 VALUE 3.
       01  PC-CHECK-EQ1           PIC 99 VALUE 4.
       01  PC-SPIN-EQ4            PIC 99 VALUE 5.
       01  PC-CLOSE-DOOR          PIC 99 VALUE 6.
       01  PC-INIT-LOWER          PIC 99 VALUE 7.
       01  PC-SPIN-LOWER          PIC 99 VALUE 8.
       01  PC-CRITICAL            PIC 99 VALUE 9.
       01  PC-INIT-UPPER          PIC 99 VALUE 10.
       01  PC-SPIN-UPPER          PIC 99 VALUE 11.
       01  PC-EXIT                PIC 99 VALUE 12.

      *> Lower/upper scan index per thread
       01  SCAN-T                 OCCURS 20 TIMES PIC 99.
       01  NEEDS-WAIT             OCCURS 20 TIMES PIC 9.
                                          *> did thread need to wait at
                                          *> doorway?

       PROCEDURE DIVISION.

      *>================================================================
       MAIN-PARA.
           PERFORM INIT-THREADS
           PERFORM SCHEDULER UNTIL ALL-DONE = 1
           STOP RUN.

      *>================================================================
       INIT-THREADS.
           MOVE 0 TO ALL-DONE
           MOVE 0 TO ACTIVE-COUNT
           PERFORM VARYING TMP-IDX FROM 1 BY 1
               UNTIL TMP-IDX > MAX-THREADS
               MOVE TMP-IDX  TO THREAD-ID(TMP-IDX)
               MOVE 1        TO THREAD-STATE(TMP-IDX)
               MOVE 1        TO THREAD-PC(TMP-IDX)
               MOVE 0        TO THREAD-PHASE(TMP-IDX)
               MOVE 0        TO FLAGS(TMP-IDX)
               MOVE 0        TO NEEDS-WAIT(TMP-IDX)
               MOVE 1        TO SCAN-T(TMP-IDX)
               ADD 1         TO ACTIVE-COUNT
           END-PERFORM.

      *>================================================================
      *> Round-robin scheduler: give each RUNNING thread one step
      *>================================================================
       SCHEDULER.
           MOVE 0 TO ACTIVE-COUNT
           PERFORM VARYING SCHED-IDX FROM 1 BY 1
               UNTIL SCHED-IDX > MAX-THREADS
               IF THREAD-STATE(SCHED-IDX) = 1
                   MOVE THREAD-ID(SCHED-IDX) TO CURRENT-ID
                   PERFORM STEP-THREAD
                   ADD 1 TO ACTIVE-COUNT
               END-IF
           END-PERFORM
           IF ACTIVE-COUNT = 0
               MOVE 1 TO ALL-DONE
           END-IF.

      *>================================================================
      *> Execute one step of thread CURRENT-ID based on its PC
      *>================================================================
       STEP-THREAD.
           EVALUATE THREAD-PC(CURRENT-ID)
               WHEN 1  PERFORM STEP-01
               WHEN 2  PERFORM STEP-02
               WHEN 3  PERFORM STEP-03
               WHEN 4  PERFORM STEP-04
               WHEN 5  PERFORM STEP-05
               WHEN 6  PERFORM STEP-06
               WHEN 7  PERFORM STEP-07
               WHEN 8  PERFORM STEP-08
               WHEN 9  PERFORM STEP-09
               WHEN 10 PERFORM STEP-10
               WHEN 11 PERFORM STEP-11
               WHEN 12 PERFORM STEP-12
           END-EVALUATE.

      *> PC=1: Set own flag to 1 (standing outside waiting room)
       STEP-01.
           MOVE 1 TO FLAGS(CURRENT-ID)
           MOVE 2 TO THREAD-PC(CURRENT-ID).

      *> PC=2: Spin while any other flag >= 3
       STEP-02.
           MOVE 0 TO OTHERS-HAS-GE3
           PERFORM VARYING TMP-IDX FROM 1 BY 1
               UNTIL TMP-IDX > MAX-THREADS
               IF TMP-IDX NOT = CURRENT-ID
                   IF FLAGS(TMP-IDX) >= 3
                       MOVE 1 TO OTHERS-HAS-GE3
                   END-IF
               END-IF
           END-PERFORM
           IF OTHERS-HAS-GE3 = 0
               MOVE 3 TO THREAD-PC(CURRENT-ID)
           END-IF.
                                          *> else: stay at PC=2 (yield)

      *> PC=3: Set own flag to 3 (standing in doorway)
       STEP-03.
           MOVE 3 TO FLAGS(CURRENT-ID)
           MOVE 0 TO NEEDS-WAIT(CURRENT-ID)
           PERFORM VARYING TMP-IDX FROM 1 BY 1
               UNTIL TMP-IDX > MAX-THREADS
               IF TMP-IDX NOT = CURRENT-ID
                   IF FLAGS(TMP-IDX) = 1
                       MOVE 1 TO NEEDS-WAIT(CURRENT-ID)
                   END-IF
               END-IF
           END-PERFORM
           MOVE 4 TO THREAD-PC(CURRENT-ID).

      *> PC=4: If any other had flag=1, set own flag=2 and go wait;
      *>        else skip straight to close-door
       STEP-04.
           IF NEEDS-WAIT(CURRENT-ID) = 1
               MOVE 2 TO FLAGS(CURRENT-ID)
               MOVE 5 TO THREAD-PC(CURRENT-ID)
           ELSE
               MOVE 6 TO THREAD-PC(CURRENT-ID)
           END-IF.

      *> PC=5: Spin until any other flag == 4
       STEP-05.
           MOVE 0 TO OTHERS-HAS-EQ4
           PERFORM VARYING TMP-IDX FROM 1 BY 1
               UNTIL TMP-IDX > MAX-THREADS
               IF TMP-IDX NOT = CURRENT-ID
                   IF FLAGS(TMP-IDX) = 4
                       MOVE 1 TO OTHERS-HAS-EQ4
                   END-IF
               END-IF
           END-PERFORM
           IF OTHERS-HAS-EQ4 = 1
               MOVE 6 TO THREAD-PC(CURRENT-ID)
           END-IF.

      *> PC=6: Close the door (flag=4), init lower-scan
       STEP-06.
           MOVE 4 TO FLAGS(CURRENT-ID)
           MOVE 1 TO SCAN-T(CURRENT-ID)
           MOVE 7 TO THREAD-PC(CURRENT-ID).

      *> PC=7: Walk through lower-ID threads (t < CURRENT-ID)
      *>        find next t < current where flag > 1 and wait
       STEP-07.
           MOVE 0 TO TMP-BOOL
           MOVE SCAN-T(CURRENT-ID) TO TMP-IDX
           PERFORM UNTIL TMP-IDX >= CURRENT-ID OR TMP-BOOL = 1
               IF FLAGS(TMP-IDX) > 1
                   MOVE TMP-IDX TO SCAN-T(CURRENT-ID)
                   MOVE 1       TO TMP-BOOL
               ELSE
                   ADD 1 TO TMP-IDX
               END-IF
           END-PERFORM
           IF TMP-BOOL = 1
               MOVE 8 TO THREAD-PC(CURRENT-ID)
           ELSE
               MOVE 9 TO THREAD-PC(CURRENT-ID)
           END-IF.

      *> PC=8: Spin waiting for FLAGS(SCAN-T) <= 1
       STEP-08.
           MOVE SCAN-T(CURRENT-ID) TO TMP-IDX
           IF FLAGS(TMP-IDX) <= 1
               ADD 1 TO SCAN-T(CURRENT-ID)
               MOVE 7 TO THREAD-PC(CURRENT-ID)
           END-IF.

      *> PC=9: CRITICAL SECTION (atomic in sequential sim)
       STEP-09.
           COMPUTE TMP-CALC = CRITICAL-VALUE + (CURRENT-ID * 3)
           COMPUTE CRITICAL-VALUE = TMP-CALC / 2
           MOVE CURRENT-ID    TO DISPLAY-ID
           MOVE CRITICAL-VALUE TO DISPLAY-VAL
           DISPLAY "Thread " DISPLAY-ID
               " changed the critical value to " DISPLAY-VAL "."
           MOVE 1  TO SCAN-T(CURRENT-ID)
           MOVE 10 TO THREAD-PC(CURRENT-ID).

      *> PC=10: Walk through upper-ID threads (t > CURRENT-ID)
      *>         find next t > current where flag NOT IN (0,1,4)
       STEP-10.
           MOVE 0 TO TMP-BOOL
           MOVE SCAN-T(CURRENT-ID) TO TMP-IDX
           PERFORM UNTIL TMP-IDX > MAX-THREADS OR TMP-BOOL = 1
               IF TMP-IDX > CURRENT-ID
                   IF FLAGS(TMP-IDX) NOT = 0 AND
                      FLAGS(TMP-IDX) NOT = 1 AND
                      FLAGS(TMP-IDX) NOT = 4
                       MOVE TMP-IDX TO SCAN-T(CURRENT-ID)
                       MOVE 1       TO TMP-BOOL
                   ELSE
                       ADD 1 TO TMP-IDX
                   END-IF
               ELSE
                   ADD 1 TO TMP-IDX
               END-IF
           END-PERFORM
           IF TMP-BOOL = 1
               MOVE 11 TO THREAD-PC(CURRENT-ID)
           ELSE
               MOVE 12 TO THREAD-PC(CURRENT-ID)
           END-IF.

      *> PC=11: Spin until FLAGS(SCAN-T) IN (0,1,4)
       STEP-11.
           MOVE SCAN-T(CURRENT-ID) TO TMP-IDX
           IF FLAGS(TMP-IDX) = 0 OR
              FLAGS(TMP-IDX) = 1 OR
              FLAGS(TMP-IDX) = 4
               ADD 1 TO SCAN-T(CURRENT-ID)
               MOVE 10 TO THREAD-PC(CURRENT-ID)
           END-IF.

      *> PC=12: Set flag=0, mark thread as DONE
       STEP-12.
           MOVE 0 TO FLAGS(CURRENT-ID)
           MOVE 2 TO THREAD-STATE(CURRENT-ID).
