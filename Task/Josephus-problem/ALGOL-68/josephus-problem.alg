BEGIN
   PROC josephus = (INT n, k, m) INT :
   CO Return m-th on the reversed kill list; m=0 is final survivor. CO
   BEGIN
      INT lm := m;			CO Local copy of m CO
      FOR a FROM m+1 WHILE a <= n DO lm := (lm+k) %* a OD;
      lm
   END;
   INT n = 41, k=3;
   printf (($"n = ", g(0), ", k = ", g(0), ", final survivor: ", g(0)l$,
	    n, k, josephus (n, k, 0)))
END
