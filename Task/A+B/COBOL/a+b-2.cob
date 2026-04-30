       IDENTIFICATION DIVISION.
       PROGRAM-ID. A-Plus-B.
       AUTHOR.  Bill Gunshannon.
       INSTALLATION.  Home.
       DATE-WRITTEN.  25 December 2021.
      ************************************************************
      ** Program Abstract:
      **   A re-worked version that more closely matches the
      **     desired format. Both numbers are taken in on one
      **     line separated by spaces. Sum is formated to remove
      **     leading zeros and/or spaces.
      ************************************************************


       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  Input-Data   PIC X(16).
       01  A            PIC S9(5).
       01  B            PIC S9(5).

       01  A-B-Sum PIC -----9.

       PROCEDURE DIVISION.
           DISPLAY "Input pairs of numbers separated by spaces."
           DISPLAY "Enter q to exit."
           PERFORM WITH TEST BEFORE
                   UNTIL Input-Data = "q" or Input-Data = "Q"
           ACCEPT Input-Data
                IF Input-Data NOT = "q" and Input-Data NOT = "Q"
                  UNSTRING Input-Data DELIMITED BY SPACES
                        INTO A B
                  ADD A TO B GIVING A-B-Sum

                  DISPLAY "Sum = " FUNCTION TRIM(A-B-Sum)
                END-IF
           END-PERFORM.

           STOP RUN.
