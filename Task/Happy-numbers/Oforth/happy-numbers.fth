: isHappy(n)
| cycle |
   ListBuffer new ->cycle

   while(n 1 <>) [
      cycle include(n) ifTrue: [ false return ]
      cycle add(n)
      0 n asString apply(#[ asDigit sq + ]) ->n
      ]
   true ;

: happyNum(N)
| numbers |
   ListBuffer new ->numbers
   1 while(numbers size N <>) [ dup isHappy ifTrue: [ dup numbers add ] 1+ ]
   numbers println ;
