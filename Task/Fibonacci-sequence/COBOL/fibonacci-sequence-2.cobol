       >>SOURCE FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. fibonacci-main.

DATA DIVISION.
WORKING-STORAGE SECTION.
01  num                                 PIC 9(6) COMP.
01  fib-num                             PIC 9(6) COMP.

PROCEDURE DIVISION.
    ACCEPT num
    CALL "fibonacci" USING CONTENT num RETURNING fib-num
    DISPLAY fib-num
    .
END PROGRAM fibonacci-main.

IDENTIFICATION DIVISION.
PROGRAM-ID. fibonacci RECURSIVE.

DATA DIVISION.
LOCAL-STORAGE SECTION.
01  1-before                            PIC 9(6) COMP.
01  2-before                            PIC 9(6) COMP.

LINKAGE SECTION.
01  num                                 PIC 9(6) COMP.

01  fib-num                             PIC 9(6) COMP BASED.

PROCEDURE DIVISION USING num RETURNING fib-num.
    ALLOCATE fib-num
    EVALUATE num
        WHEN 0
            MOVE 0 TO fib-num
        WHEN 1
            MOVE 1 TO fib-num
        WHEN OTHER
            SUBTRACT 1 FROM num
            CALL "fibonacci" USING CONTENT num RETURNING 1-before
            SUBTRACT 1 FROM num
            CALL "fibonacci" USING CONTENT num RETURNING 2-before
            ADD 1-before TO 2-before GIVING fib-num
    END-EVALUATE
    .
END PROGRAM fibonacci.
