       IDENTIFICATION DIVISION.
       PROGRAM-ID. extract-range-task.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  data-str                PIC X(200) VALUE "0,  1,  2,  4,  6,"
           & " 7,  8, 11, 12, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, "
           & "24, 25, 27, 28, 29, 30, 31, 32, 33, 35, 36, 37, 38, 39".

       01  result                  PIC X(200).

       PROCEDURE DIVISION.
           CALL "extract-range" USING CONTENT data-str, REFERENCE result
           DISPLAY FUNCTION TRIM(result)

           GOBACK
           .
       END PROGRAM extract-range-task.


       IDENTIFICATION DIVISION.
       PROGRAM-ID. extract-range.

       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       COPY "nums-table.cpy".

       01  difference              PIC 999.

       01  rng-begin               PIC S999.
       01  rng-end                 PIC S999.

       01  num-trailing            PIC 999.

       01  trailing-comma-pos      PIC 999.

       LINKAGE SECTION.
       01  nums-str                PIC X(200).
       01  extracted-range         PIC X(200).

       01  extracted-range-len     CONSTANT LENGTH extracted-range.

       PROCEDURE DIVISION USING nums-str, extracted-range.
           CALL "split-nums" USING CONTENT nums-str, ", ",
               REFERENCE nums-table

           *> Process the table
           MOVE nums (1) TO rng-begin
           PERFORM VARYING nums-idx FROM 2 BY 1
                   UNTIL num-nums < nums-idx
               SUBTRACT nums (nums-idx - 1) FROM nums (nums-idx)
                   GIVING difference

               *> If number is more than one away from the previous one
               *> end the range and start a new one.
               IF difference > 1
                   MOVE nums (nums-idx - 1) TO rng-end
                   CALL "add-next-range" USING CONTENT rng-begin,
                       rng-end, REFERENCE extracted-range
                   MOVE nums (nums-idx) TO rng-begin
               END-IF
           END-PERFORM

           *> Process the last number
           MOVE nums (num-nums) TO rng-end
           CALL "add-next-range" USING CONTENT rng-begin,
               rng-end, REFERENCE extracted-range

           *> Remove trailing comma.
           CALL "find-num-trailing-spaces"
               USING CONTENT extracted-range, REFERENCE num-trailing
           COMPUTE trailing-comma-pos =
               extracted-range-len - num-trailing
           MOVE SPACE TO extracted-range (trailing-comma-pos:1)

           GOBACK
           .

       IDENTIFICATION DIVISION.
       PROGRAM-ID. split-nums INITIAL.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  num-len                 PIC 9.
       01  next-num-pos            PIC 999.

       LINKAGE SECTION.
       01  str                     PIC X(200).
       01  delim                   PIC X ANY LENGTH.

       COPY "nums-table.cpy".

       PROCEDURE DIVISION USING str, delim, nums-table.
           INITIALIZE num-nums

           PERFORM UNTIL str = SPACES
               INITIALIZE num-len
               INSPECT str TALLYING num-len FOR CHARACTERS BEFORE delim

               ADD 1 TO num-nums

               *> If there are no more instances of delim in the string,
               *> add the rest of the string to the last element of the
               *> table.
               IF num-len = 0
                   MOVE str TO nums (num-nums)
                   EXIT PERFORM
               ELSE
                   MOVE str (1:num-len) TO nums (num-nums)
                   ADD 3 TO num-len GIVING next-num-pos
                   MOVE str (next-num-pos:) TO str
               END-IF
           END-PERFORM
           .
       END PROGRAM split-nums.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. add-next-range INITIAL.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  num-trailing            PIC 999.
       01  start-pos               PIC 999.

       01  range-len               PIC 999.

       01  begin-edited            PIC -ZZ9.
       01  end-edited              PIC -ZZ9.

       LINKAGE SECTION.
       01  rng-begin               PIC S999.
       01  rng-end                 PIC S999.

       01  extracted-range         PIC X(200).

       01  extracted-range-len     CONSTANT LENGTH extracted-range.

       PROCEDURE DIVISION USING rng-begin, rng-end, extracted-range.
           CALL "find-num-trailing-spaces"
               USING CONTENT extracted-range, REFERENCE num-trailing
           COMPUTE start-pos = extracted-range-len - num-trailing + 1

           SUBTRACT rng-begin FROM rng-end GIVING range-len

           MOVE rng-begin TO begin-edited
           MOVE rng-end TO end-edited

           EVALUATE TRUE
               WHEN rng-begin = rng-end
                   STRING FUNCTION TRIM(begin-edited), ","
                       INTO extracted-range (start-pos:)

               WHEN range-len = 1
                   STRING FUNCTION TRIM(begin-edited), ",",
                       FUNCTION TRIM(end-edited), ","
                       INTO extracted-range (start-pos:)

               WHEN OTHER
                   STRING FUNCTION TRIM(begin-edited), "-",
                         FUNCTION TRIM(end-edited), ","
                         INTO extracted-range (start-pos:)
           END-EVALUATE
           .
       END PROGRAM add-next-range.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. find-num-trailing-spaces.

       DATA DIVISION.
       LINKAGE SECTION.
       01  str                     PIC X(200).
       01  num-trailing            PIC 999.

       PROCEDURE DIVISION USING str, num-trailing.
           INITIALIZE num-trailing
           INSPECT str TALLYING num-trailing FOR TRAILING SPACES
           .
       END PROGRAM find-num-trailing-spaces.

       END PROGRAM extract-range.
