/*REXX pgm maps a range of numbers from one range to another with inc=½.*/
rangeA =  10  0                        /*or:   rangeA =   ' 10   0 '    */
rangeB =  -1  0                        /*or:   rangeB =   " -1   0 "    */
parse var RangeA L H                   /*note the LOW & HIGH values in A*/
inc= 1/2                               /*use a different step size (inc)*/
          do j=L  to H  by inc*(1-2*sign(H<L))      /*BY:  +inc │ -inc) */
          say right(j,9)        ' maps to '      mapRange(rangeA,rangeB,j)
          end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────MAPRANGE subroutine─────────────────*/
mapRange: procedure; arg a1 a2,b1 b2,s;  return b1+ (s-a1)*(b2-b1)/(a2-a1)
