stack[] = [ ]
proc push v . .
   stack[] &= v
.
func pop .
   if len stack[] = 0
      return 0
   .
   r = stack[-1]
   len stack[] -1
   return r
.
func empty .
   return if len stack[] = 0
.
push 2
push 11
push 34
while empty = 0
   print pop
.
