: eratosthenes(n)
| i j |
   ListBuffer newSize(n) dup add(null) seqFrom(2, n) over addAll
   2 n sqrt asInteger for: i [
      dup at(i) ifNotNull: [ i sq n i step: j [ dup put(j, null) ] ]
      ]
   filter(#notNull) ;
