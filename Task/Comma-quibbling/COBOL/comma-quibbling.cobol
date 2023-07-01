       >>SOURCE FORMAT IS FREE
IDENTIFICATION DIVISION.
PROGRAM-ID. comma-quibbling-test.

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
REPOSITORY.
    FUNCTION comma-quibbling
    .
DATA DIVISION.
WORKING-STORAGE SECTION.
01  strs-area.
    03  strs-len                  PIC 9.
    03  strs                      PIC X(5)
                                  OCCURS 0 TO 9 TIMES
                                  DEPENDING ON strs-len.

PROCEDURE DIVISION.
    MOVE "ABC" TO strs (1)
    MOVE "DEF" TO strs (2)
    MOVE "G" TO strs (3)
    MOVE "H" TO strs (4)

    PERFORM VARYING strs-len FROM 0 BY 1 UNTIL strs-len > 4
        DISPLAY FUNCTION comma-quibbling(strs-area)
    END-PERFORM
    .
END PROGRAM comma-quibbling-test.


IDENTIFICATION DIVISION.
FUNCTION-ID. comma-quibbling.

DATA DIVISION.
LOCAL-STORAGE SECTION.
01  i                             PIC 9.

01  num-extra-words               PIC 9.

LINKAGE SECTION.
01  strs-area.
    03  strs-len                  PIC 9.
    03  strs                      PIC X(5)
                                  OCCURS 0 TO 9 TIMES
                                  DEPENDING ON strs-len.

01  str                           PIC X(50).

PROCEDURE DIVISION USING strs-area RETURNING str.
    EVALUATE strs-len
        WHEN ZERO
            MOVE "{}" TO str
            GOBACK

        WHEN 1
            MOVE FUNCTION CONCATENATE("{", FUNCTION TRIM(strs (1)), "}")
                TO str
            GOBACK
    END-EVALUATE

    MOVE FUNCTION CONCATENATE(FUNCTION TRIM(strs (strs-len - 1)),
        " and ", FUNCTION TRIM(strs (strs-len)), "}")
        TO str

    IF strs-len > 2
        SUBTRACT 2 FROM strs-len GIVING num-extra-words
        PERFORM VARYING i FROM num-extra-words BY -1 UNTIL i = 0
            MOVE FUNCTION CONCATENATE(FUNCTION TRIM(strs (i)), ", ", str)
                TO str
        END-PERFORM
    END-IF

    MOVE FUNCTION CONCATENATE("{", str) TO str
    .
END FUNCTION comma-quibbling.
