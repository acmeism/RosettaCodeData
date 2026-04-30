       IDENTIFICATION DIVISION.
       PROGRAM-ID. GRICE.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           SYMBOLIC CHARACTERS FULL-STOP IS 76.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT OUTPUT-FILE ASSIGN TO OUTPUT1.
       DATA DIVISION.
       FILE SECTION.
       FD  OUTPUT-FILE
           RECORDING MODE F
           LABEL RECORDS OMITTED.
       01  OUTPUT-RECORD                     PIC X(80).
       WORKING-STORAGE SECTION.
       01  SUB-X                             PIC S9(4) COMP.
       01  SOURCE-FACSIMILE-AREA.
           02  SOURCE-FACSIMILE-DATA.
               03  FILLER                    PIC X(40) VALUE
               "       IDENTIFICATION DIVISION.         ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "       PROGRAM-ID. GRICE.               ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "       ENVIRONMENT DIVISION.            ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "       CONFIGURATION SECTION.           ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "       SPECIAL-NAMES.                   ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           SYMBOLIC CHARACTERS FULL-STOP".
               03  FILLER                    PIC X(40) VALUE
               " IS 76.                                 ".
               03  FILLER                    PIC X(40) VALUE
               "       INPUT-OUTPUT SECTION.            ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "       FILE-CONTROL.                    ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           SELECT OUTPUT-FILE ASSIGN TO ".
               03  FILLER                    PIC X(40) VALUE
               "OUTPUT1.                                ".
               03  FILLER                    PIC X(40) VALUE
               "       DATA DIVISION.                   ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "       FILE SECTION.                    ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "       FD  OUTPUT-FILE                  ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           RECORDING MODE F             ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           LABEL RECORDS OMITTED.       ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "       01  OUTPUT-RECORD                ".
               03  FILLER                    PIC X(40) VALUE
               "     PIC X(80).                         ".
               03  FILLER                    PIC X(40) VALUE
               "       WORKING-STORAGE SECTION.         ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "       01  SUB-X                        ".
               03  FILLER                    PIC X(40) VALUE
               "     PIC S9(4) COMP.                    ".
               03  FILLER                    PIC X(40) VALUE
               "       01  SOURCE-FACSIMILE-AREA.       ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           02  SOURCE-FACSIMILE-DATA.   ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "               03  FILLER               ".
               03  FILLER                    PIC X(40) VALUE
               "     PIC X(40) VALUE                    ".
               03  FILLER                    PIC X(40) VALUE
               "           02  SOURCE-FACSIMILE-TABLE RE".
               03  FILLER                    PIC X(40) VALUE
               "DEFINES                                 ".
               03  FILLER                    PIC X(40) VALUE
               "                   SOURCE-FACSIMILE-DATA".
               03  FILLER                    PIC X(40) VALUE
               ".                                       ".
               03  FILLER                    PIC X(40) VALUE
               "               03  SOURCE-FACSIMILE OCCU".
               03  FILLER                    PIC X(40) VALUE
               "RS 68.                                  ".
               03  FILLER                    PIC X(40) VALUE
               "                   04  SOURCE-FACSIMILE-".
               03  FILLER                    PIC X(40) VALUE
               "ONE  PIC X(40).                         ".
               03  FILLER                    PIC X(40) VALUE
               "                   04  SOURCE-FACSIMILE-".
               03  FILLER                    PIC X(40) VALUE
               "TWO  PIC X(40).                         ".
               03  FILLER                    PIC X(40) VALUE
               "       01  FILLER-IMAGE.                ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           02  FILLER                   ".
               03  FILLER                    PIC X(40) VALUE
               "     PIC X(15) VALUE SPACES.            ".
               03  FILLER                    PIC X(40) VALUE
               "           02  FILLER                   ".
               03  FILLER                    PIC X(40) VALUE
               "     PIC X     VALUE QUOTE.             ".
               03  FILLER                    PIC X(40) VALUE
               "           02  FILLER-DATA              ".
               03  FILLER                    PIC X(40) VALUE
               "     PIC X(40).                         ".
               03  FILLER                    PIC X(40) VALUE
               "           02  FILLER                   ".
               03  FILLER                    PIC X(40) VALUE
               "     PIC X     VALUE QUOTE.             ".
               03  FILLER                    PIC X(40) VALUE
               "           02  FILLER                   ".
               03  FILLER                    PIC X(40) VALUE
               "     PIC X     VALUE FULL-STOP.         ".
               03  FILLER                    PIC X(40) VALUE
               "           02  FILLER                   ".
               03  FILLER                    PIC X(40) VALUE
               "     PIC X(22) VALUE SPACES.            ".
               03  FILLER                    PIC X(40) VALUE
               "       PROCEDURE DIVISION.              ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "       MAIN-LINE SECTION.               ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "       ML-1.                            ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           OPEN OUTPUT OUTPUT-FILE.     ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           MOVE 1 TO SUB-X.             ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "       ML-2.                            ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           MOVE SOURCE-FACSIMILE (SUB-X)".
               03  FILLER                    PIC X(40) VALUE
               " TO OUTPUT-RECORD.                      ".
               03  FILLER                    PIC X(40) VALUE
               "           WRITE OUTPUT-RECORD.         ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           IF  SUB-X < 19               ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "               ADD 1 TO SUB-X           ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "               GO TO ML-2.              ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           MOVE 1 TO SUB-X.             ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "       ML-3.                            ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           MOVE SOURCE-FACSIMILE (20) TO".
               03  FILLER                    PIC X(40) VALUE
               " OUTPUT-RECORD.                         ".
               03  FILLER                    PIC X(40) VALUE
               "           WRITE OUTPUT-RECORD.         ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           MOVE SOURCE-FACSIMILE-ONE (SU".
               03  FILLER                    PIC X(40) VALUE
               "B-X) TO FILLER-DATA.                    ".
               03  FILLER                    PIC X(40) VALUE
               "           MOVE FILLER-IMAGE TO OUTPUT-R".
               03  FILLER                    PIC X(40) VALUE
               "ECORD.                                  ".
               03  FILLER                    PIC X(40) VALUE
               "           WRITE OUTPUT-RECORD.         ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           MOVE SOURCE-FACSIMILE (20) TO".
               03  FILLER                    PIC X(40) VALUE
               " OUTPUT-RECORD.                         ".
               03  FILLER                    PIC X(40) VALUE
               "           WRITE OUTPUT-RECORD.         ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           MOVE SOURCE-FACSIMILE-TWO (SU".
               03  FILLER                    PIC X(40) VALUE
               "B-X) TO FILLER-DATA.                    ".
               03  FILLER                    PIC X(40) VALUE
               "           MOVE FILLER-IMAGE TO OUTPUT-R".
               03  FILLER                    PIC X(40) VALUE
               "ECORD.                                  ".
               03  FILLER                    PIC X(40) VALUE
               "           WRITE OUTPUT-RECORD.         ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           IF  SUB-X < 68               ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "               ADD 1 TO SUB-X           ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "               GO TO ML-3.              ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           MOVE 21 TO SUB-X.            ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "       ML-4.                            ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           MOVE SOURCE-FACSIMILE (SUB-X)".
               03  FILLER                    PIC X(40) VALUE
               " TO OUTPUT-RECORD.                      ".
               03  FILLER                    PIC X(40) VALUE
               "           WRITE OUTPUT-RECORD.         ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           IF  SUB-X < 68               ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "               ADD 1 TO SUB-X           ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "               GO TO ML-4.              ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "       ML-99.                           ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           CLOSE OUTPUT-FILE.           ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
               03  FILLER                    PIC X(40) VALUE
               "           STOP RUN.                    ".
               03  FILLER                    PIC X(40) VALUE
               "                                        ".
           02  SOURCE-FACSIMILE-TABLE REDEFINES
                   SOURCE-FACSIMILE-DATA.
               03  SOURCE-FACSIMILE OCCURS 68.
                   04  SOURCE-FACSIMILE-ONE  PIC X(40).
                   04  SOURCE-FACSIMILE-TWO  PIC X(40).
       01  FILLER-IMAGE.
           02  FILLER                        PIC X(15) VALUE SPACES.
           02  FILLER                        PIC X     VALUE QUOTE.
           02  FILLER-DATA                   PIC X(40).
           02  FILLER                        PIC X     VALUE QUOTE.
           02  FILLER                        PIC X     VALUE FULL-STOP.
           02  FILLER                        PIC X(22) VALUE SPACES.
       PROCEDURE DIVISION.
       MAIN-LINE SECTION.
       ML-1.
           OPEN OUTPUT OUTPUT-FILE.
           MOVE 1 TO SUB-X.
       ML-2.
           MOVE SOURCE-FACSIMILE (SUB-X) TO OUTPUT-RECORD.
           WRITE OUTPUT-RECORD.
           IF  SUB-X < 19
               ADD 1 TO SUB-X
               GO TO ML-2.
           MOVE 1 TO SUB-X.
       ML-3.
           MOVE SOURCE-FACSIMILE (20) TO OUTPUT-RECORD.
           WRITE OUTPUT-RECORD.
           MOVE SOURCE-FACSIMILE-ONE (SUB-X) TO FILLER-DATA.
           MOVE FILLER-IMAGE TO OUTPUT-RECORD.
           WRITE OUTPUT-RECORD.
           MOVE SOURCE-FACSIMILE (20) TO OUTPUT-RECORD.
           WRITE OUTPUT-RECORD.
           MOVE SOURCE-FACSIMILE-TWO (SUB-X) TO FILLER-DATA.
           MOVE FILLER-IMAGE TO OUTPUT-RECORD.
           WRITE OUTPUT-RECORD.
           IF  SUB-X < 68
               ADD 1 TO SUB-X
               GO TO ML-3.
           MOVE 21 TO SUB-X.
       ML-4.
           MOVE SOURCE-FACSIMILE (SUB-X) TO OUTPUT-RECORD.
           WRITE OUTPUT-RECORD.
           IF  SUB-X < 68
               ADD 1 TO SUB-X
               GO TO ML-4.
       ML-99.
           CLOSE OUTPUT-FILE.
           STOP RUN.
