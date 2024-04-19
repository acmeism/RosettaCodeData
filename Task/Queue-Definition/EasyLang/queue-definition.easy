prefix qu_
global q[] head tail .
#
proc enq n . .
   if tail = 0
      head = 1
   else
      q[tail + 2] = len q[] + 1
   .
   q[] &= n
   q[] &= tail
   q[] &= 0
   tail = len q[] - 2
.
func deq .
   if head = 0
      return 0 / 0
   .
   r = q[head]
   old = head
   head = q[head + 2]
   last = len q[]
   prev = q[last - 1]
   if prev <> 0
      q[prev + 2] = old
   .
   next = q[last]
   if next <> 0
      q[next + 1] = old
   else
      tail = old
   .
   q[old] = q[last - 2]
   q[old + 1] = q[last - 1]
   q[old + 2] = q[last]
   len q[] -3
   if head = len q[] + 1
      head = old
   .
   if head <> 0
      q[head + 1] = 0
   else
      tail = 0
   .
   return r
.
func empty .
   return if head = 0
.
prefix
#
qu_enq 2
qu_enq 5
qu_enq 7
while qu_empty = 0
   print qu_deq
.
