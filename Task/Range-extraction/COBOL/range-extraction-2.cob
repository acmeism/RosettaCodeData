       01  nums-table.
           03  num-nums            PIC 999.
           03  nums-area.
               05  nums            PIC S999 OCCURS 1 TO 100 TIMES
                                   DEPENDING ON num-nums
                                   INDEXED BY nums-idx.
