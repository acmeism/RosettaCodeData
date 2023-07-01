       IDENTIFICATION DIVISION.
       PROGRAM-ID. Letter-Frequency.
       AUTHOR.  Bill Gunshannon.
       INSTALLATION.  Home.
       DATE-WRITTEN.  12 December 2021.
      ************************************************************
      ** Program Abstract:
      **   A rather simplistic program to do the kind of thing
      **   that COBOL does really well.
      ************************************************************

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
            SELECT Text-File ASSIGN TO "File.txt"
                 ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.

       FD  Text-File
           DATA RECORD IS Record-Name.
       01  Record-Name           PIC X(80).


       WORKING-STORAGE SECTION.

       01 Eof                   PIC X     VALUE 'F'.

       01  Letter-cnt.
           05  A-cnt            PIC 9(5)    VALUE 0.
           05  B-cnt            PIC 9(5)    VALUE 0.
           05  C-cnt            PIC 9(5)    VALUE 0.
           05  D-cnt            PIC 9(5)    VALUE 0.
           05  E-cnt            PIC 9(5)    VALUE 0.
           05  F-cnt            PIC 9(5)    VALUE 0.
           05  G-cnt            PIC 9(5)    VALUE 0.
           05  H-cnt            PIC 9(5)    VALUE 0.
           05  I-cnt            PIC 9(5)    VALUE 0.
           05  J-cnt            PIC 9(5)    VALUE 0.
           05  K-cnt            PIC 9(5)    VALUE 0.
           05  L-cnt            PIC 9(5)    VALUE 0.
           05  M-cnt            PIC 9(5)    VALUE 0.
           05  N-cnt            PIC 9(5)    VALUE 0.
           05  O-cnt            PIC 9(5)    VALUE 0.
           05  P-cnt            PIC 9(5)    VALUE 0.
           05  Q-cnt            PIC 9(5)    VALUE 0.
           05  R-cnt            PIC 9(5)    VALUE 0.
           05  S-cnt            PIC 9(5)    VALUE 0.
           05  T-cnt            PIC 9(5)    VALUE 0.
           05  U-cnt            PIC 9(5)    VALUE 0.
           05  V-cnt            PIC 9(5)    VALUE 0.
           05  W-cnt            PIC 9(5)    VALUE 0.
           05  X-cnt            PIC 9(5)    VALUE 0.
           05  Y-cnt            PIC 9(5)    VALUE 0.
           05  Z-cnt            PIC 9(5)    VALUE 0.

       01  Letter-disp.
           05  A-cnt            PIC ZZZZ9.
           05  B-cnt            PIC ZZZZ9.
           05  C-cnt            PIC ZZZZ9.
           05  D-cnt            PIC ZZZZ9.
           05  E-cnt            PIC ZZZZ9.
           05  F-cnt            PIC ZZZZ9.
           05  G-cnt            PIC ZZZZ9.
           05  H-cnt            PIC ZZZZ9.
           05  I-cnt            PIC ZZZZ9.
           05  J-cnt            PIC ZZZZ9.
           05  K-cnt            PIC ZZZZ9.
           05  L-cnt            PIC ZZZZ9.
           05  M-cnt            PIC ZZZZ9.
           05  N-cnt            PIC ZZZZ9.
           05  O-cnt            PIC ZZZZ9.
           05  P-cnt            PIC ZZZZ9.
           05  Q-cnt            PIC ZZZZ9.
           05  R-cnt            PIC ZZZZ9.
           05  S-cnt            PIC ZZZZ9.
           05  T-cnt            PIC ZZZZ9.
           05  U-cnt            PIC ZZZZ9.
           05  V-cnt            PIC ZZZZ9.
           05  W-cnt            PIC ZZZZ9.
           05  X-cnt            PIC ZZZZ9.
           05  Y-cnt            PIC ZZZZ9.
           05  Z-cnt            PIC ZZZZ9.

       PROCEDURE DIVISION.

       Main-Program.
           OPEN INPUT  Text-File
           PERFORM UNTIL Eof = 'T'
              READ  Text-File
                    AT END MOVE 'T' to Eof
              END-READ
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING A-cnt OF Letter-cnt  FOR ALL 'A'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING B-cnt OF Letter-cnt  FOR ALL 'B'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING C-cnt OF Letter-cnt  FOR ALL 'C'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING D-cnt OF Letter-cnt  FOR ALL 'D'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING E-cnt OF Letter-cnt  FOR ALL 'E'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING F-cnt OF Letter-cnt  FOR ALL 'F'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING G-cnt OF Letter-cnt  FOR ALL 'G'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING H-cnt OF Letter-cnt  FOR ALL 'H'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING I-cnt OF Letter-cnt  FOR ALL 'I'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING J-cnt OF Letter-cnt  FOR ALL 'J'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING K-cnt OF Letter-cnt  FOR ALL 'K'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING L-cnt OF Letter-cnt  FOR ALL 'L'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING M-cnt OF Letter-cnt  FOR ALL 'M'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING N-cnt OF Letter-cnt  FOR ALL 'N'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING O-cnt OF Letter-cnt  FOR ALL 'O'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING P-cnt OF Letter-cnt  FOR ALL 'P'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING Q-cnt OF Letter-cnt  FOR ALL 'Q'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING R-cnt OF Letter-cnt  FOR ALL 'R'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING S-cnt OF Letter-cnt  FOR ALL 'S'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING T-cnt OF Letter-cnt  FOR ALL 'T'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING U-cnt OF Letter-cnt  FOR ALL 'U'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING V-cnt OF Letter-cnt  FOR ALL 'V'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING W-cnt OF Letter-cnt  FOR ALL 'W'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING X-cnt OF Letter-cnt  FOR ALL 'X'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING Y-cnt OF Letter-cnt  FOR ALL 'Y'
           INSPECT FUNCTION UPPER-CASE(Record-Name)
                   TALLYING Z-cnt OF Letter-cnt  FOR ALL 'Z'
           END-PERFORM.
           CLOSE Text-File.
           MOVE CORRESPONDING Letter-cnt To Letter-disp.
           DISPLAY 'Letter Frequency Distribution'.
           DISPLAY '-----------------------------'.
           DISPLAY 'A : ' A-cnt OF Letter-disp '          '
                   'N : ' N-cnt OF Letter-disp.
           DISPLAY 'B : ' B-cnt OF Letter-disp '          '
                   'O : ' O-cnt OF Letter-disp.
           DISPLAY 'C : ' C-cnt OF Letter-disp '          '
                   'P : ' P-cnt OF Letter-disp.
           DISPLAY 'D : ' D-cnt OF Letter-disp '          '
                   'Q : ' Q-cnt OF Letter-disp.
           DISPLAY 'E : ' E-cnt OF Letter-disp '          '
                   'R : ' R-cnt OF Letter-disp.
           DISPLAY 'F : ' F-cnt OF Letter-disp '          '
                   'S : ' S-cnt OF Letter-disp.
           DISPLAY 'G : ' G-cnt OF Letter-disp '          '
                   'T : ' T-cnt OF Letter-disp.
           DISPLAY 'H : ' H-cnt OF Letter-disp '          '
                   'U : ' U-cnt OF Letter-disp.
           DISPLAY 'I : ' I-cnt OF Letter-disp '          '
                   'V : ' V-cnt OF Letter-disp.
           DISPLAY 'J : ' J-cnt OF Letter-disp '          '
                   'W : ' W-cnt OF Letter-disp.
           DISPLAY 'K : ' K-cnt OF Letter-disp '          '
                   'X : ' X-cnt OF Letter-disp.
           DISPLAY 'L : ' L-cnt OF Letter-disp '          '
                   'Y : ' Y-cnt OF Letter-disp.
           DISPLAY 'M : ' M-cnt OF Letter-disp '          '
                   'Z : ' Z-cnt OF Letter-disp.
           STOP RUN.


       END-PROGRAM.
