proc permlist k &l$[] .
   if k = len l$[]
      write (strjoin l$[] "") & " "
      return
   .
   for i = k to len l$[]
      for j = k to i - 1
         if l$[j] = l$[i] : break 1
      .
      if j = i
         swap l$[i] l$[k]
         permlist k + 1 l$[]
         swap l$[k] l$[i]
      .
   .
.
func$[] list l[] .
   for i to len l[] : for j to l[i]
      h$ = strchar (64 + i)
      r$[] &= h$
   .
   return r$[]
.
l$[] = list [ 2 3 1 ]
permlist 1 l$[]
