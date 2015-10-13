BEGIN
   INT highest degree = 5;
   INT largest number = 10;
CO Recursive implementation of multifactorial function CO
   PROC multi fact = (INT n, deg) INT :
   (n <= deg | n | n * multi fact(n - deg, deg));
CO Iterative implementation of multifactorial function CO
   PROC multi fact i = (INT n, deg) INT :
   BEGIN
      INT result := n, nn := n;
      WHILE (nn >= deg + 1) DO
	 result TIMESAB nn - deg;
	 nn MINUSAB deg
      OD;
      result
   END;
CO Print out multifactorials CO
   FOR i TO highest degree DO
      printf (($l, "Degree ", g(0), ":"$, i));
      FOR j TO largest number DO
	 printf (($xg(0)$, multi fact (j, i)))
      OD
   OD
END
