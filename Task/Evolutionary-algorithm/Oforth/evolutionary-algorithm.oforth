200 Constant new: C
  5 Constant new: RATE

: randChar  // -- c
   27 rand dup 27 == ifTrue: [ drop ' ' ] else: [ 'A' + 1- ] ;

: fitness(a b -- n)
   a b zipWith(#==) sum ;

: mutate(s -- s')
   s map(#[ 100 rand RATE <= ifTrue: [ drop randChar ] ]) charsAsString ;

 : evolve(target)
| parent |
   ListBuffer init(target size, #randChar) charsAsString ->parent

   1 while ( parent target <> ) [
      ListBuffer init(C, #[ parent mutate ]) dup add(parent)
      maxFor(#[ target fitness ]) dup ->parent . dup println 1+
      ] drop ;
