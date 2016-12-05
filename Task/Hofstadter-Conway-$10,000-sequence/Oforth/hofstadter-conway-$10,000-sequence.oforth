: hofstadter(n)
| l i |
   ListBuffer newSize(n) dup add(1) dup add(1) ->l
   n 2 - loop: i [ l at(l last) l at(l size l last - 1+ ) + l add ]
   l dup freeze ;

: hofTask
| h m i |
   2 20 pow ->m
   hofstadter(m) m seq zipWith(#[ tuck asFloat / swap Pair new ]) ->h

   19 loop: i [
      i . "^2 ==>" .
      h extract(2 i pow , 2 i 1+ pow) reduce(#maxKey) println
      ]

   "Mallows number ==>" . h reverse detect(#[ first 0.55 >= ], true) println
;
