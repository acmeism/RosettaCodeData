  [ [] swap dup size times
      [ dup size random pluck
        nested rot join swap ]
    drop ]                      is shuffle (     [ --> [ )

  [ temp put
    2dup swap
    temp share swap peek
    temp share rot peek
    dip
      [ swap
        temp take
        swap poke
        temp put ]
    swap
    temp take
    swap poke ]                 is [exch]  ( n n [ --> [ )

  [ dup size 1 - times
      [ i 1+ dup 1+ random
        rot [exch] ] ]         is knuffle (     [ --> [ )
