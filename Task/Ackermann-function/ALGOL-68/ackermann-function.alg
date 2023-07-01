PROC test ackermann = VOID:
BEGIN
   PROC ackermann = (INT m, n)INT:
   BEGIN
      IF m = 0 THEN
         n + 1
      ELIF n = 0 THEN
         ackermann (m - 1, 1)
      ELSE
         ackermann (m - 1, ackermann (m, n - 1))
      FI
   END # ackermann #;

   FOR m FROM 0 TO 3 DO
      FOR n FROM 0 TO 6 DO
         print(ackermann (m, n))
      OD;
      new line(stand out)
   OD
END # test ackermann #;
test ackermann
