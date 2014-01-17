       >>SOURCE FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. std-dev.

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
REPOSITORY.
    FUNCTION sum-arr
    .
DATA DIVISION.
WORKING-STORAGE SECTION.
78  Arr-Len                   VALUE 8.
01  arr-area                  VALUE "0204040405050709".
    03  arr                   PIC 99 OCCURS Arr-Len TIMES.

01  i                         PIC 99.

01  avg                       PIC 9(3)V99.

01  std-dev                   PIC 9(3)V99.

PROCEDURE DIVISION.
    DIVIDE FUNCTION sum-arr(arr-area) BY Arr-Len GIVING avg ROUNDED

    PERFORM VARYING i FROM 1 BY 1 UNTIL i > Arr-Len
        COMPUTE arr (i) = (arr (i) - avg) ** 2
    END-PERFORM

    COMPUTE std-dev = FUNCTION SQRT(FUNCTION sum-arr(arr-area) / Arr-Len)
    DISPLAY std-dev
    .
END PROGRAM std-dev.


IDENTIFICATION DIVISION.
FUNCTION-ID. sum-arr.

DATA DIVISION.
LOCAL-STORAGE SECTION.
01  i                         PIC 99.

LINKAGE SECTION.
78  Arr-Len                   VALUE 8.
01  arr-area.
    03  arr                   PIC 99 OCCURS Arr-Len TIMES.

01  arr-sum                   PIC 99.

PROCEDURE DIVISION USING arr-area RETURNING arr-sum.
    INITIALIZE arr-sum *> Without this, arr-sum is initialised incorrectly.
    PERFORM VARYING i FROM 1 BY 1 UNTIL i > Arr-Len
        ADD arr (i) TO arr-sum
    END-PERFORM
    .
END FUNCTION sum-arr.
