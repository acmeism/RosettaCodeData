/*REXX program maps and displays a  range of numbers from  one range  to  another range.*/
rangeA =  10  0                                        /*or:   rangeA =   ' 10   0 '    */
rangeB =  -1  0                                        /*or:   rangeB =   " -1   0 "    */
parse var RangeA L H                                   /*note the LOW & HIGH values in A*/
inc= 1/2                                               /*use a different step size (inc)*/
          do j=L  to H  by inc * (1 - 2 * sign(H<L) )  /*BY:  either   +inc   or   -inc */
          say right(j, digits())        ' maps to '         mapRange(rangeA, rangeB, j)
          end   /*j*/
exit                                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
mapRange: procedure; parse arg a1 a2,b1 b2,s;    return  b1  +  (s-a1) * (b2-b1) / (a2-a1)
