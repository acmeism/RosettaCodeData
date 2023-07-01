import: mapping

Integer method: properDivs -- []
    self 2 / seq  filter( #[ self swap mod 0 == ] ) ;

: numberClasses
| i deficient perfect s |
   0 0 ->deficient ->perfect
   0 20000 loop: i [
      0 #+ i properDivs apply ->s
      s i <  ifTrue: [ deficient 1+ ->deficient continue ]
      s i == ifTrue: [ perfect 1+ ->perfect continue ]
      1+
      ]
   "Deficients :" . deficient .cr
   "Perfects   :" . perfect   .cr
   "Abundant   :" . .cr
;
