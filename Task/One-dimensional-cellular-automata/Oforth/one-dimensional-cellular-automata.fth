: nextGen( l )
| i s |
   l byteSize dup ->s String newSize
   s loop: i [
      i 1 if=: [ 0 ] else: [ i 1- l byteAt '#' = ]
      i l byteAt '#' = +
      i s if=: [ 0 ] else: [ i 1+ l byteAt '#' = ] +
      2 if=: [ '#' ] else: [ '_' ] over add
      ]
;

: gen( l n -- )
    l dup .cr #[ nextGen dup .cr ] times( n ) drop ;
