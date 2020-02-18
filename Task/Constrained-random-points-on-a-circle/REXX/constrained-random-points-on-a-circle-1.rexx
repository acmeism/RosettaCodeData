/*REXX program  generates  100  random points  in an  annulus:   10  ≤  √(x²≤y²)  ≤  15 */
parse arg pts LO HI .                            /*obtain optional args from the C.L.   */
if pts==''  then pts= 100                        /*Not specified?  Then use the default.*/
if  LO==''  then  LO= 10;            LO2= LO**2  /*define a shortcut for squaring   LO. */
if  HI==''  then  HI= 15;            HI2= HI**2  /*   "   "    "      "      "      HI. */
$=
       do x=-HI;                      xx= x*x    /*generate all possible annulus points.*/
       if x<0 & xx>HI2  then iterate
       if x>0 & xx>HI2  then leave
           do y=-HI;          s= xx + y*y
           if (y<0 & s>HI2) | s<LO2  then iterate
           if  y>0 & s>HI2           then leave
           $= $  x','y                           /*add a point─set to the  $  list.     */
           end   /*y*/
       end       /*x*/
                        plotChr= 'Θ';    minY= HI2;    maxY= -minY;    #= words($);    @.=
   do pts;  parse value word($, random(1,#))  with  x ',' y    /*random point in annulus*/
   @.y= overlay(plotChr, @.y, x*2 + HI*2 + 1);    minY= min(minY, y);   maxY= max(maxY, y)
   end   /*pts*/                                 /* [↑]  plot a point; find min & max Y.*/
                                                 /*stick a fork in it,  we're all done. */
   do y=minY  to maxY;      say @.y;   end       /*display the annulus to the terminal. */
