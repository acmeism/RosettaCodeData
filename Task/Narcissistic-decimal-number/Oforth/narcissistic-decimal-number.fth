: isNarcissistic(n)
| i m |
   n 0 while( n ) [ n 10 /mod ->n swap 1 + ] ->m
   0 m loop: i [ swap m pow + ] == ;

: genNarcissistic(n)
| l |
   ListBuffer new dup ->l
   0 while(l size n <>) [ dup isNarcissistic ifTrue: [ dup l add ] 1 + ] drop ;
