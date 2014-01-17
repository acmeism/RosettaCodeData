/*REXX program simulates a # of trials of the classic Monty Hall problem*/
parse arg t .; if t=='' then t=1000000 /*Not specified? Then use default*/
wins.=0                                /*wins.0=stay;  wins.1=switching.*/
                                       /*door values:    0=goat   1=car */
  do  t                                /*perform this loop   T   times. */
  door.=0                              /*set all doors to  zero.        */
  car=random(1,3);   door.car=1        /*TV show hides a car randomly.  */
  ?=random(1,3)  ;   _=door.?          /*contestant picks a random door.*/
  wins._=wins._+1                      /*bump the type of win strategy. */
  end   /*DO t*/

say 'switching wins '     format(wins.0/t*100,,1)"%  of the time."
say '  staying wins '     format(wins.1/t*100,,1)"%  of the time.";    say
say 'performed'   t   "times."          /*stick a fork in it, we're done.*
