       IDENTIFICATION DIVISION.
       PROGRAM-ID. ITERATIVE-TOWERS-OF-HANOI.
       AUTHOR. SOREN ROUG.
       DATE-WRITTEN. 2019-06-28.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. LINUX.
       OBJECT-COMPUTER. KAYPRO4.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  NUM-DISKS                   PIC 9 VALUE 4.
       77  N1                          PIC 9 COMP.
       77  N2                          PIC 9 COMP.
       77  FROM-POLE                   PIC 9 COMP.
       77  TO-POLE                     PIC 9 COMP.
       77  VIA-POLE                    PIC 9 COMP.
       77  FP-TMP                      PIC 9 COMP.
       77  TO-TMP                      PIC 9 COMP.
       77  P-TMP                       PIC 9 COMP.
       77  TMP-P                       PIC 9 COMP.
       77  I                           PIC 9 COMP.
       77  DIV                         PIC 9 COMP.
       01  STACKNUMS.
           05  NUMSET OCCURS 3 TIMES.
               10  DNUM                PIC 9 COMP.
       01  GAMESET.
           05  POLES OCCURS 3 TIMES.
               10  STACK OCCURS 10 TIMES.
                   15  POLE            PIC 9 USAGE COMP.

       PROCEDURE DIVISION.
       HANOI.
           DISPLAY "TOWERS OF HANOI PUZZLE WITH ", NUM-DISKS, " DISKS.".
           ADD NUM-DISKS, 1 GIVING N1.
           ADD NUM-DISKS, 2 GIVING N2.
           MOVE 1 TO DNUM (1).
           MOVE N1 TO DNUM (2), DNUM (3).
           MOVE N1 TO POLE (1, N1), POLE (2, N1), POLE (3, N1).
           MOVE 1 TO POLE (1, N2).
           MOVE 2 TO POLE (2, N2).
           MOVE 3 TO POLE (3, N2).
           MOVE 1 TO I.
           PERFORM INIT-PUZZLE UNTIL I = N1.
           MOVE 1 TO FROM-POLE.
           DIVIDE 2 INTO NUM-DISKS GIVING DIV.
           MULTIPLY 2 BY DIV.
           IF DIV NOT = NUM-DISKS PERFORM INITODD ELSE PERFORM INITEVEN.
           PERFORM MOVE-DISK UNTIL DNUM (3) NOT > 1.
           DISPLAY "TOWERS OF HANOI PUZZLE COMPLETED!".
           STOP RUN.
       INIT-PUZZLE.
           MOVE I TO POLE (1, I).
           MOVE 0 TO POLE (2, I), POLE (3, I).
           ADD 1 TO I.
       INITEVEN.
           MOVE 2 TO TO-POLE.
           MOVE 3 TO VIA-POLE.
       INITODD.
           MOVE 3 TO TO-POLE.
           MOVE 2 TO VIA-POLE.
       MOVE-DISK.
           MOVE DNUM (FROM-POLE) TO FP-TMP.
           MOVE POLE (FROM-POLE, FP-TMP) TO I.
           DISPLAY "MOVE DISK FROM ", POLE (FROM-POLE, N2),
               " TO ", POLE (TO-POLE, N2).
           ADD 1 TO DNUM (FROM-POLE).
           MOVE VIA-POLE TO TMP-P.
           SUBTRACT 1 FROM DNUM (TO-POLE).
           MOVE DNUM (TO-POLE) TO TO-TMP.
           MOVE I TO POLE (TO-POLE, TO-TMP).
           DIVIDE 2 INTO I GIVING DIV.
           MULTIPLY 2 BY DIV.
           IF I NOT = DIV PERFORM MOVE-TO-VIA ELSE
               PERFORM MOVE-FROM-VIA.
       MOVE-TO-VIA.
           MOVE TO-POLE TO VIA-POLE.
           MOVE DNUM (FROM-POLE) TO FP-TMP.
           MOVE DNUM (TMP-P) TO P-TMP.
           IF POLE (FROM-POLE, FP-TMP) > POLE (TMP-P, P-TMP)
               PERFORM MOVE-FROM-TO
           ELSE MOVE TMP-P TO TO-POLE.
       MOVE-FROM-TO.
           MOVE FROM-POLE TO TO-POLE.
           MOVE TMP-P TO FROM-POLE.
           MOVE DNUM (FROM-POLE) TO FP-TMP.
           MOVE DNUM (TMP-P) TO P-TMP.
       MOVE-FROM-VIA.
           MOVE FROM-POLE TO VIA-POLE.
           MOVE TMP-P TO FROM-POLE.
