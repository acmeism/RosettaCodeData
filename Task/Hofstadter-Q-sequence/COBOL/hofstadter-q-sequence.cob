        IDENTIFICATION DIVISION.
        PROGRAM-ID. Q-SEQ.

        DATA DIVISION.
        WORKING-STORAGE SECTION.
        01 SEQ.
           02 Q         PIC 9(3) OCCURS 1000 TIMES.
           02 Q-TMP1    PIC 9(3).
           02 Q-TMP2    PIC 9(3).
           02 N         PIC 9(4).
        01 DISPLAYING.
           02 ITEM      PIC Z(3).
           02 IX        PIC Z(4).

        PROCEDURE DIVISION.
        MAIN-PROGRAM.
            PERFORM GENERATE-SEQUENCE.
            PERFORM SHOW-ITEM
                VARYING N FROM 1 BY 1
                UNTIL N IS GREATER THAN 10.
            SET N TO 1000.
            PERFORM SHOW-ITEM.
            STOP RUN.

        GENERATE-SEQUENCE.
            SET Q(1) TO 1.
            SET Q(2) TO 1.
            PERFORM GENERATE-ITEM
                VARYING N FROM 3 BY 1
                UNTIL N IS GREATER THAN 1000.

        GENERATE-ITEM.
            COMPUTE Q-TMP1 = N - Q(N - 1).
            COMPUTE Q-TMP2 = N - Q(N - 2).
            COMPUTE Q(N) = Q(Q-TMP1) + Q(Q-TMP2).

        SHOW-ITEM.
            MOVE N TO IX.
            MOVE Q(N) TO ITEM.
            DISPLAY 'Q(' IX ') = ' ITEM.
