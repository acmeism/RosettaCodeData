/*REXX program  generates  100  random points  in an  annulus:   10  ≤  √(x²≤y²)  ≤  15 */
parse arg points low high .                      /*obtain optional args from the C.L.   */
if points==''  then points=100
if    low==''  then  low=10;   low2= low**2      /*define a shortcut for squaring  LOW. */
if   high==''  then high=15;  high2=high**2      /*   "   "    "      "     "      HIGH.*/
$=
   do x=-high;        x2=x*x                     /*generate all possible annulus points.*/
   if x<0 & x2>high2  then iterate
   if x>0 & x2>high2  then leave
         do y=-high;          s=x2+y*y
         if (y<0 & s>high2) | s<low2  then iterate
         if  y>0 & s>high2            then leave
         $=$ x','y                               /*add a point─set to the  $  list.     */
         end   /*y*/
   end         /*x*/

plotChar='Θ';        minY=high2;       maxY=-minY;       ap=words($);      @.=

   do j=1  for points                            /*define the  x,y points [character O].*/
   parse value word($,random(1,ap)) with x ',' y /*pick a  random point  in the annulus.*/
   @.y=overlay(plotChar, @.y, 2*x+2*high+1)      /*define:  the data point.             */
   minY=min(minY,y);    maxY=max(maxY,y)         /*perform the plot point restricting.  */
   end   /*j*/
                                                 /* [↓]  only show displayable section. */
 do y=minY  to maxY;  say @.y;  end              /*display the annulus to the terminal. */
                                                 /*stick a fork in it,  we're all done. */
