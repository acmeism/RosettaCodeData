/*REXX pgm displays current CPU utilization (as a percentage) as per file:  /proc/stat  */
signal on halt                                   /*enable handling of Ctrl─Break (halt).*/
numeric digits 20                                /*ensure enough decimal digits for pgm.*/
parse arg n wait iFID .                          /*obtain optional arguments from the CL*/
if    n=='' |    n=","  then    n= 10            /*Not specified?  Then use the default.*/
if wait=='' | wait=","  then wait=  1            /* "      "         "   "   "     "    */
if iFID=='' | iFID=","  then iFID= '/proc/stat'  /* "      "         "   "   "     "    */
prevTot  = 0;           prevIdle= 0              /*initialize the prevTot and prevIdle. */

  do j=1  for n                                  /*process CPU utilization   N   times. */
  parse value  linein(iFID, 1)  with  .  $       /*read the 1st line and ignore 1st word*/
  tot= 0                                         /*initalize  TOT  (total time) to zero.*/
             do k=1  for min(8, words($) )       /*only process up to eight numbers in $*/
             @.k= word($,k)                      /*assign  the times to an array (@).   */
             tot= tot + @.k                      /*add all the times from the 1st line. */
             end   /*k*/                         /*@.4  is the idle time for this cycle.*/

  div= tot - prevTot                             /*DIV may be zero if file isn't updated*/
  if div\=0  then say format(((1-(@.4-prevIdle)/div))*100,3,5)"%"    /*display CPU busy.*/
  prevTot= tot;    prevIdle= @.4                 /*set the previous  TOT  and  prevIdle.*/
  call sleep wait                                /*cause this pgm to sleep   WAIT  secs.*/
  end   /*j*/
                                                 /*stick a fork in it,  we're all done. */
halt:                                            /*come here when   Ctrl-Break  pressed.*/
