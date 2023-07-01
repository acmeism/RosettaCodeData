: encode(s)
   StringBuffer new
   s group apply(#[ tuck size asString << swap first <<c ]) ;

: decode(s)
| c i |
   StringBuffer new
   0 s forEach: c [
      c isDigit ifTrue: [ 10 * c asDigit + continue ]
      loop: i [ c <<c ] 0
      ]
   drop ;
