/*REXX program plots/draws line(s) using the Bresenham's line algorithm.*/
@.='·'                                 /*fill the array with middle─dots*/
parse arg data                         /*allow data point specifications*/
if data=''  then data= '(1,8)  (8,16)  (16,8)  (8,1)  (1,8)'   /*rhombus*/
data=translate(data,,'()[]{}/,:;')     /*elide chaff from data points.  */
                                       /* [↓] data pt pairs ──► !.array.*/
  do points=1  while data\=''          /*put data points into an array. */
  parse var data x y data; !.points=x y         /*extract line segments.*/
  if points==1  then do; minX=x; maxX=x; minY=y; maxY=y; end  /*1st case*/
  minX=min(minX,x); maxX=max(maxX,x);  minY=min(minY,y); maxY=max(maxY,y)
  end   /*points*/                     /* [↑]  data points pairs in  !. */

border=2                               /*border=extra space around plot.*/
minX=minX-border*2; maxX=maxX+border*2 /*min,max X for the plot display.*/
minY=minY-border  ; maxY=maxY+border   /* "   "  Y  "   "    "     "    */
  do x=minX  to maxX;  @.x.0='─';  end /*draw dash from   left──► right.*/
  do y=minY  to maxY;  @.0.y='│';  end /*draw pipe from lowest──►highest*/
@.0.0='┼'                              /*define the plot's axis point.  */
         do seg=2 to points-1; _=seg-1 /*obtain the X,Y line coördinates*/
         call draw_line   !._, !.seg   /*draw (plot) a line segment.    */
         end   /*seg*/                 /* [↑]  drawing the line segments*/
                                       /* [↓]  display the plot to term.*/
     do   y=maxY  to minY  by -1;  _=  /*display plot one line at a time*/
       do x=minX  to maxX              /*traipse throught the X axis.   */
       _=_ || @.x.y                    /*construct a "line" of the plot.*/
       end   /*x*/                     /*(a line is a "row" of points.) */
     say _                             /*display a "line" of the plot.  */
     end             /*y*/             /* [↑]  all done ploting the pts.*/
exit                                   /*stick a fork in it, we're done.*/
/*────────────────────────────────DRAW_LINE subroutine──────────────────*/
draw_line: procedure expose @.;   parse arg  x y,xf yf;       plotChar='Θ'
dx=abs(xf-x);   if x<xf  then sx=+1    /*obtain X range, determine slope*/
                         else sx=-1
dy=abs(yf-y);   if y<yf  then sy=+1    /*obtain Y range, determine slope*/
                         else sy=-1
err=dx-dy                              /*calc error between adjustments.*/
          do  forever;  @.x.y=plotChar /*plot the points until complete.*/
          if x=xf & y=yf  then  leave  /*are plot points at the finish? */
          err2=err+err                 /*this is faster than   err*2.   */
          if err2 > -dy  then  do;  err=err-dy;  x=x+sx;  end
          if err2 <  dx  then  do;  err=err+dx;  y=y+sy;  end
          end   /*forever*/
return
