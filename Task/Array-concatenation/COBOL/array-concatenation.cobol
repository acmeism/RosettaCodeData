IDENTIFICATION DIVISION.
PROGRAM-ID. array-concat.

DATA DIVISION.
WORKING-STORAGE SECTION.
01  table-one.
    05  int-field PIC 999 OCCURS 0 TO 5 TIMES DEPENDING ON t1.
01  table-two.
    05  int-field PIC 9(4) OCCURS 0 TO 10 TIMES DEPENDING ON t2.
77  tally         USAGE IS INDEX.
77  t1            PIC 99.
77  t2            PIC 99.
77  show          PIC Z(4) USAGE IS DISPLAY.

PROCEDURE DIVISION.
array-concat-main.
    PERFORM initialize-tables
    PERFORM concatenate-tables
    PERFORM display-result
    GOBACK.

initialize-tables.
    MOVE 4 TO t1
    PERFORM VARYING tally FROM 1 BY 1 UNTIL tally > t1
        COMPUTE int-field OF table-one(tally) = tally * 3
    END-PERFORM
    MOVE 3 TO t2
    PERFORM VARYING tally FROM 1 BY 1 UNTIL tally > t2
        COMPUTE int-field OF table-two(tally) = tally * 6
    END-PERFORM.

concatenate-tables.
    PERFORM VARYING tally FROM 1 BY 1 UNTIL tally > t1
        ADD 1 TO t2
        MOVE int-field OF table-one(tally)
          TO int-field OF table-two(t2)
    END-PERFORM.

display-result.
    PERFORM VARYING tally FROM 1 BY 1 UNTIL tally = t2
        MOVE int-field OF table-two(tally) TO show
        DISPLAY FUNCTION TRIM(show) ", " WITH NO ADVANCING
    END-PERFORM
    MOVE int-field OF table-two(tally) TO show
    DISPLAY FUNCTION TRIM(show).

END PROGRAM array-concat.
