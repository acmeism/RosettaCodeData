01  normal-date.
    03  year     PIC 9(4).
    03  FILLER   PIC X VALUE "-".
    03  month    PIC 99.
    03  FILLER   PIC X VALUE "-".
    03  dday     PIC 99. *> Misspelling is intentional; day is a reserved word.

01  reversed-date.
    03  dday     PIC 99.
    03  FILLER   PIC X VALUE "-".
    03  month    PIC 99.
    03  FILLER   PIC X VALUE "-".
    03  year     PIC 9(4).
...
PROCEDURE DIVISION.
    MOVE "2012-11-10" TO normal-date
    MOVE CORR normal-date TO reversed-date
    DISPLAY reversed-date *> Shows '10-11-2012'
