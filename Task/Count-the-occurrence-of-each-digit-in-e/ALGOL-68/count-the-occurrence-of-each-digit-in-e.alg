BEGIN # calculate the decimal digits of e and count how many times each #
      # digit occurs - based on the B code on the Wikipedia page:       #
      #          https://en.wikipedia.org/wiki/B_(programming_language) #

   PR include "rows.incl.a68" PR        # include row (array) utilities #

   # this counts the digits in the fractional part of e so the initial  #
   # count for 2 is 1, to include the non-fractional digit              #
   [ 0 : 9 ]INT dcount := []INT( 0, 0, 1, 0, 0, 0, 0, 0, 0, 0 )[ AT 0 ];
   [ 0 : 1999 ]INT v;
   INT n = UPB v + 1;
   INT c, a;

   FOR i FROM LWB v TO UPB v DO v[i] := 1 OD;

   FOR col FROM 0 TO 2*n DO
      a := n+1;
      c := 0;
      FOR i FROM LWB v TO UPB v DO
         c +:= v[i]*10;
         v[i] := c MOD a;
         c OVERAB a;
         a -:= 1
      OD;
      dcount[ c ] +:= 1
CO                     ;     # uncomment this to show the actual digits #
      print( ( REPR ( c + ABS "0" ) ) );
      IF ( col + 1 ) MOD 5 = 0 THEN
         print( ( IF ( col + 1 ) MOD 50 /= 0 THEN space ELSE newline FI ) )
      FI
CO
   OD;
   SHOW dcount
END
