DECLARE FUNCTION ack! (m!, n!)

FUNCTION ack (m!, n!)
       IF m = 0 THEN ack = n + 1

       IF m > 0 AND n = 0 THEN
               ack = ack(m - 1, 1)
       END IF
       IF m > 0 AND n > 0 THEN
               ack = ack(m - 1, ack(m, n - 1))
       END IF
END FUNCTION
