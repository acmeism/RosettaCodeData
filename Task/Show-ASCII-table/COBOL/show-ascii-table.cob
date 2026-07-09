        IDENTIFICATION DIVISION.
        PROGRAM-ID. CHARSET.

        DATA DIVISION.
        WORKING-STORAGE SECTION.
        01  CharCode    PIC 999.
        01  DispCode    PIC Z(4)9.
        01  DispChar    PIC X(3).
        01  Temp        PIC 999.
        01  I           PIC 99.
        01  J           PIC 999.

        PROCEDURE DIVISION.
        Main.

        PERFORM VARYING I FROM 1 BY 1 UNTIL I > 16
            COMPUTE Temp = 31+I
            PERFORM VARYING J FROM Temp BY 16 UNTIL J > 127
                MOVE J TO CharCode
                MOVE J TO DispCode
                DISPLAY DispCode ": " WITH NO ADVANCING
                EVALUATE J
                    WHEN 32
                        DISPLAY "Spc" WITH NO ADVANCING
                    WHEN 127
                        DISPLAY "Del" WITH NO ADVANCING
                    WHEN OTHER
                        ADD 1 TO CharCode
                        MOVE FUNCTION CHAR(CharCode) TO DispChar
                        DISPLAY DispChar WITH NO ADVANCING
                END-EVALUATE
            END-PERFORM
            DISPLAY " "
        END-PERFORM

        STOP RUN
        .
