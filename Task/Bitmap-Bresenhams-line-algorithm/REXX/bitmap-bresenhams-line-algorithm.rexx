/*REXX program plots/draws a line using the Bresenham's line algorithm. */

EoE    = 1000                          /*EOE = End Of Earth,  er, plot. */
image. = 'fa'x                         /*fill the array with middle-dots*/
plotC  = 'fe'x                         /*character used for plotting pts*/
                do j=-EoE to +EoE      /*draw grid from lowest──>highest*/
                image.j.0 = '─'        /*draw the horizontal axis.      */
                image.0.j = '│'        /*  "   "  verical      "        */
                end    /*j*/
image.0.0='┼'                          /*"draw" the axis origin.        */
parse arg xi yi xf yf .                /*allow specifying line-end pts. */
if xi=='' | xi==',' then xi = -1       /*if not specified, use default. */
if yi=='' | yi==',' then yi = -3       /* "  "      "       "     "     */
if xf=='' | xf==',' then xf =  6       /* "  "      "       "     "     */
if yf=='' | yf==',' then yf = 10       /* "  "      "       "     "     */
call draw_line  xi,  yi,  xf,  yf      /*call subroutine and draw line. */
call findMaxXY
                                   do y=maxY    by -1    to minY;    aRow=
                                             do x=minX   to maxX
                                             aRow=aRow || image.x.y
                                             end   /*x*/
                                   say aRow
                                   end             /*y*/
exit
/*────────────────────────────────DRAW_LINE subroutine──────────────────*/
draw_line: procedure expose image. plotC;   error=0
parse arg    xi 1 x0,     yi 1 y0 1 y,     xf 1 x1,     yf 1 y1
steep= abs(y1-y0) > abs(x1-x0)
if steep then parse value  x0 y0 x1 y1   with   y0 x0 y1 x1
if x0>x1 then parse value  x0 x1 y0 y1   with   x1 x0 y1 y0

                                 if y0<y1 then yInc =  1
                                          else yInc = -1
deltaE=abs(y1-y0) / (x1-x0)

                do x=x0 to x1
                if steep then image.y.x=plotC
                         else image.x.y=plotC
                error=error+deltaE
                if error>=.5 then do;   y=y+yInc;   error=error-1;   end
                end
return
/*────────────────────────────────FINDMAXXY subroutine──────────────────*/
findMaxXY:  extra=3                   /*don't just show cropped plot.   */
  do minX=-EoE to +EoE                /*find min  X  in the plot field. */
    do y=-EoE to +EoE;  if .isP(image.minX.y) then leave minX;  end  /*y*/
  end     /*minX*/

  do maxX=+EoE to -EoE by -1          /*find max  X  in the plot field. */
    do y=-EoE to +EoE;  if .isP(image.maxX.y) then leave maxX;  end  /*y*/
  end     /*maxX*/

  do minY=-EoE to +EoE                /*find min  Y  in the plot field. */
    do x=-EoE to +EoE;  if .isP(image.x.minY) then leave minY;  end  /*x*/
  end     /*minY*/

  do maxY=+EoE to -EoE by -1          /*find max  Y  in the plot field. */
    do x=-EoE to +EoE;  if .isP(image.X.maxy) then leave maxY;  end  /*x*/
  end     /*maxY*/

minX=minX-extra*2;   minY=minY-extra  /*like showbiz, show a little more*/
maxX=maxX+extra*2;   maxY=maxY+extra  /*  "     "       "  "    "     " */
return                                /*go ye forth and show ye plot.   */
.isP: return pos(arg(1),plotC)\==0
