func: sedol(s)
   [ 1, 3, 1, 7, 3, 9 ] s
   zipWith(#[ dup isDigit ifTrue: [ '0' - ] else: [ 'A' - 10 + ] * ]) sum
   10 mod 10 swap - 10 mod
   StringBuffer new s << swap '0' + <<c ;
