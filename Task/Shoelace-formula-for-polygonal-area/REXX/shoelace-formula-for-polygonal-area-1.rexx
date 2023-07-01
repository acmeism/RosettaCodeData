/*REXX program uses a  Shoelace  formula to calculate the area of an  N-sided  polygon. */
parse arg pts;           $polygon = 'polygon area of '  /*get optional args from the CL.*/
if pts=''  then pts= '(3,4),(5,11),(12,8),(9,5),(5,6)'  /*Not specified?   Use default. */
                         @= pts                         /*elide extra blanks;  save pts.*/
           do #=1  until @=''                           /*perform destructive parse on @*/
           parse var @  '('  x.#  ","  y.#  ')'  ","  @ /*obtain  X  and  Y  coördinates*/
           end   /*#*/
A= 0                                                    /*initialize the  area  to zero.*/
           do j=1  for #;  jp=j+1;  if jp>#   then jp=1 /*adjust for  J  for overflow.  */
                           jm=j-1;  if jm==0  then jm=# /*   "    "   "   "  underflow. */
           A=A + x.j * (y.jp - y.jm)                    /*compute a part of the area.   */
           end   /*j*/
say $polygon  #  " points: " pts '  is ───► '  abs(A/2) /*stick a fork in it, we're done*/
