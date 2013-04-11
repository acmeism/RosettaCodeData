/*─────────────────────────────────────SQRT subroutine──────────────────*/
sqrt: procedure; parse arg x           /*a simple SQRT subroutine.      */
if x=0 then return 0                   /*handle special case of zero.   */
d=digits()                             /*get the current precision.     */
numeric digits digits()+2              /*ensure extra precision.        */
g=x/4                                  /*try get a so-so 1st guesstimate*/
old=0                                  /*set OLD guess to zero.         */

  do forever
  g=.5*(g+x/g)                         /*do the nitty-gritty calculation*/
  if g=old then leave                  /*if G is the same as old, quit. */
  old=g                                /*save OLD for next iteration.   */
  end                                  /*  .5*   is faster than    /2   */

numeric digits d                       /*restore the original precision.*/
return g/1                             /*normalize to old precision.    */
