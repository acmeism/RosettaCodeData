       >>SOURCE FREE
PROGRAM-ID. prepend.

DATA DIVISION.
WORKING-STORAGE SECTION.
01  str                                 PIC X(30) VALUE "world!".

PROCEDURE DIVISION.
    MOVE FUNCTION CONCATENATE("Hello, ", str) TO str
    DISPLAY str
    .
END PROGRAM prepend.
