   keys=: 10?.100
   vals=: > ;:'zero one two three four five six seven eight nine'
   hash=: vals {~ keys&i.

   keys
46 99 23 62 42 44 12 5 68 63
   $vals
10 5

   hash 46
zero
   hash 99
one
   hash 63 5 12 5 23
nine
seven
six
seven
two
