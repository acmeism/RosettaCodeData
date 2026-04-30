       IDENTIFICATION DIVISION.
       PROGRAM-ID. euler.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77 epsilon USAGE FLOAT-LONG VALUE IS 1.0E-15.
       77 fact USAGE IS BINARY-DOUBLE UNSIGNED VALUE IS 1.
       77 n    USAGE IS BINARY-LONG UNSIGNED.
       77 e    USAGE IS FLOAT-LONG VALUE IS 2.0.
       77 e0   USAGE IS FLOAT-LONG VALUE IS 0.0.
       01 result-message.
          03 FILLER PICTURE IS X(4) VALUE IS 'e = '.
          03 result-value PICTURE IS 9.9(18) USAGE IS DISPLAY.
       PROCEDURE DIVISION.
           PERFORM WITH TEST BEFORE VARYING n FROM 2 BY 1
           UNTIL FUNCTION ABS(e - e0) IS LESS THAN epsilon
              MOVE e TO e0
              MULTIPLY n BY fact
              COMPUTE e = e + 1.0 / fact
           END-PERFORM.
           MOVE e TO result-value.
           DISPLAY result-message.
           STOP RUN.
       END PROGRAM euler.
