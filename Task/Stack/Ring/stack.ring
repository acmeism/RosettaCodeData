# Project : Stack

load "stdlib.ring"
ostack = new stack
for n = 5 to 7
     see "Push: " + n + nl
     ostack.push(n)
next
see "Pop:" + ostack.pop() + nl
see "Push: " + "8" + nl
ostack.push(8)
while len(ostack) > 0
        see "Pop:" + ostack.pop() + nl
end
if len(ostack) = 0
   see "Pop: stack is empty" + nl
ok
