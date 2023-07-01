# Project : Queue/Definition

load "stdlib.ring"
oQueue = new Queue
for n = 5 to 7
     see "Push: " + n + nl
     oQueue.add(n)
next
see "Pop: " + oQueue.remove() + nl
see "Push: 8" + nl
oQueue.add(8)
see "Pop: " + oQueue.remove() + nl
see "Pop: " + oQueue.remove() + nl
see "Pop: " + oQueue.remove() + nl
if len(oQueue) != 0
   oQueue.print()
else
   see "Error: queue is empty" + nl
ok
