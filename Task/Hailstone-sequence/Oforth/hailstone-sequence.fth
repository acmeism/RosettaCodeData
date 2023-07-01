: hailstone   // n -- [n]
| l |
   ListBuffer new ->l
   while(dup 1 <>) [ dup l add dup isEven ifTrue: [ 2 / ] else: [ 3 * 1+ ] ]
   l add l dup freeze ;

hailstone(27) dup size println dup left(4) println right(4) println
100000 seq map(#[ dup hailstone size swap Pair new ]) reduce(#maxKey) println
