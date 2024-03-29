IDENTIFICATION DIVISION.
PROGRAM-ID. INTEGERNESS-PROGRAM.
DATA DIVISION.
WORKING-STORAGE SECTION.
01  INTEGERS-OR-ARE-THEY.
    05 POSSIBLE-INTEGER PIC S9(9)V9(9).
    05 DEFINITE-INTEGER PIC S9(9).
01  COMPLEX-NUMBER.
    05 REAL-PART        PIC S9(9)V9(9).
    05 IMAGINARY-PART   PIC S9(9)V9(9).
PROCEDURE DIVISION.
TEST-PARAGRAPH.
    MOVE ZERO TO IMAGINARY-PART.
    DIVIDE -28 BY 7 GIVING POSSIBLE-INTEGER.
    PERFORM INTEGER-PARAGRAPH.
    DIVIDE 28 BY 18 GIVING POSSIBLE-INTEGER.
    PERFORM INTEGER-PARAGRAPH.
    DIVIDE 3 BY 10000000000 GIVING POSSIBLE-INTEGER.
    PERFORM INTEGER-PARAGRAPH.
TEST-COMPLEX-PARAGRAPH.
    MOVE ZERO TO REAL-PART.
    MOVE 1 TO IMAGINARY-PART.
    MOVE REAL-PART TO POSSIBLE-INTEGER.
    PERFORM INTEGER-PARAGRAPH.
    STOP RUN.
INTEGER-PARAGRAPH.
    IF IMAGINARY-PART IS EQUAL TO ZERO THEN PERFORM REAL-PARAGRAPH,
    ELSE PERFORM COMPLEX-PARAGRAPH.
REAL-PARAGRAPH.
    MOVE POSSIBLE-INTEGER TO DEFINITE-INTEGER.
    IF DEFINITE-INTEGER IS EQUAL TO POSSIBLE-INTEGER
    THEN DISPLAY POSSIBLE-INTEGER ' IS AN INTEGER.',
    ELSE DISPLAY POSSIBLE-INTEGER ' IS NOT AN INTEGER.'.
COMPLEX-PARAGRAPH.
    DISPLAY REAL-PART '+' IMAGINARY-PART 'i IS NOT AN INTEGER.'.
