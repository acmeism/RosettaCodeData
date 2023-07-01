String method: isBalanced
| c |
   0 self forEach: c [
      c '[' == ifTrue: [ 1+ continue ]
      c ']' <> ifTrue: [ continue ]
      1- dup 0 < ifTrue: [ drop false return ]
      ]
   0 == ;

: genBrackets(n)
   "" #[ "[" "]" 2 rand 2 == ifTrue: [ swap ] rot + swap + ] times(n) ;
