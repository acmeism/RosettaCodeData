/*REXX pgm plots 3 circles using midpoint/Bresenham's circle algorithm. */
   EoE = 200                           /*EOE = End Of Earth,  er, plot. */
image. = 'fa'x                         /*fill the array with middle-dots*/
pChar  = '*'
                do j=-EoE to +EoE      /*draw grid from lowest──>highest*/
                image.j.0 = '─'        /*draw the horizontal axis.      */
                image.0.j = '│'        /*  "   "  verical      "        */
                end    /*j*/
image.0.0='┼'                          /*"draw" the axis origin.        */
minX=0;  maxX=0
minY=0;  maxY=0
call draw_circle  0, 0,  8, '#'
call draw_circle  0, 0, 11, '$'
call draw_circle  0, 0, 19, '@'
border=2
minX=minX-border*2;  maxX=maxX+border*2
minY=minY-border  ;  maxY=maxY+border
                                         do y=maxY  by -1  to minY;  aRow=
                                                  do x=minX  to maxX
                                                  aRow=aRow || image.x.y
                                                  end   /*x*/
                                         say aRow
                                         end            /*y*/
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────────DRAW_CIRCLE subroutine─────────────*/
draw_circle: procedure expose image. minX maxX minY maxY
parse arg xx, yy, r, point;     f=1-r;     ddfx=1;     ddfy=-2*r;      y=r
_=yy+r; image.xx._='*'
_=xx+r; image._.yy='*'
_=yy-r; image.xx._='*'
_=xx-r; image._.yy='*'
                        do x=0 while x<y
                        if f>=0 then do; y=y-1; ddfy=ddfy+2; f=f+ddfy; end
                                                ddfx=ddfx+2; f=f+ddfx
                        x_=xx+x;   y_=yy+y;   call plotXY x_, y_, point
                        x_=xx+y;   y_=yy+x;   call plotXY x_, y_, point
                        x_=xx+y;   y_=yy-x;   call plotXY x_, y_, point
                        x_=xx+x;   y_=yy-y;   call plotXY x_, y_, point
                        x_=xx-x;   y_=yy-y;   call plotXY x_, y_, point
                        x_=xx-y;   y_=yy-x;   call plotXY x_, y_, point
                        x_=xx-y;   y_=yy+x;   call plotXY x_, y_, point
                        x_=xx-x;   y_=yy+y;   call plotXY x_, y_, point
                        end   /*x*/
return
/*──────────────────────────────────PLOTXY subroutine───────────────────*/
plotXY: procedure expose image. minX maxX minY maxY;   parse arg xx, yy, p
image.xx.yy=p;      minX=min(minX,xx);      maxX=max(maxX,xx)
                    minY=min(minY,yy);      maxY=max(maxY,yy)
return
