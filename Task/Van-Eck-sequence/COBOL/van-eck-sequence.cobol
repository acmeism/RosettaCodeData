        IDENTIFICATION DIVISION.
        PROGRAM-ID. VAN-ECK.

        DATA DIVISION.
        WORKING-STORAGE SECTION.
        01 CALCULATION.
            02 ECK      PIC 999 OCCURS 1000 TIMES.
            02 I        PIC 9999.
            02 J        PIC 9999.
        01 OUTPUT-FORMAT.
            02 ITEM     PIC ZZ9.
            02 IDX      PIC ZZZ9.

        PROCEDURE DIVISION.
        B.  PERFORM GENERATE-ECK.
            PERFORM SHOW VARYING I FROM 1 BY 1 UNTIL I = 11.
            PERFORM SHOW VARYING I FROM 991 BY 1 UNTIL I = 1001.
            STOP RUN.

        SHOW.
            MOVE I TO IDX.
            MOVE ECK(I) TO ITEM.
            DISPLAY 'ECK(' IDX ') = ' ITEM.

        GENERATE-ECK SECTION.
        B.  SET ECK(1) TO 0.
            SET I TO 1.
            PERFORM GENERATE-TERM
                VARYING I FROM 2 BY 1 UNTIL I = 1001.

        GENERATE-TERM SECTION.
        B.  SUBTRACT 2 FROM I GIVING J.
        LOOP.
            IF J IS LESS THAN 1 GO TO TERM-IS-NEW.
            IF ECK(J) = ECK(I - 1) GO TO TERM-IS-OLD.
            SUBTRACT 1 FROM J.
            GO TO LOOP.

        TERM-IS-NEW.
            SET ECK(I) TO 0.
            GO TO DONE.

        TERM-IS-OLD.
            COMPUTE ECK(I) = (I - J) - 1.

        DONE. EXIT.
