   load'rb.ijs'
   NB. populate dictionary in random order with 999 key value pairs
   insert@:(; 6j1&":)"0@:?~ 999
   find 'the' NB. 'the' has no entry.
   find 239   NB. entry 239 has the anticipated formatted string value.
 239.0
   find 823823 NB. also no such entry
   NB.
   NB. tree passes the "no consecutive red" and "same number of black"
   NB. nodes to and including NULL leaves.
   check''
