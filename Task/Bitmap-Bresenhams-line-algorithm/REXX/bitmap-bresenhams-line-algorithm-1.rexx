/*REXX program plots/draws line segments using the Bresenham's line algorithm.*/
@.='·'                                 /*fill the array with middle─dots chars*/
parse arg data                         /*allow the data point specifications. */
if data=''  then data= '(1,8)  (8,16)  (16,8)  (8,1)  (1,8)'   /*◄────rhombus.*/
data=translate(data,,'()[]{}/,:;')     /*elide chaff from the data points.    */
                                       /* [↓]  data point pairs ───► !.array. */
  do points=1  while data\=''          /*put the data points into an array (!)*/
  parse var data x y data; !.points=x y          /*extract the line segments. */
  if points==1  then do; minX=x; maxX=x; minY=y; maxY=y;  end      /*1st case.*/
  minX=min(minX,x); maxX=max(maxX,x);  minY=min(minY,y);  maxY=max(maxY,y)
  end   /*points*/                     /* [↑]  data points pairs in array  !. */

border=2                               /*border:  is extra space around plot. */
minX=minX-border*2; maxX=maxX+border*2 /*min and max  X  for the plot display.*/
minY=minY-border  ; maxY=maxY+border   /* "   "   "   Y   "   "    "     "    */
  do x=minX  to maxX;  @.x.0='─';  end /*draw a dash from    left ───►  right.*/
  do y=minY  to maxY;  @.0.y='│';  end /*draw a pipe from  lowest ───► highest*/
@.0.0='┼'                              /*define the plot's origin axis point. */
         do seg=2 to points-1; _=seg-1 /*obtain the  X and Y  line coördinates*/
         call draw_line   !._, !.seg   /*draw (plot) a line segment.          */
         end   /*seg*/                 /* [↑]  drawing the line segments.     */
                                       /* [↓]  display the plot to terminal.  */
     do   y=maxY  to minY  by -1;  _=  /*display the plot one line at a time. */
       do x=minX  to maxX              /*build line by examining the  X  axis.*/
       _=_ || @.x.y                    /*construct/build a line of the plot.  */
       end   /*x*/                     /*      (a line is a "row" of points.) */
     say _                             /*display a line of the plot──►terminal*/
     end             /*y*/             /* [↑]  all done plotting the points.  */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
draw_line: procedure expose @.;     parse arg    x y,xf yf;         plotChar='Θ'
dx=abs(xf-x);   if x<xf  then sx=+1    /*obtain  X  range, determine the slope*/
                         else sx=-1
dy=abs(yf-y);   if y<yf  then sy=+1    /*obtain  Y  range, determine the slope*/
                         else sy=-1
err=dx-dy                              /*calculate error between adjustments. */
          do  forever;  @.x.y=plotChar /*plot the points until it's complete. */
          if x=xf & y=yf  then return  /*are the plot points at the finish?   */
          err2=err+err                 /*addition is faster than:   err*2.    */
          if err2 > -dy  then  do;   err=err-dy;  x=x+sx;   end
          if err2 <  dx  then  do;   err=err+dx;  y=y+sy;   end
          end   /*forever*/
