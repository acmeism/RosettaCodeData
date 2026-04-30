      ******************************************************************
      * COBOL solution to Angle difference challange
      * The program was run on OpenCobolIDE
      * I chose to read the input data from a .txt file that I
      *    created on my PC rather than to hard code it into the
      *    program or enter it as the program was executing.
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ANGLE-DIFFERENCE.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT IN-FILE ASSIGN TO 'C:\Both\Rosetta\Angle_diff.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.
       FD IN-FILE.
       01 IN-RECORD.
           05  ALPHA-BEARING-1          PIC X(20).
           05  FILLER                   PIC X.
           05  ALPHA-BEARING-2          PIC X(20).

       WORKING-STORAGE SECTION.
       01  SWITCHES.
           05 EOF-SWITCH                PIC X VALUE 'N'.

       01 COUNTERS.
           05 REC-CTR                   PIC 9(3) VALUE 0.

       01  WS-ALPHA-BEARING.
           05  WS-AB-SIGN               PIC X.
               88  WS-AB-NEGATIVE       VALUE "-".
           05  WS-AB-INTEGER-PART       PIC X(6).
           05  WS-AB-DEC-POINT          PIC X.
           05  WS-AB-DECIMAL-PART       PIC X(12).

       01  WS-BEARING-1                 PIC S9(6)V9(12).
       01  WS-BEARING-2                 PIC S9(6)V9(12).

       01  WS-BEARING                   PIC S9(6)V9(12).
       01  FILLER REDEFINES WS-BEARING.
           05  WSB-INTEGER-PART         PIC X(6).
           05  WSB-DECIMAL-PART         PIC X9(12).

       77  WS-RESULT                    PIC S9(6)V9(12).
       77  WS-RESULT-POS                PIC 9(6)V9(12).
       77  WS-INTEGER-PART              PIC 9(6).
       77  WS-DECIMAL-PART              PIC V9(12).
       77  WS-RESULT-OUT                PIC ------9.9999.

       PROCEDURE DIVISION.
       000-MAIN.
           PERFORM 100-INITIALIZE.
           PERFORM 200-PROCESS-RECORD
               UNTIL EOF-SWITCH = 'Y'.
           PERFORM 300-TERMINATE.
           STOP RUN.

       100-INITIALIZE.
           OPEN INPUT IN-FILE.
           PERFORM 150-READ-RECORD.

       150-READ-RECORD.
           READ IN-FILE
               AT END
                   MOVE 'Y' TO EOF-SWITCH
               NOT AT END
                   COMPUTE REC-CTR = REC-CTR + 1
               END-READ.

       200-PROCESS-RECORD.
           MOVE ALPHA-BEARING-1 TO WS-ALPHA-BEARING.
           PERFORM 250-CONVERT-DATA.
           MOVE WS-BEARING TO WS-BEARING-1.

           MOVE ALPHA-BEARING-2 TO WS-ALPHA-BEARING.
           PERFORM 250-CONVERT-DATA.
           MOVE WS-BEARING TO WS-BEARING-2.

           COMPUTE WS-RESULT = WS-BEARING-2 - WS-BEARING-1.
           MOVE WS-RESULT TO WS-RESULT-POS.
           MOVE WS-RESULT-POS TO WS-INTEGER-PART.
           COMPUTE WS-DECIMAL-PART = WS-RESULT-POS - WS-INTEGER-PART.
           COMPUTE WS-INTEGER-PART = FUNCTION MOD(WS-INTEGER-PART 360).
           IF WS-RESULT > 0
               COMPUTE WS-RESULT = WS-INTEGER-PART + WS-DECIMAL-PART
           ELSE
               COMPUTE WS-RESULT =
                   (WS-INTEGER-PART + WS-DECIMAL-PART) * -1
           END-IF.

           IF WS-RESULT < -180
               COMPUTE WS-RESULT = WS-RESULT + 360.
           IF WS-RESULT > 180
               COMPUTE WS-RESULT = WS-RESULT - 360.
           COMPUTE WS-RESULT-OUT ROUNDED = WS-RESULT.

           DISPLAY REC-CTR ' ' WS-RESULT-OUT.

           PERFORM 150-READ-RECORD.

       250-CONVERT-DATA.
           MOVE WS-AB-INTEGER-PART      TO WSB-INTEGER-PART.
           MOVE WS-AB-DECIMAL-PART      TO WSB-DECIMAL-PART.
           IF WS-AB-NEGATIVE
               SUBTRACT WS-BEARING      FROM ZERO
                 GIVING                 WS-BEARING
           END-IF.

       300-TERMINATE.
           DISPLAY 'RECORDS PROCESSED: ' REC-CTR.
           CLOSE IN-FILE.

      ******************************************************************
      *    INPUT FILE ('Angle_diff.txt' stored on my PC at:
      *            'C:\Both\Rosetta\Angle_diff.txt'
      ******************************************************************
      *     +000020.000000000000 +000045.000000000000
      *     -000045.000000000000 +000045.000000000000
      *     -000085.000000000000 +000090.000000000000
      *     -000095.000000000000 +000090.000000000000
      *     -000045.000000000000 +000125.000000000000
      *     -000045.000000000000 +000145.000000000000
      *     +000029.480300000000 -000088.638100000000
      *     -000078.325100000000 -000159.036000000000
      *     -070099.742338109380 +029840.674378767230
      *     -165313.666629735700 +033693.989451745600
      *     +001174.838051059846 -154146.664901247570
      *     +060175.773067955460 +042213.071923543730
      ******************************************************************
      *    OUTPUT:
      ******************************************************************
      *     001      25.0000
      *     002      90.0000
      *     003     175.0000
      *     004    -175.0000
      *     005     170.0000
      *     006    -170.0000
      *     007    -118.1184
      *     008     -80.7109
      *     009    -139.5833
      *     010     -72.3439
      *     011    -161.5030
      *     012      37.2989
      ******************************************************************
