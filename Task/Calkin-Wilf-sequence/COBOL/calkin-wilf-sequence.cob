IDENTIFICATION DIVISION.
       PROGRAM-ID. CALKIN-WILF.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      *> Current term
       01  WS-TERM-N               PIC S9(18) VALUE 1.
       01  WS-TERM-D               PIC S9(18) VALUE 1.

      *> Loop counter
       01  WS-INDEX                PIC 9(4).

      *>----------------------------------------------------------------
      *> GCD helper inputs/output
      *>----------------------------------------------------------------
       01  WS-GCD-A                PIC S9(18).
       01  WS-GCD-B                PIC S9(18).
       01  WS-GCD-TEMP             PIC S9(18).
       01  WS-GCD-OUT              PIC S9(18).

      *>----------------------------------------------------------------
      *> NEXT-CALKIN-WILF working storage
      *>----------------------------------------------------------------
      *> floor(term)
       01  WS-FL-N                 PIC S9(18).
      *> 2*floor+1  (always integer so denom=1)
       01  WS-TMP-N                PIC S9(18).
      *> divisor = (2*floor+1) - term
       01  WS-DIVIS-N              PIC S9(18).
       01  WS-DIVIS-D              PIC S9(18).
      *> next term = 1 / divisor
       01  WS-NEXT-N               PIC S9(18).
       01  WS-NEXT-D               PIC S9(18).

      *>----------------------------------------------------------------
      *> Continued fraction
      *>----------------------------------------------------------------
       01  WS-CF-N                 PIC S9(18).
       01  WS-CF-D                 PIC S9(18).
       01  WS-CF-TMP               PIC S9(18).
       01  WS-CF-SIZE              PIC 9(4) VALUE 0.
       01  WS-CF-TABLE.
           05  WS-CF-ENTRY         PIC S9(18) OCCURS 128 TIMES.
       01  WS-CF-BACK              PIC S9(18).

      *>----------------------------------------------------------------
      *> TERM-INDEX working storage
      *>----------------------------------------------------------------
       01  WS-TI-RESULT            PIC S9(18) VALUE 0.
       01  WS-TI-BIT               PIC S9(18) VALUE 1.
       01  WS-TI-POWER             PIC 9(4)   VALUE 0.
       01  WS-TI-I                 PIC 9(4).
       01  WS-TI-J                 PIC 9(4).
       01  WS-TI-TERM              PIC S9(18).
       01  WS-TI-SHIFT             PIC S9(18).

      *>----------------------------------------------------------------
      *> Input rational
      *>----------------------------------------------------------------
       01  WS-IN-N                 PIC S9(18) VALUE 83116.
       01  WS-IN-D                 PIC S9(18) VALUE 51639.

      *>----------------------------------------------------------------
      *> Display helpers
      *>----------------------------------------------------------------
       01  WS-DISP-IDX             PIC Z9.
       01  WS-DISP-N               PIC S9(18).
       01  WS-DISP-D               PIC S9(18).
       01  WS-DISP-RES             PIC S9(18).

       PROCEDURE DIVISION.
       MAIN-PARA.
           DISPLAY "First 20 terms of the Calkin-Wilf sequence are:"

           MOVE 1 TO WS-TERM-N
           MOVE 1 TO WS-TERM-D

           PERFORM VARYING WS-INDEX FROM 1 BY 1
               UNTIL WS-INDEX > 20
               MOVE WS-INDEX    TO WS-DISP-IDX
               MOVE WS-TERM-N   TO WS-DISP-N
               MOVE WS-TERM-D   TO WS-DISP-D
               DISPLAY WS-DISP-IDX ": " WS-DISP-N "/" WS-DISP-D

               PERFORM NEXT-CALKIN-WILF
               MOVE WS-NEXT-N TO WS-TERM-N
               MOVE WS-NEXT-D TO WS-TERM-D
           END-PERFORM

           DISPLAY SPACES

           MOVE WS-IN-N TO WS-CF-N
           MOVE WS-IN-D TO WS-CF-D
           PERFORM CONTINUED-FRACTION-PARA
           PERFORM TERM-INDEX-PARA

           MOVE WS-IN-N        TO WS-DISP-N
           MOVE WS-IN-D        TO WS-DISP-D
           MOVE WS-TI-RESULT   TO WS-DISP-RES
           DISPLAY " " WS-DISP-N "/" WS-DISP-D
               " is the " WS-DISP-RES "th term of the sequence."

           STOP RUN.

      *>----------------------------------------------------------------
      *> NEXT-CALKIN-WILF
      *>   Input : WS-TERM-N, WS-TERM-D
      *>   Output: WS-NEXT-N, WS-NEXT-D
      *>
      *>   next = 1 / (2*floor(n/d) + 1 - n/d)
      *>
      *>   Working entirely with numerator over WS-TERM-D denominator:
      *>     floor(n/d)       -> integer q = n/d  (COBOL integer divide)
      *>     2*q + 1          -> integer (2q+1)
      *>     (2q+1) - n/d     -> expressed as ((2q+1)*d - n) / d
      *>     1 / above        -> d / ((2q+1)*d - n)   then reduce
      *>----------------------------------------------------------------
       NEXT-CALKIN-WILF.
           COMPUTE WS-FL-N = WS-TERM-N / WS-TERM-D
           COMPUTE WS-TMP-N = 2 * WS-FL-N + 1

      *>    divisor numerator = (2q+1)*d - n,  denominator = d
           COMPUTE WS-DIVIS-N = WS-TMP-N * WS-TERM-D - WS-TERM-N
           MOVE WS-TERM-D TO WS-DIVIS-D

      *>    next = 1/divisor = d / ((2q+1)*d - n)
           MOVE WS-DIVIS-D TO WS-NEXT-N
           MOVE WS-DIVIS-N TO WS-NEXT-D

           MOVE WS-NEXT-N TO WS-GCD-A
           IF WS-GCD-A < 0
               COMPUTE WS-GCD-A = -WS-GCD-A
           END-IF
           MOVE WS-NEXT-D TO WS-GCD-B
           PERFORM GCD-PARA
           DIVIDE WS-GCD-OUT INTO WS-NEXT-N
           DIVIDE WS-GCD-OUT INTO WS-NEXT-D.

      *>----------------------------------------------------------------
      *> GCD (iterative Euclidean)
      *>   Input : WS-GCD-A (>= 0), WS-GCD-B
      *>   Output: WS-GCD-OUT
      *>----------------------------------------------------------------
       GCD-PARA.
           PERFORM UNTIL WS-GCD-B = 0
               MOVE WS-GCD-B  TO WS-GCD-TEMP
               COMPUTE WS-GCD-B =
                   FUNCTION MOD(WS-GCD-A, WS-GCD-B)
               MOVE WS-GCD-TEMP TO WS-GCD-A
           END-PERFORM
           MOVE WS-GCD-A TO WS-GCD-OUT.

      *>----------------------------------------------------------------
      *> CONTINUED-FRACTION-PARA
      *>   Input : WS-CF-N, WS-CF-D
      *>   Output: WS-CF-TABLE(1..WS-CF-SIZE)
      *>----------------------------------------------------------------
       CONTINUED-FRACTION-PARA.
           MOVE 0 TO WS-CF-SIZE

           PERFORM UNTIL WS-CF-N = 1
               ADD 1 TO WS-CF-SIZE
               COMPUTE WS-CF-ENTRY(WS-CF-SIZE) =
                   WS-CF-N / WS-CF-D
               MOVE WS-CF-N  TO WS-CF-TMP
               MOVE WS-CF-D  TO WS-CF-N
               COMPUTE WS-CF-D =
                   FUNCTION MOD(WS-CF-TMP, WS-CF-D)
           END-PERFORM

      *>    If even-length, split last entry: [..., k] -> [..., k-1, 1]
           IF WS-CF-SIZE > 0 AND
               FUNCTION MOD(WS-CF-SIZE, 2) = 0
               MOVE WS-CF-ENTRY(WS-CF-SIZE) TO WS-CF-BACK
               COMPUTE WS-CF-ENTRY(WS-CF-SIZE) = WS-CF-BACK - 1
               ADD 1 TO WS-CF-SIZE
               MOVE 1 TO WS-CF-ENTRY(WS-CF-SIZE)
           END-IF.

      *>----------------------------------------------------------------
      *> TERM-INDEX-PARA
      *>   Input : WS-CF-TABLE(1..WS-CF-SIZE)
      *>   Output: WS-TI-RESULT
      *>
      *>   Reconstructs the binary representation by treating
      *>   continued fraction terms as run-length counts of
      *>   alternating 1-bits and 0-bits.
      *>----------------------------------------------------------------
       TERM-INDEX-PARA.
           MOVE 0 TO WS-TI-RESULT
           MOVE 1 TO WS-TI-BIT
           MOVE 0 TO WS-TI-POWER

           PERFORM VARYING WS-TI-I FROM 1 BY 1
               UNTIL WS-TI-I > WS-CF-SIZE

               MOVE WS-CF-ENTRY(WS-TI-I) TO WS-TI-TERM

               PERFORM VARYING WS-TI-J FROM 1 BY 1
                   UNTIL WS-TI-J > WS-TI-TERM
                   COMPUTE WS-TI-SHIFT =
                       WS-TI-BIT * (2 ** WS-TI-POWER)
                   ADD WS-TI-SHIFT TO WS-TI-RESULT
                   ADD 1 TO WS-TI-POWER
               END-PERFORM

               IF WS-TI-BIT = 0
                   MOVE 1 TO WS-TI-BIT
               ELSE
                   MOVE 0 TO WS-TI-BIT
               END-IF
           END-PERFORM.
