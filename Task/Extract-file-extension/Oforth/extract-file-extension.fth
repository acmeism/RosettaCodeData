: fileExt( s -- t )
| i |
   s lastIndexOf('.') dup ->i ifNull: [ null return ]
   s extract(i 1+, s size) conform(#isAlpha) ifFalse: [ null return ]
   s extract(i, s size)
;
