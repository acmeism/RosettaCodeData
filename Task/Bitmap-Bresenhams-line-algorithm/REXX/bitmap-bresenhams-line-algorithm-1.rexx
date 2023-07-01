/*REXX program  plots/draws line segments  using the  Bresenham's line  (2D) algorithm. */
parse arg data                                   /*obtain optional arguments from the CL*/
if data=''  then data= "(1,8)  (8,16)  (16,8)  (8,1)  (1,8)"         /* ◄──── a rhombus.*/
data= translate(data, , '()[]{}/,:;')            /*elide chaff from the data points.    */
@.= '·'                                          /*use mid─dots chars (plot background).*/
           do points=1  while data\=''           /*put the data points into an array (!)*/
           parse var data x y data; !.points=x y /*extract the line segments.           */
           if points==1  then do;  minX= x;  maxX= x;  minY= y;  maxY= y     /*1st case.*/
                              end
           minX= min(minX,x);   maxX= max(maxX,x);   minY= min(minY,y);  maxY= max(maxY,y)
           end   /*points*/                      /* [↑]  data points pairs in array  !. */
border= 2                                        /*border:  is extra space around plot. */
minX= minX - border*2;    maxX= maxX + border*2  /*min and max  X  for the plot display.*/
minY= minY - border  ;    maxY= maxY + border    /* "   "   "   Y   "   "    "     "    */

           do x=minX  to maxX;  @.x.0= '─';  end /*draw a dash from    left ───►  right.*/
           do y=minY  to maxY;  @.0.y= '│';  end /*draw a pipe from  lowest ───► highest*/
@.0.0= '┼'                                       /*define the plot's origin axis point. */
           do seg=2  to points-1;     _= seg - 1 /*obtain the  X and Y  line coördinates*/
           call drawLine  !._, !.seg             /*draw (plot) a line segment.          */
           end      /*seg*/                      /* [↑]  drawing the line segments.     */
                                                 /* [↓]  display the plot to terminal.  */
           do    y=maxY  to minY  by -1;   _=    /*display the plot one line at a time. */
              do x=minX  to maxX;  _= _ || @.x.y /*construct/build a line of the plot.  */
              end   /*x*/                        /*      (a line is a "row" of points.) */
           say _                                 /*display a line of the plot──►terminal*/
           end      /*y*/                        /* [↑]  all done plotting the points.  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
drawLine: procedure expose @.; parse arg  x y,xf yf;    parse value  '-1 -1'   with  sx sy
          dx= abs(xf-x);    if x<xf  then sx= 1  /*obtain  X  range, determine the slope*/
          dy= abs(yf-y);    if y<yf  then sy= 1  /*   "    Y    "        "      "    "  */
          err= dx - dy                           /*calculate error between adjustments. */
                                                 /*Θ  is the plot character for points. */
              do  forever;           @.x.y= 'Θ'  /*plot the points until it's complete. */
              if x=xf  &  y=yf  then return      /*are the plot points at the finish?   */
              err2= err + err                    /*calculate  double  the error value.  */
              if err2 > -dy  then  do;    err= err - dy;    x= x + sx;     end
              if err2 <  dx  then  do;    err= err + dx;    y= y + sy;     end
              end   /*forever*/
