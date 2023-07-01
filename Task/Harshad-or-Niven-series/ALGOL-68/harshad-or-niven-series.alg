BEGIN
   PROC digit sum = (INT i) INT :
   BEGIN
      INT res := i %* 10, h := i;
      WHILE (h %:= 10) > 0 DO res +:= h %* 10 OD;
      res
   END;
   INT  found := 0;
   FOR i WHILE found < 20 DO
      (i %* digit sum (i) = 0 | found +:= 1; printf (($g(0)", "$, i)) ) OD;
   FOR i FROM 1001 DO
      (i %* digit sum (i) = 0 | printf (($g(0)l$, i)); stop) OD
END
