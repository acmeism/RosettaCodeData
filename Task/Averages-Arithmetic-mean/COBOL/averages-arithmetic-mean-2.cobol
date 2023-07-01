       IDENTIFICATION DIVISION.
       PROGRAM-ID. find-mean.

       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01  i                       PIC 9(4).

       01  summ                    USAGE FLOAT-LONG.

       LINKAGE SECTION.
       01  nums-area.
           03  nums-len            PIC 9(4).
           03  nums                USAGE FLOAT-LONG
                                   OCCURS 0 TO 1000 TIMES
                                   DEPENDING ON nums-len.

       01  result                  USAGE FLOAT-LONG.

       PROCEDURE DIVISION USING nums-area, result.
           IF nums-len = 0
               MOVE 0 TO result
               GOBACK
           END-IF

           DIVIDE FUNCTION SUM(nums (ALL)) BY nums-len GIVING result

           GOBACK
           .
