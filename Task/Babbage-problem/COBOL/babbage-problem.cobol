IDENTIFICATION DIVISION.
PROGRAM-ID. BABBAGE-PROGRAM.
* A line beginning with an asterisk is an explanatory note.
* The machine will disregard any such line.
DATA DIVISION.
WORKING-STORAGE SECTION.
* In this part of the program we reserve the storage space we shall
* be using for our variables, using a 'PICTURE' clause to specify
* how many digits the machine is to keep free.
* The prefixed number 77 indicates that these variables do not form part
* of any larger 'record' that we might want to deal with as a whole.
77  N           PICTURE 99999.
* We know that 99,736 is a valid answer.
77  N-SQUARED   PICTURE 9999999999.
77  LAST-SIX    PICTURE 999999.
PROCEDURE DIVISION.
* Here we specify the calculations that the machine is to carry out.
CONTROL-PARAGRAPH.
    PERFORM COMPUTATION-PARAGRAPH VARYING N FROM 1 BY 1
    UNTIL LAST-SIX IS EQUAL TO 269696.
    STOP RUN.
COMPUTATION-PARAGRAPH.
    MULTIPLY N BY N GIVING N-SQUARED.
    MOVE N-SQUARED TO LAST-SIX.
* Since the variable LAST-SIX can hold a maximum of six digits,
* only the final six digits of N-SQUARED will be moved into it:
* the rest will not fit and will simply be discarded.
    IF LAST-SIX IS EQUAL TO 269696 THEN DISPLAY N.
