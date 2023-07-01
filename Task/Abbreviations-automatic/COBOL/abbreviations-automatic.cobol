            IDENTIFICATION DIVISION.
            PROGRAM-ID. AUTO-ABBREVIATIONS.

            ENVIRONMENT DIVISION.

            INPUT-OUTPUT SECTION.
            FILE-CONTROL.
              SELECT DOW ASSIGN TO "days-of-week.txt"
              ORGANIZATION IS LINE SEQUENTIAL.

            DATA DIVISION.
              FILE SECTION.
              FD DOW.
              01 DOW-FILE PIC X(200).

              WORKING-STORAGE SECTION. *> a.k.a. variables
              01 DOW-LINE PIC X(200).
              01 ENDO PIC 9(1).
              01 ENDO2 PIC 9(1).
              01 CURDAY PIC X(50).
              01 ABPTR PIC 999.
              01 LINE-NUM PIC 9(3) VALUE 1.
              01 CHARAMT PIC 9(3) VALUE 1.
              01 LARGESTCHARAMT PIC 9(3).
              01 DAYNUM PIC 9(3) VALUE 1.
              01 ABRESTART PIC 9(1).
              01 CURABBR PIC X(50).
              01 TMP1 PIC 9(3).
              01 TMP2 PIC 9(3).
              01 TINDEX PIC 9(3) VALUE 1.
              01 ABBRLIST.
                05 ABBRITEM PIC X(50) OCCURS 7 TIMES.


            PROCEDURE DIVISION.
              OPEN INPUT DOW.
                PERFORM UNTIL ENDO = 1
                  READ DOW INTO DOW-LINE
                    AT END MOVE 1 TO ENDO
                    NOT AT END PERFORM
                      *> loop through each line
                      IF DOW-LINE = "" THEN
                        DISPLAY ""
                      ELSE
                        MOVE 0 TO ENDO2
                        MOVE 0 TO CHARAMT

                        PERFORM UNTIL ENDO2 > 0
                          MOVE 1 TO ABPTR
                          MOVE 1 TO DAYNUM
                          MOVE 0 TO ABRESTART

                          ADD 1 TO CHARAMT

                          *> reset the abbreviation table
                          MOVE 1 TO TINDEX
                          PERFORM 7 TIMES
                            MOVE SPACE TO ABBRITEM(TINDEX)
                            ADD 1 TO TINDEX
                          END-PERFORM

                          *> loop through each day
                          PERFORM 7 TIMES
                            UNSTRING DOW-LINE DELIMITED BY SPACE
                              INTO CURDAY
                              WITH POINTER ABPTR
                            END-UNSTRING

                            MOVE 0 TO TMP1
                            MOVE 0 TO TMP2
                            INSPECT CURDAY
                              TALLYING TMP1 FOR ALL CHARACTERS
                            INSPECT CURDAY
                              TALLYING TMP2 FOR ALL SPACE
                            SUBTRACT TMP2 FROM TMP1
                            IF TMP1 > LARGESTCHARAMT THEN
                              MOVE TMP1 TO LARGESTCHARAMT
                            END-IF

                            *> not enough days error
                            IF CURDAY = "" THEN
                              MOVE 3 TO ENDO2
                            END-IF

                            MOVE CURDAY(1:CHARAMT) TO CURABBR

                            *> check if the current abbreviation is already taken
                            MOVE 1 TO TINDEX
                            PERFORM 7 TIMES
                              IF ABBRITEM(TINDEX) = CURABBR THEN
                                MOVE 1 TO ABRESTART
                              END-IF
                              ADD 1 TO TINDEX
                            END-PERFORM

                            MOVE CURABBR TO ABBRITEM(DAYNUM)

                            ADD 1 TO DAYNUM

                          END-PERFORM

                          IF ABRESTART = 0 THEN
                            MOVE 1 TO ENDO2
                          END-IF

                          *> identical days error
                          IF CHARAMT > LARGESTCHARAMT THEN
                            MOVE 2 TO ENDO2
                          END-IF

                        END-PERFORM

                        DISPLAY "Line " LINE-NUM ": " WITH NO ADVANCING

                        IF ENDO2 = 3 THEN
                          DISPLAY "Error: not enough " WITH NO ADVANCING
                          DISPLAY "days"
                        ELSE IF ENDO2 = 2 THEN
                          DISPLAY "Error: identical " WITH NO ADVANCING
                          DISPLAY "days"
                        ELSE
                          DISPLAY CHARAMT ": " WITH NO ADVANCING

                          *> loop through each day and display its abbreviation
                          MOVE 1 TO TINDEX
                          PERFORM 7 TIMES
                            MOVE ABBRITEM(TINDEX) TO CURABBR

                            MOVE 0 TO TMP1
                            MOVE 0 TO TMP2
                            INSPECT CURABBR
                              TALLYING TMP1 FOR ALL CHARACTERS
                            INSPECT CURABBR
                              TALLYING TMP2 FOR TRAILING SPACES
                            SUBTRACT TMP2 FROM TMP1

                            DISPLAY CURABBR(1:TMP1) WITH NO ADVANCING
                            DISPLAY "." WITH NO ADVANCING

                            IF TINDEX < 7 THEN
                              DISPLAY SPACE WITH NO ADVANCING
                            ELSE
                              DISPLAY X"0a" WITH NO ADVANCING *> go to next line
                            END-IF

                            ADD 1 TO TINDEX
                          END-PERFORM
                        END-IF

                      END-IF

                    END-PERFORM
                  END-READ

                  ADD 1 TO LINE-NUM
                END-PERFORM.
              CLOSE DOW.
              STOP RUN.
