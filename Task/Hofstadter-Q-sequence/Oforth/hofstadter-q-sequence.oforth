: QSeqTask
| q i |
   ListBuffer newSize(100000) dup add(1) dup add(1) ->q
   0 3 100000 for: i [
      q add(q at(i q at(i 1-) -) q at(i q at(i 2 -) -) +)
      q at(i) q at(i 1-) < ifTrue: [ 1+ ]
      ]
   q left(10) println q at(1000) println println ;
