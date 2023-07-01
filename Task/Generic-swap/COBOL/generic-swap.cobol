       PROGRAM-ID. SWAP-DEMO.
       AUTHOR.  Bill Gunshannon.
       INSTALLATION.  Home.
       DATE-WRITTEN.  16 December 2021.
      ************************************************************
      ** Program Abstract:
      **   A simple program to demonstrate the SWAP subprogram.
      **
      ************************************************************

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01  Val1                 PIC X(72).
       01  Val2                 PIC X(72).

       PROCEDURE DIVISION.

       Main-Program.

          DISPLAY 'Enter a Value: ' WITH NO ADVANCING.
          ACCEPT Val1.
          DISPLAY 'Enter another Value: ' WITH NO ADVANCING.
          ACCEPT Val2.
          DISPLAY ' ' .
          DISPLAY 'First value: ' FUNCTION TRIM(Val1) .
          DISPLAY 'Second value: ' FUNCTION TRIM(Val2) .

           CALL "SWAP" USING BY REFERENCE Val1,  BY REFERENCE Val2.

          DISPLAY ' '.
          DISPLAY 'After SWAP '.
          DISPLAY ' '.
          DISPLAY 'First value: ' FUNCTION TRIM(Val1).
          DISPLAY 'Second value: ' FUNCTION TRIM(Val2).

           STOP RUN.

       END PROGRAM SWAP-DEMO.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. SWAP.
       AUTHOR.  Bill Gunshannon.
       INSTALLATION.  Home.
       DATE-WRITTEN.  16 December 2021.
      ************************************************************
      ** Program Abstract:
      **   SWAP any Alphanumeric value.  Only limit is 72
      **     character size.  But that can be adjusted for
      **     whatever use one needs.
      ************************************************************

       DATA DIVISION.

       WORKING-STORAGE SECTION.

       01  TEMP                  PIC X(72).

       LINKAGE SECTION.

       01  Field1                PIC X(72).
       01  Field2                PIC X(72).

       PROCEDURE DIVISION
               USING BY REFERENCE Field1, BY REFERENCE Field2.

       MOVE Field1 to TEMP.
       MOVE Field2 to Field1.
       MOVE TEMP to Field2.

       GOBACK.

       END PROGRAM SWAP.
