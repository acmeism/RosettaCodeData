: sq_digits(n)
   while (n 1 <> n 89 <> and ) [
      0 while(n) [ n 10 /mod ->n dup * + ]
      ->n
      ] n ;

: iterDigits  | i | 0 100000000 loop: i [ i sq_digits 89 &= + ] . ;
