       IDENTIFICATION DIVISION.
       PROGRAM-ID. RANDOM.
       AUTHOR.  Bill Gunshannon
       INSTALLATION.  Home.
       DATE-WRITTEN.  14 January 2022.
      ************************************************************
      ** Program Abstract:
      **   Able to get the Mean to be really close to 1.0 but
      **     couldn't get the Standard Deviation any closer than
      **     .3 to .4.
      ************************************************************

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01  Sample-Size          PIC 9(5)         VALUE 1000.
       01  Total                PIC 9(10)V9(5)  VALUE 0.0.
       01  Arith-Mean           PIC 999V999  VALUE 0.0.
       01  Std-Dev              PIC 999V999  VALUE 0.0.
       01  Seed                 PIC 999V999.
       01  TI                   PIC 9(8).

       01  Idx                  PIC 99999     VALUE 0.
       01  Intermediate         PIC 9(10)V9(5)  VALUE 0.0.
       01  Rnd-Work.
           05  Rnd-Tbl
                   OCCURS 1 TO 99999 TIMES DEPENDING ON Sample-Size.
               10  Rnd              PIC 9V9999999  VALUE 0.0.

       PROCEDURE DIVISION.

       Main-Program.
           ACCEPT TI FROM TIME.
           MOVE FUNCTION RANDOM(TI) TO Seed.
           PERFORM WITH TEST AFTER VARYING Idx
                   FROM 1 BY 1
                   UNTIL Idx = Sample-Size
              COMPUTE Intermediate =
                           (FUNCTION RANDOM() * 2.01)
              MOVE Intermediate TO Rnd(Idx)
           END-PERFORM.
           PERFORM WITH TEST AFTER VARYING Idx
                   FROM 1 BY 1
                   UNTIL Idx = Sample-Size
              COMPUTE Total = Total + Rnd(Idx)
           END-PERFORM.


           COMPUTE Arith-Mean = Total / Sample-Size.
           DISPLAY "Mean: " Arith-Mean.


           PERFORM WITH TEST AFTER VARYING Idx
                   FROM 1 BY 1
                   UNTIL Idx = Sample-Size
              COMPUTE Intermediate =
                      Intermediate + (Rnd(Idx) - Arith-Mean) ** 2
           END-PERFORM.
              COMPUTE Std-Dev = Intermediate / Sample-Size.


           DISPLAY "Std-Dev: " Std-Dev.

           STOP RUN.

       END PROGRAM RANDOM.
