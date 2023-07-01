/*REXX pgm uses a Monte Carlo estimate for the results for the Sleeping Beauty problem. */
parse arg n seed .                               /*obtain optional arguments from the CL*/
if n==''  |  n==","     then n= 1000000          /*Not specified?  Then use the default.*/
if datatype(seed, 'W')  then call random ,,seed  /*    Specified?  Then use as RAND seed*/
awake= 0                                         /*     "        "    "   "   awakened. */
           do #=0  for n                         /*perform experiment:  1 million times?*/
           if random(,1)  then awake= awake + 1  /*Sleeping Beauty  is   awoken.        */
                          else #= # + 1          /*   "        "   keeps sleeping.      */
           end   /*#*/                           /* [↑]  RANDOM returns:    0  or  1    */

say 'Wakenings over '     commas(n)     " repetitions: "      commas(#)
say 'The percentage probability of heads on awakening: '      (awake / # * 100)"%"
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
