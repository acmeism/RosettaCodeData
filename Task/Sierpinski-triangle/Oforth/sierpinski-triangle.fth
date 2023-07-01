: nextGen(l, r)
| i |
   StringBuffer new
   l size loop: i [
      l at(i 1 -) '*' == 4 *
      l at(i)     '*' == 2 * +
      l at(i 1 +) '*' == +
      2 swap pow r bitAnd ifTrue: [ '*' ] else: [ ' ' ] over addChar
      ] ;

: automat(rule, n)
   StringBuffer new " " <<n(n) "*" over + +
   #[ dup println rule nextGen ] times(n) drop ;

: sierpinskiTriangle(n)
   90 4 n * automat ;
