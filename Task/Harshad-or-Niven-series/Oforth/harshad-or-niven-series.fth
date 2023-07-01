: sumDigits(n)  0 while(n) [ n 10 /mod ->n + ] ;
: isHarshad     dup sumDigits mod 0 == ;

1100 seq filter(#isHarshad) dup left(20) println dup filter(#[ 1000 > ]) first println
