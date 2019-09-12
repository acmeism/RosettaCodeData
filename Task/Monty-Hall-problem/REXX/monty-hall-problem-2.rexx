/*REXX program  simulates  a number of trials of the classic  Monty Hall  problem.      */
parse arg # d seed .                             /*obtain the optional args from the CL.*/
if #==''  |  #==","     then #=1000000           /*Not specified?  Then use 1 million.  */
if d==''  |  d==","     then d=      3           /* "      "         "   "  three doors.*/
if datatype(seed, 'W')  then call random ,, seed /*Specified?  Use as a seed for RANDOM.*/
wins.= 0                                         /*wins.0 ≡ stay,    wins.1 ≡ switching.*/
           do  #;                   door.   = 0  /*initialize all doors to a value of 0.*/
           car= random(1, d);       door.car= 1  /*the TV show hides a car randomly.    */
             ?= random(1, d);       _= door.?    /*the contestant picks a random door.  */
           wins._ =  wins._  +  1                /*bump the type of win strategy.       */
           end   /*#*/                           /* [↑]  perform the loop   #   times.  */
                                                 /* [↑]  door values:   0≡goat    1≡car */
say 'switching wins '    format(wins.0 / # * 100, , 1)"%  of the time."
say '  staying wins '    format(wins.1 / # * 100, , 1)"%  of the time." ;    say
say 'performed '  #  " times with "  d ' doors.' /*stick a fork in it,  we're all done. */
