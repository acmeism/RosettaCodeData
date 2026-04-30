       C-PROCESS SECTION.
       C-000.
           DISPLAY "SORT STARTING".

           DIVIDE WC-SIZE BY 2 GIVING WC-GAP.

           PERFORM E-PROCESS-GAP UNTIL WC-GAP = 0.

           DISPLAY "SORT FINISHED".

       C-999.
           EXIT.


       E-PROCESS-GAP SECTION.
       E-000.
           PERFORM F-SELECTION VARYING WB-IX-1 FROM WC-GAP BY 1
                               UNTIL WB-IX-1 > WC-SIZE.

           DIVIDE WC-GAP BY 2.2 GIVING WC-GAP.

       E-999.
           EXIT.

       F-SELECTION SECTION.
       F-000.
           SET WB-IX-2            TO WB-IX-1.
           MOVE WB-ENTRY(WB-IX-1) TO WC-TEMP.

           SET WB-IX-3 TO WB-IX-2.
           SET WB-IX-3 DOWN BY WC-GAP.
           PERFORM G-PASS UNTIL WB-IX-2 NOT > WC-GAP
      * The next line logically reads :
      *                   or wb-entry(wb-ix-2 - wc-gap) not > wc-temp.
                          OR WB-ENTRY(WB-IX-3) NOT > WC-TEMP.

           IF WB-IX-1 NOT = WB-IX-2
              MOVE WC-TEMP TO WB-ENTRY(WB-IX-2).

       F-999.
           EXIT.

       G-PASS SECTION.
      * Note that WB-IX-3 is WC-GAP less than WB-IX-2.
      * Logically this should be :
      *    move wb-entry(wb-ix-2 - wc-gap) to wb-entry(wb-ix-2).
      *    set wb-ix-2 down by wc-gap.
      * Unfortunately wb-entry(wb-ix-2 - wc-gap) is not legal in C2 cobol
       G-000.
           MOVE WB-ENTRY(WB-IX-3) TO WB-ENTRY(WB-IX-2).
           SET WB-IX-2            DOWN BY WC-GAP.
           SET WB-IX-3            DOWN BY WC-GAP.

       G-999.
           EXIT.
