/*REXX program calculates and displays   factorions   in  bases  nine ───► twelve.      */
parse arg LOb HIb lim .                          /*obtain optional arguments from the CL*/
if LOb=='' | LOb==","  then LOb=       9         /*Not specified?  Then use the default.*/
if HIb=='' | HIb==","  then HIb=      12         /* "      "         "   "   "      "   */
if lim=='' | lim==","  then lim= 1500000  -  1   /* "      "         "   "   "      "   */

  do fact=0  to HIb;   !.fact= !(fact)           /*use memoization for factorials.      */
  end   /*fact*/

  do base=LOb  to  HIb                           /*process all the required bases.      */
  @= 1 2                                         /*initialize the list  (@)  to  1 & 2. */
          do j=3  for lim-2;  $= 0               /*initialize the sum   ($)  to  zero.  */
                                          t= j   /*define the target  (for the sum !'s).*/
                                 do until t==0;    d= t // base      /*obtain a "digit".*/
                                                   $= $ + !.d        /*add  !(d) to sum.*/
                                                   t= t % base       /*get a new target.*/
                                 end   /*until*/
          if $==j  then @= @ j                   /*Good factorial sum? Then add to list.*/
          end   /*i*/
  say
  say 'The factorions for base '      right( base, length(HIb) )        " are: "         @
  end   /*base*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
!: procedure; parse arg x;  !=1;    do j=2  to x;  !=!*j;  end;   return !  /*factorials*/
