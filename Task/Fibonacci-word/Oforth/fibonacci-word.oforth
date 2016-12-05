: entropy(s) -- f
| freq sz |
   s size dup ifZero: [ return ] asFloat ->sz
   ListBuffer initValue(255, 0) ->freq
   s apply( #[ dup freq at 1+ freq put ] )
   0.0 freq applyIf( #[ 0 <> ], #[ sz / dup ln * - ] ) Ln2 / ;


: FWords(n)
| ws i |
   ListBuffer new dup add("1") dup add("0") dup ->ws
   3 n for: i [ i 1- ws at  i 2 - ws at  +  ws add ]
   dup map(#[ dup size swap entropy Pair new]) apply(#println) ;
