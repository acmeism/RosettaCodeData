proc permlist k . list[] .
   if k = len list[]
      print list[]
      return
   .
   for i = k to len list[]
      swap list[i] list[k]
      permlist k + 1 list[]
      swap list[k] list[i]
   .
.
l[] = [ 1 2 3 ]
permlist 1 l[]
