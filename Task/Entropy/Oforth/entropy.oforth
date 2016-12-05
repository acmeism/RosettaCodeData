: entropy(s) -- f
| freq sz |
   s size dup ifZero: [ return ] asFloat ->sz
   ListBuffer initValue(255, 0) ->freq
   s apply( #[ dup freq at 1+ freq put ] )
   0.0 freq applyIf( #[ 0 <> ], #[ sz / dup ln * - ] ) Ln2 / ;

entropy("1223334444") .
