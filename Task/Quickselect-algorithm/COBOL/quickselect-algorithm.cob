       CLASS-ID MainProgram.

       METHOD-ID Partition STATIC USING T.
       CONSTRAINTS.
           CONSTRAIN T IMPLEMENTS type IComparable.

       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01  pivot-val              T.

       PROCEDURE DIVISION USING VALUE arr AS T OCCURS ANY,
               left-idx AS BINARY-LONG, right-idx AS BINARY-LONG,
               pivot-idx AS BINARY-LONG
               RETURNING ret AS BINARY-LONG.
           MOVE arr (pivot-idx) TO pivot-val
           INVOKE self::Swap(arr, pivot-idx, right-idx)
           DECLARE store-idx AS BINARY-LONG = left-idx
           PERFORM VARYING i AS BINARY-LONG FROM left-idx BY 1
                   UNTIL i > right-idx
               IF arr (i) < pivot-val
                   INVOKE self::Swap(arr, i, store-idx)
                   ADD 1 TO store-idx
               END-IF
           END-PERFORM
           INVOKE self::Swap(arr, right-idx, store-idx)

           MOVE store-idx TO ret
       END METHOD.

       METHOD-ID Quickselect STATIC USING T.
       CONSTRAINTS.
           CONSTRAIN T IMPLEMENTS type IComparable.

       PROCEDURE DIVISION USING VALUE arr AS T OCCURS ANY,
               left-idx AS BINARY-LONG, right-idx AS BINARY-LONG,
               n AS BINARY-LONG
               RETURNING ret AS T.
           IF left-idx = right-idx
               MOVE arr (left-idx) TO ret
               GOBACK
           END-IF

           DECLARE rand AS TYPE Random = NEW Random()
           DECLARE pivot-idx AS BINARY-LONG = rand::Next(left-idx, right-idx)
           DECLARE pivot-new-idx AS BINARY-LONG
               = self::Partition(arr, left-idx, right-idx, pivot-idx)
           DECLARE pivot-dist AS BINARY-LONG = pivot-new-idx - left-idx + 1

           EVALUATE TRUE
               WHEN pivot-dist = n
                   MOVE arr (pivot-new-idx) TO ret

               WHEN n < pivot-dist
                   INVOKE self::Quickselect(arr, left-idx, pivot-new-idx - 1, n)
                       RETURNING ret

               WHEN OTHER
                   INVOKE self::Quickselect(arr, pivot-new-idx + 1, right-idx,
                       n - pivot-dist) RETURNING ret
           END-EVALUATE
       END METHOD.

       METHOD-ID Swap STATIC USING T.
       CONSTRAINTS.
           CONSTRAIN T IMPLEMENTS type IComparable.

       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01  temp                   T.

       PROCEDURE DIVISION USING arr AS T OCCURS ANY,
               VALUE idx-1 AS BINARY-LONG, idx-2 AS BINARY-LONG.
           IF idx-1 <> idx-2
               MOVE arr (idx-1) TO temp
               MOVE arr (idx-2) TO arr (idx-1)
               MOVE temp TO arr (idx-2)
           END-IF
       END METHOD.

       METHOD-ID Main STATIC.
       PROCEDURE DIVISION.
           DECLARE input-array AS BINARY-LONG OCCURS ANY
               = TABLE OF BINARY-LONG(9, 8, 7, 6, 5, 0, 1, 2, 3, 4)
           DISPLAY "Loop quick select 10 times."
           PERFORM VARYING i AS BINARY-LONG FROM 1 BY 1 UNTIL i > 10
               DISPLAY self::Quickselect(input-array, 1, input-array::Length, i)
                   NO ADVANCING

               IF i < 10
                   DISPLAY ", " NO ADVANCING
               END-IF
           END-PERFORM
           DISPLAY SPACE
       END METHOD.
       END CLASS.
