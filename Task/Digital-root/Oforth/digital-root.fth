: sumDigits(n, base)  0 while(n) [ n base /mod ->n + ] ;

: digitalRoot(n, base)
   0 while(n 9 >) [ 1 + sumDigits(n, base) ->n ] n swap Pair new ;
