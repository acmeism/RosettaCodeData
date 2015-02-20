       >>SOURCE FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. hickerson-series.

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
REPOSITORY.
    FUNCTION ALL INTRINSIC
    .
DATA DIVISION.
WORKING-STORAGE SECTION.
01  n                                   PIC 99 COMP.

01  h                                   PIC Z(19)9.9(10).

01  First-Decimal-Digit-Pos             CONSTANT 22.

PROCEDURE DIVISION.
    PERFORM VARYING n FROM 0 BY 1 UNTIL n > 17
        COMPUTE h = FACTORIAL(n) / (2 * LOG(2) ** (n + 1))
        DISPLAY "h(" n ") = " h " which is " NO ADVANCING
        IF h (First-Decimal-Digit-Pos:1) = "0" OR "9"
            DISPLAY "an almost integer."
        ELSE
            DISPLAY "not an almost integer."
        END-IF
    END-PERFORM
    .
END PROGRAM hickerson-series.
