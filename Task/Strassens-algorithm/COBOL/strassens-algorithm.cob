       IDENTIFICATION DIVISION.
       PROGRAM-ID. StrassenAlgorithm.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 MAT-A. 05 A-DIM PIC 9(4) COMP VALUE 2. 05 A-D OCCURS 16 USAGE COMP-2.
       01 MAT-B. 05 B-DIM PIC 9(4) COMP VALUE 2. 05 B-D OCCURS 16 USAGE COMP-2.
       01 MAT-C. 05 C-DIM PIC 9(4) COMP VALUE 4. 05 C-D OCCURS 16 USAGE COMP-2.
       01 MAT-D. 05 D-DIM PIC 9(4) COMP VALUE 4. 05 D-D OCCURS 16 USAGE COMP-2.
       01 MAT-E. 05 E-DIM PIC 9(4) COMP VALUE 4. 05 E-D OCCURS 16 USAGE COMP-2.
       01 MAT-F. 05 F-DIM PIC 9(4) COMP VALUE 4. 05 F-D OCCURS 16 USAGE COMP-2.
       01 MAT-RES. 05 R-DIM PIC 9(4) COMP. 05 R-D OCCURS 16 USAGE COMP-2.

       01 FMT-NORMAL PIC 9 VALUE 1.
       01 FMT-PREC6 PIC 9 VALUE 6.

       PROCEDURE DIVISION.
           MOVE 1.0 TO A-D(1). MOVE 2.0 TO A-D(2).
           MOVE 3.0 TO A-D(3). MOVE 4.0 TO A-D(4).

           MOVE 5.0 TO B-D(1). MOVE 6.0 TO B-D(2).
           MOVE 7.0 TO B-D(3). MOVE 8.0 TO B-D(4).

           MOVE 1.0 TO C-D(1). MOVE 1.0 TO C-D(2). MOVE 1.0 TO C-D(3). MOVE 1.0 TO C-D(4).
           MOVE 2.0 TO C-D(5). MOVE 4.0 TO C-D(6). MOVE 8.0 TO C-D(7). MOVE 16.0 TO C-D(8).
           MOVE 3.0 TO C-D(9). MOVE 9.0 TO C-D(10). MOVE 27.0 TO C-D(11). MOVE 81.0 TO C-D(12).
           MOVE 4.0 TO C-D(13). MOVE 16.0 TO C-D(14). MOVE 64.0 TO C-D(15). MOVE 256.0 TO C-D(16).

           COMPUTE D-D(1) = 4.0. COMPUTE D-D(2) = -3.0. COMPUTE D-D(3) = 4.0 / 3.0. COMPUTE D-D(4) = -1.0 / 4.0.
           COMPUTE D-D(5) = -13.0 / 3.0. COMPUTE D-D(6) = 19.0 / 4.0. COMPUTE D-D(7) = -7.0 / 3.0. COMPUTE D-D(8) = 11.0 / 24.0.
           COMPUTE D-D(9) = 3.0 / 2.0. COMPUTE D-D(10) = -2.0. COMPUTE D-D(11) = 7.0 / 6.0. COMPUTE D-D(12) = -1.0 / 4.0.
           COMPUTE D-D(13) = -1.0 / 6.0. COMPUTE D-D(14) = 1.0 / 4.0. COMPUTE D-D(15) = -1.0 / 6.0. COMPUTE D-D(16) = 1.0 / 24.0.

           MOVE 1.0 TO E-D(1). MOVE 2.0 TO E-D(2). MOVE 3.0 TO E-D(3). MOVE 4.0 TO E-D(4).
           MOVE 5.0 TO E-D(5). MOVE 6.0 TO E-D(6). MOVE 7.0 TO E-D(7). MOVE 8.0 TO E-D(8).
           MOVE 9.0 TO E-D(9). MOVE 10.0 TO E-D(10). MOVE 11.0 TO E-D(11). MOVE 12.0 TO E-D(12).
           MOVE 13.0 TO E-D(13). MOVE 14.0 TO E-D(14). MOVE 15.0 TO E-D(15). MOVE 16.0 TO E-D(16).

           MOVE 1.0 TO F-D(1). MOVE 0.0 TO F-D(2). MOVE 0.0 TO F-D(3). MOVE 0.0 TO F-D(4).
           MOVE 0.0 TO F-D(5). MOVE 1.0 TO F-D(6). MOVE 0.0 TO F-D(7). MOVE 0.0 TO F-D(8).
           MOVE 0.0 TO F-D(9). MOVE 0.0 TO F-D(10). MOVE 1.0 TO F-D(11). MOVE 0.0 TO F-D(12).
           MOVE 0.0 TO F-D(13). MOVE 0.0 TO F-D(14). MOVE 0.0 TO F-D(15). MOVE 1.0 TO F-D(16).

           DISPLAY "Using 'normal' matrix multiplication:".
           DISPLAY "  a * b = " WITH NO ADVANCING.
           CALL "NORMAL-MULT" USING MAT-A, MAT-B, MAT-RES.
           CALL "PRINT-MATRIX" USING MAT-RES, FMT-NORMAL.

           DISPLAY "  c * d = " WITH NO ADVANCING.
           CALL "NORMAL-MULT" USING MAT-C, MAT-D, MAT-RES.
           CALL "PRINT-MATRIX" USING MAT-RES, FMT-PREC6.

           DISPLAY "  e * f = " WITH NO ADVANCING.
           CALL "NORMAL-MULT" USING MAT-E, MAT-F, MAT-RES.
           CALL "PRINT-MATRIX" USING MAT-RES, FMT-NORMAL.

           DISPLAY "Using 'Strassen' matrix multiplication:".
           DISPLAY "  a * b = " WITH NO ADVANCING.
           CALL "STRASSEN-MULT" USING MAT-A, MAT-B, MAT-RES.
           CALL "PRINT-MATRIX" USING MAT-RES, FMT-NORMAL.

           DISPLAY "  c * d = " WITH NO ADVANCING.
           CALL "STRASSEN-MULT" USING MAT-C, MAT-D, MAT-RES.
           CALL "PRINT-MATRIX" USING MAT-RES, FMT-PREC6.

           DISPLAY "  e * f = " WITH NO ADVANCING.
           CALL "STRASSEN-MULT" USING MAT-E, MAT-F, MAT-RES.
           CALL "PRINT-MATRIX" USING MAT-RES, FMT-NORMAL.

           STOP RUN.
       END PROGRAM StrassenAlgorithm.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. MATRIX-ADD.
       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01 I PIC 9(4) COMP.
       01 TOTAL-CELLS PIC 9(4) COMP.
       LINKAGE SECTION.
       01 L-A.
          05 A-DIM PIC 9(4) COMP.
          05 A-DATA OCCURS 16 TIMES USAGE COMP-2.
       01 L-B.
          05 B-DIM PIC 9(4) COMP.
          05 B-DATA OCCURS 16 TIMES USAGE COMP-2.
       01 L-C.
          05 C-DIM PIC 9(4) COMP.
          05 C-DATA OCCURS 16 TIMES USAGE COMP-2.
       PROCEDURE DIVISION USING L-A, L-B, L-C.
           MOVE A-DIM TO C-DIM
           COMPUTE TOTAL-CELLS = A-DIM * A-DIM
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > TOTAL-CELLS
               COMPUTE C-DATA(I) = A-DATA(I) + B-DATA(I)
           END-PERFORM
           GOBACK.
       END PROGRAM MATRIX-ADD.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. MATRIX-SUB.
       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01 I PIC 9(4) COMP.
       01 TOTAL-CELLS PIC 9(4) COMP.
       LINKAGE SECTION.
       01 L-A.
          05 A-DIM PIC 9(4) COMP.
          05 A-DATA OCCURS 16 TIMES USAGE COMP-2.
       01 L-B.
          05 B-DIM PIC 9(4) COMP.
          05 B-DATA OCCURS 16 TIMES USAGE COMP-2.
       01 L-C.
          05 C-DIM PIC 9(4) COMP.
          05 C-DATA OCCURS 16 TIMES USAGE COMP-2.
       PROCEDURE DIVISION USING L-A, L-B, L-C.
           MOVE A-DIM TO C-DIM
           COMPUTE TOTAL-CELLS = A-DIM * A-DIM
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > TOTAL-CELLS
               COMPUTE C-DATA(I) = A-DATA(I) - B-DATA(I)
           END-PERFORM
           GOBACK.
       END PROGRAM MATRIX-SUB.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. NORMAL-MULT.
       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01 I PIC 9(4) COMP.
       01 J PIC 9(4) COMP.
       01 K PIC 9(4) COMP.
       01 SUM-VAL USAGE COMP-2.
       01 A-IDX PIC 9(4) COMP.
       01 B-IDX PIC 9(4) COMP.
       01 C-IDX PIC 9(4) COMP.
       LINKAGE SECTION.
       01 L-A.
          05 A-DIM PIC 9(4) COMP.
          05 A-DATA OCCURS 16 TIMES USAGE COMP-2.
       01 L-B.
          05 B-DIM PIC 9(4) COMP.
          05 B-DATA OCCURS 16 TIMES USAGE COMP-2.
       01 L-C.
          05 C-DIM PIC 9(4) COMP.
          05 C-DATA OCCURS 16 TIMES USAGE COMP-2.
       PROCEDURE DIVISION USING L-A, L-B, L-C.
           MOVE A-DIM TO C-DIM
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > A-DIM
               PERFORM VARYING J FROM 1 BY 1 UNTIL J > A-DIM
                   COMPUTE C-IDX = (I - 1) * A-DIM + J
                   MOVE 0 TO SUM-VAL
                   PERFORM VARYING K FROM 1 BY 1 UNTIL K > A-DIM
                       COMPUTE A-IDX = (I - 1) * A-DIM + K
                       COMPUTE B-IDX = (K - 1) * A-DIM + J
                       COMPUTE SUM-VAL = SUM-VAL +
                               A-DATA(A-IDX) * B-DATA(B-IDX)
                   END-PERFORM
                   MOVE SUM-VAL TO C-DATA(C-IDX)
               END-PERFORM
           END-PERFORM
           GOBACK.
       END PROGRAM NORMAL-MULT.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRINT-MATRIX.
       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01 I PIC 9(4) COMP.
       01 J PIC 9(4) COMP.
       01 IDX PIC 9(4) COMP.
       01 FMT-VAL-1 PIC -(4)9.9.
       01 ZERO-VAL-1 PIC -(4)9.9 VALUE 0.0.
       01 FMT-VAL-6 PIC -(4)9.9(6).
       01 ZERO-VAL-6 PIC -(4)9.9(6) VALUE 0.000000.
       01 OUT-STR PIC X(80).
       01 PTR PIC 9(4) COMP.
       01 STR-VAL PIC X(20).
       LINKAGE SECTION.
       01 L-M.
          05 M-DIM PIC 9(4) COMP.
          05 M-DATA OCCURS 16 USAGE COMP-2.
       01 L-FMT PIC 9.
       PROCEDURE DIVISION USING L-M, L-FMT.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > M-DIM
               MOVE SPACES TO OUT-STR
               MOVE "[" TO OUT-STR(1:1)
               MOVE 2 TO PTR

               PERFORM VARYING J FROM 1 BY 1 UNTIL J > M-DIM
                   COMPUTE IDX = (I - 1) * M-DIM + J
                   IF L-FMT = 1
                       IF M-DATA(IDX) > -0.05 AND M-DATA(IDX) < 0.05
                           MOVE ZERO-VAL-1 TO FMT-VAL-1
                       ELSE
                           IF M-DATA(IDX) > 0
                               COMPUTE FMT-VAL-1 = M-DATA(IDX) + 0.05
                           ELSE
                               COMPUTE FMT-VAL-1 = M-DATA(IDX) - 0.05
                           END-IF
                       END-IF
                       MOVE FUNCTION TRIM(FMT-VAL-1) TO STR-VAL
                   ELSE
                       IF M-DATA(IDX) > -0.0000005 AND M-DATA(IDX) < 0.0000005
                           MOVE ZERO-VAL-6 TO FMT-VAL-6
                       ELSE
                           IF M-DATA(IDX) > 0
                               COMPUTE FMT-VAL-6 = M-DATA(IDX) + 0.0000005
                           ELSE
                               COMPUTE FMT-VAL-6 = M-DATA(IDX) - 0.0000005
                           END-IF
                       END-IF
                       MOVE FUNCTION TRIM(FMT-VAL-6) TO STR-VAL
                   END-IF

                   STRING FUNCTION TRIM(STR-VAL) DELIMITED BY SIZE
                          INTO OUT-STR WITH POINTER PTR

                   IF J < M-DIM
                       STRING ", " DELIMITED BY SIZE
                              INTO OUT-STR WITH POINTER PTR
                   END-IF
               END-PERFORM

               STRING "]" DELIMITED BY SIZE
                      INTO OUT-STR WITH POINTER PTR
               DISPLAY FUNCTION TRIM(OUT-STR)
           END-PERFORM
           DISPLAY "".
           GOBACK.
       END PROGRAM PRINT-MATRIX.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. STRASSEN-MULT RECURSIVE.
       DATA DIVISION.
       LOCAL-STORAGE SECTION.
       01 HALF PIC 9(4) COMP.
       01 I PIC 9(4) COMP.
       01 J PIC 9(4) COMP.
       01 SRC-IDX PIC 9(4) COMP.
       01 DST-IDX PIC 9(4) COMP.

       01 QA0. 05 DIM0 PIC 9(4) COMP. 05 D0 OCCURS 16 USAGE COMP-2.
       01 QA1. 05 DIM1 PIC 9(4) COMP. 05 D1 OCCURS 16 USAGE COMP-2.
       01 QA2. 05 DIM2 PIC 9(4) COMP. 05 D2 OCCURS 16 USAGE COMP-2.
       01 QA3. 05 DIM3 PIC 9(4) COMP. 05 D3 OCCURS 16 USAGE COMP-2.

       01 QB0. 05 BDIM0 PIC 9(4) COMP. 05 BD0 OCCURS 16 USAGE COMP-2.
       01 QB1. 05 BDIM1 PIC 9(4) COMP. 05 BD1 OCCURS 16 USAGE COMP-2.
       01 QB2. 05 BDIM2 PIC 9(4) COMP. 05 BD2 OCCURS 16 USAGE COMP-2.
       01 QB3. 05 BDIM3 PIC 9(4) COMP. 05 BD3 OCCURS 16 USAGE COMP-2.

       01 P1. 05 P1-DIM PIC 9(4) COMP. 05 P1-D OCCURS 16 USAGE COMP-2.
       01 P2. 05 P2-DIM PIC 9(4) COMP. 05 P2-D OCCURS 16 USAGE COMP-2.
       01 P3. 05 P3-DIM PIC 9(4) COMP. 05 P3-D OCCURS 16 USAGE COMP-2.
       01 P4. 05 P4-DIM PIC 9(4) COMP. 05 P4-D OCCURS 16 USAGE COMP-2.
       01 P5. 05 P5-DIM PIC 9(4) COMP. 05 P5-D OCCURS 16 USAGE COMP-2.
       01 P6. 05 P6-DIM PIC 9(4) COMP. 05 P6-D OCCURS 16 USAGE COMP-2.
       01 P7. 05 P7-DIM PIC 9(4) COMP. 05 P7-D OCCURS 16 USAGE COMP-2.

       01 T1. 05 T1-DIM PIC 9(4) COMP. 05 T1-D OCCURS 16 USAGE COMP-2.
       01 T2. 05 T2-DIM PIC 9(4) COMP. 05 T2-D OCCURS 16 USAGE COMP-2.

       01 Q0. 05 Q0-DIM PIC 9(4) COMP. 05 Q0-D OCCURS 16 USAGE COMP-2.
       01 Q1. 05 Q1-DIM PIC 9(4) COMP. 05 Q1-D OCCURS 16 USAGE COMP-2.
       01 Q2. 05 Q2-DIM PIC 9(4) COMP. 05 Q2-D OCCURS 16 USAGE COMP-2.
       01 Q3. 05 Q3-DIM PIC 9(4) COMP. 05 Q3-D OCCURS 16 USAGE COMP-2.

       LINKAGE SECTION.
       01 L-A. 05 L-A-DIM PIC 9(4) COMP. 05 L-A-D OCCURS 16 USAGE COMP-2.
       01 L-B. 05 L-B-DIM PIC 9(4) COMP. 05 L-B-D OCCURS 16 USAGE COMP-2.
       01 L-C. 05 L-C-DIM PIC 9(4) COMP. 05 L-C-D OCCURS 16 USAGE COMP-2.

       PROCEDURE DIVISION USING L-A, L-B, L-C.
           IF L-A-DIM = 1
               MOVE 1 TO L-C-DIM
               COMPUTE L-C-D(1) = L-A-D(1) * L-B-D(1)
               GOBACK
           END-IF.

           COMPUTE HALF = L-A-DIM / 2.
           MOVE HALF TO DIM0, DIM1, DIM2, DIM3.
           MOVE HALF TO BDIM0, BDIM1, BDIM2, BDIM3.

           PERFORM VARYING I FROM 1 BY 1 UNTIL I > HALF
               PERFORM VARYING J FROM 1 BY 1 UNTIL J > HALF
                   COMPUTE DST-IDX = (I - 1) * HALF + J

                   COMPUTE SRC-IDX = (I - 1) * L-A-DIM + J
                   MOVE L-A-D(SRC-IDX) TO D0(DST-IDX)

                   COMPUTE SRC-IDX = (I - 1) * L-A-DIM + (J + HALF)
                   MOVE L-A-D(SRC-IDX) TO D1(DST-IDX)

                   COMPUTE SRC-IDX = (I + HALF - 1) * L-A-DIM + J
                   MOVE L-A-D(SRC-IDX) TO D2(DST-IDX)

                   COMPUTE SRC-IDX = (I + HALF - 1) * L-A-DIM + (J + HALF)
                   MOVE L-A-D(SRC-IDX) TO D3(DST-IDX)

                   COMPUTE SRC-IDX = (I - 1) * L-B-DIM + J
                   MOVE L-B-D(SRC-IDX) TO BD0(DST-IDX)

                   COMPUTE SRC-IDX = (I - 1) * L-B-DIM + (J + HALF)
                   MOVE L-B-D(SRC-IDX) TO BD1(DST-IDX)

                   COMPUTE SRC-IDX = (I + HALF - 1) * L-B-DIM + J
                   MOVE L-B-D(SRC-IDX) TO BD2(DST-IDX)

                   COMPUTE SRC-IDX = (I + HALF - 1) * L-B-DIM + (J + HALF)
                   MOVE L-B-D(SRC-IDX) TO BD3(DST-IDX)
               END-PERFORM
           END-PERFORM.

           CALL "MATRIX-SUB" USING QA1, QA3, T1
           CALL "MATRIX-ADD" USING QB2, QB3, T2
           CALL "STRASSEN-MULT" USING T1, T2, P1

           CALL "MATRIX-ADD" USING QA0, QA3, T1
           CALL "MATRIX-ADD" USING QB0, QB3, T2
           CALL "STRASSEN-MULT" USING T1, T2, P2

           CALL "MATRIX-SUB" USING QA0, QA2, T1
           CALL "MATRIX-ADD" USING QB0, QB1, T2
           CALL "STRASSEN-MULT" USING T1, T2, P3

           CALL "MATRIX-ADD" USING QA0, QA1, T1
           CALL "STRASSEN-MULT" USING T1, QB3, P4

           CALL "MATRIX-SUB" USING QB1, QB3, T2
           CALL "STRASSEN-MULT" USING QA0, T2, P5

           CALL "MATRIX-SUB" USING QB2, QB0, T2
           CALL "STRASSEN-MULT" USING QA3, T2, P6

           CALL "MATRIX-ADD" USING QA2, QA3, T1
           CALL "STRASSEN-MULT" USING T1, QB0, P7

           CALL "MATRIX-ADD" USING P1, P2, T1
           CALL "MATRIX-SUB" USING T1, P4, T2
           CALL "MATRIX-ADD" USING T2, P6, Q0

           CALL "MATRIX-ADD" USING P4, P5, Q1

           CALL "MATRIX-ADD" USING P6, P7, Q2

           CALL "MATRIX-SUB" USING P2, P3, T1
           CALL "MATRIX-ADD" USING T1, P5, T2
           CALL "MATRIX-SUB" USING T2, P7, Q3

           MOVE L-A-DIM TO L-C-DIM
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > HALF
               PERFORM VARYING J FROM 1 BY 1 UNTIL J > HALF
                   COMPUTE SRC-IDX = (I - 1) * HALF + J

                   COMPUTE DST-IDX = (I - 1) * L-A-DIM + J
                   MOVE Q0-D(SRC-IDX) TO L-C-D(DST-IDX)

                   COMPUTE DST-IDX = (I - 1) * L-A-DIM + (J + HALF)
                   MOVE Q1-D(SRC-IDX) TO L-C-D(DST-IDX)

                   COMPUTE DST-IDX = (I + HALF - 1) * L-A-DIM + J
                   MOVE Q2-D(SRC-IDX) TO L-C-D(DST-IDX)

                   COMPUTE DST-IDX = (I + HALF - 1) * L-A-DIM + (J + HALF)
                   MOVE Q3-D(SRC-IDX) TO L-C-D(DST-IDX)
               END-PERFORM
           END-PERFORM.

           GOBACK.
       END PROGRAM STRASSEN-MULT.
