      *******************************************************
       IDENTIFICATION DIVISION.
      *******************************************************
       PROGRAM-ID.      SHELLSRT.
      ************************************************************
      *** SHELLSORT                                           ****
      ************************************************************
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 II                        PIC S9(008) COMP-5.
       01 IJ                        PIC S9(008) COMP-5.
       01 IZ                        PIC S9(008) COMP-5.
       01 IA                        PIC S9(008) COMP-5.
       01 STRT1                     PIC S9(008) COMP-5.
       01 STRT2                     PIC S9(008) COMP-5.
       01 LGT                       PIC S9(008) COMP-5.
       01 ORG                       PIC S9(008) COMP-5.
       01 DST                       PIC S9(008) COMP-5.
      *
       01 GAP                       PIC S9(008) COMP-5.
       01 NEGAP                     PIC S9(008) COMP-5.
       01 TEMP                      PIC X(32768).
       77 KEY-RESULT                PIC X.
      *
       LINKAGE SECTION.
       01 SRT-ARRAY                 PIC  X(1000000).
       01 NUM-ITEM                  PIC  9(008) COMP-5.
       01 SRT-DATA.
          03 LGT-ITEM               PIC  9(004) COMP-5.
          03 SRT-KEYS.
             05 SRT-KEY OCCURS 10.
                07 K-START         PIC S9(004) COMP-5.
                07 K-LENGTH        PIC S9(004) COMP-5.
                07 K-ASC           PIC X.
      *
      *    P R O C E D U R E      D I V I S I O N
      *
       PROCEDURE DIVISION USING SRT-ARRAY NUM-ITEM SRT-DATA.

           COMPUTE GAP = NUM-ITEM / 2.
           PERFORM UNTIL GAP < 1
              COMPUTE NEGAP = GAP * -1
              PERFORM VARYING II FROM GAP BY 1
                        UNTIL II GREATER  NUM-ITEM
                 MOVE ' ' TO KEY-RESULT
                 COMPUTE ORG = (II - 1) * LGT-ITEM + 1
                 MOVE SRT-ARRAY(ORG:LGT-ITEM) TO TEMP(1:LGT-ITEM)
                 PERFORM VARYING IJ FROM II BY NEGAP
                           UNTIL IJ NOT GREATER  GAP
                              OR (KEY-RESULT NOT EQUAL '<' AND ' ')
                    COMPUTE IA = IJ - GAP
                    IF IA < 1
                       MOVE 1 TO IA
                    END-IF
                    PERFORM COMPARE-KEYS
                    IF KEY-RESULT = '<'
                       COMPUTE ORG = (IA - 1) * LGT-ITEM + 1
                       COMPUTE DST = (IJ - 1) * LGT-ITEM + 1
                       MOVE SRT-ARRAY(ORG:LGT-ITEM)
                         TO SRT-ARRAY(DST:LGT-ITEM)
                       COMPUTE DST = (IA - 1) * LGT-ITEM + 1
                       MOVE TEMP(1:LGT-ITEM) TO SRT-ARRAY(DST:LGT-ITEM)
                    END-IF
                 END-PERFORM
              END-PERFORM
              IF GAP = 2
                 MOVE 1 TO GAP
              ELSE
                 COMPUTE GAP = GAP / 2.2
              END-IF
           END-PERFORM.
           GOBACK.
      *
       COMPARE-KEYS.
           MOVE ' ' TO KEY-RESULT
           PERFORM VARYING IZ FROM 1 BY 1
                     UNTIL IZ GREATER 10
                        OR (KEY-RESULT NOT EQUAL '=' AND ' ')
              IF SRT-KEY(IZ) GREATER LOW-VALUES
                 COMPUTE STRT1 = (IJ - 1) * LGT-ITEM + K-START(IZ)
                 COMPUTE STRT2 = (IA - 1) * LGT-ITEM + K-START(IZ)
                 MOVE K-LENGTH(IZ) TO LGT
                 IF SRT-ARRAY(STRT1:LGT) > SRT-ARRAY(STRT2:LGT) AND
                    K-ASC(IZ) EQUAL 'A'
                 OR SRT-ARRAY(STRT1:LGT) < SRT-ARRAY(STRT2:LGT) AND
                    K-ASC(IZ) EQUAL 'D'
                    MOVE '>' TO KEY-RESULT
                 END-IF
                 IF SRT-ARRAY(STRT1:LGT) < SRT-ARRAY(STRT2:LGT) AND
                    K-ASC(IZ) EQUAL 'A'
                 OR SRT-ARRAY(STRT1:LGT) > SRT-ARRAY(STRT2:LGT) AND
                    K-ASC(IZ) EQUAL 'D'
                    MOVE '<' TO KEY-RESULT
                 END-IF
              END-IF
           END-PERFORM.
           IF KEY-RESULT = ' '
              MOVE '=' TO KEY-RESULT
           END-IF.
