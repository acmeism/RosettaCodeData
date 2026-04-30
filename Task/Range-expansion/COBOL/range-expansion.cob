       >>SOURCE FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. expand-range.

DATA DIVISION.
WORKING-STORAGE SECTION.
01  comma-pos                           PIC 99 COMP VALUE 1.
01  dash-pos                            PIC 99 COMP.
01  end-num                             PIC S9(3).
01  Max-Part-Len                        CONSTANT 10.
01  num                                 PIC S9(3).
01  edited-num                          PIC -(3)9.
01  part                                PIC X(10).

01  part-flag                           PIC X.
    88 last-part                        VALUE "Y".

01  range-str                           PIC X(80).
01  Range-Str-Len                       CONSTANT 80.
01  start-pos                           PIC 99 COMP.
01  start-num                           PIC S9(3).

PROCEDURE DIVISION.
    ACCEPT range-str

    PERFORM WITH TEST AFTER UNTIL last-part
        UNSTRING range-str DELIMITED BY "," INTO part WITH POINTER comma-pos
        PERFORM check-if-last

        PERFORM find-range-dash

        IF dash-pos > Max-Part-Len
            PERFORM display-num
        ELSE
            PERFORM display-range
        END-IF
    END-PERFORM

    DISPLAY SPACES

    GOBACK
    .
check-if-last SECTION.
    IF comma-pos > Range-Str-Len
        SET last-part TO TRUE
    END-IF
    .
find-range-dash SECTION.
    IF part (1:1) <> "-"
        MOVE 1 TO start-pos
    ELSE
        MOVE 2 TO start-pos
    END-IF

    MOVE 1 TO dash-pos
    INSPECT part (start-pos:) TALLYING dash-pos FOR CHARACTERS BEFORE "-"
    COMPUTE dash-pos = dash-pos + start-pos - 1
    .
display-num SECTION.
    MOVE part TO edited-num
    CALL "display-edited-num" USING CONTENT part-flag, edited-num
    .
display-range SECTION.
    MOVE part (1:dash-pos - 1) TO start-num
    MOVE part (dash-pos + 1:) TO end-num

    PERFORM VARYING num FROM start-num BY 1 UNTIL num = end-num
        MOVE num TO edited-num
        CALL "display-edited-num" USING CONTENT "N", edited-num
    END-PERFORM

    MOVE end-num TO edited-num
    CALL "display-edited-num" USING CONTENT part-flag, edited-num
    .
END PROGRAM expand-range.


IDENTIFICATION DIVISION.
PROGRAM-ID. display-edited-num.

DATA DIVISION.
LINKAGE SECTION.
01  hide-comma-flag                     PIC X.
    88  hide-comma                      VALUE "Y".
01  edited-num                          PIC -(3)9.

PROCEDURE DIVISION USING hide-comma-flag, edited-num.
    DISPLAY FUNCTION TRIM(edited-num) NO ADVANCING
    IF NOT hide-comma
        DISPLAY ", " NO ADVANCING
    END-IF
    .
END PROGRAM display-edited-num.
