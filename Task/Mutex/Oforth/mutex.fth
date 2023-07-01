import: parallel

: job(mut)
   mut receive drop
   "I get the mutex !" .
   2000 sleep
   "Now I release the mutex" println
   1 mut send drop ;

: mymutex
| mut |
   Channel new dup send(1) drop ->mut
   10 #[ #[ mut job ] & ] times ;
