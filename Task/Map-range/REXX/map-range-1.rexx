/*REXX program maps a range of numbers from one range to another range. */
rangeA =   0 10                        /*or:   rangeA =   '  0  10 '    */
rangeB =  -1  0                        /*or:   rangeB =   " -1   0 "    */
parse var RangeA L H
inc=1
          do j=L  to H  by inc*(1-2*sign(H<L))   /*BY:   +inc │ -inc)   */
          say right(j,digits())    ' maps to '   mapRange(rangeA,rangeB,j)
          end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────MAPRANGE subroutine─────────────────*/
mapRange: procedure; arg a1 a2,b1 b2,s;  return b1+ (s-a1)*(b2-b1)/(a2-a1)
