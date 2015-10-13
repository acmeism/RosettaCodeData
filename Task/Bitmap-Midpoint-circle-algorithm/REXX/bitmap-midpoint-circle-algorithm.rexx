/*REXX program plots three circles using midpoint/Bresenham's circle algorithm*/
@.  = '·'                              /*fill the array with middle─dots char.*/
minX=0;   maxX=0;    minY=0;   maxY=0  /*initialize the minimums and maximums.*/
call drawCircle   0,   0,   8,   '#'   /*plot 1st circle with pound character.*/
call drawCircle   0,   0,  11,   '$'   /*  "  2nd    "     "  dollar    "     */
call drawCircle   0,   0,  19,   '@'   /*  "  3rd    "     "  commercial at.  */
border=2                               /*BORDER:  shows  N  extra grid points.*/
minX=minX-border*2; maxX=maxX+border*2 /*adjust min and max  X  to show border*/
minY=minY-border  ; maxY=maxY+border   /*   "    "   "   "   Y   "   "     "  */
if @.0.0==@.  then @.0.0='┼'           /*maybe define the plot's axis origin. */
                                       /*define the plot's horizontal grid──┐ */
  do h=minX  to maxX;  if @.h.0==@.  then @.h.0='─';  end    /* ◄───────────┘ */
  do v=minY  to maxY;  if @.0.v==@.  then @.0.v='│';  end    /* ◄──────────┐  */
                                       /*define the plot's vertical grid───┘  */
     do y=maxY  by -1  to minY;  aRow= /* [↓]  draw grid from  top ──► bottom.*/
                do x=minX  to maxX     /* [↓]    "    "    "  left ──► right. */
                aRow=aRow || @.x.y     /*build a grid row, one char at a time.*/
                end   /*x*/            /* [↑]  a grid row should be finished. */
     say aRow                          /*display a single row of the grid.    */
     end              /*y*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
drawCircle: procedure expose @. minX maxX minY maxY  /* [↓]  Y is defined as R*/
parse arg xx,yy,r 1 y,plotChar; f=1-r; fx=1; fy=-2*r /*get the X,Y coördinates*/

          do x=0  while  x<y  /*▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒*/
          if f>=0  then  do;  y=y-1;  fy=fy+2;  f=f+fy;  end               /*▒*/
                                      fx=fx+2;  f=f+fx                     /*▒*/
          call plotPoint  xx+x,  yy+y                                      /*▒*/
          call plotPoint  xx+y,  yy+x                                      /*▒*/
          call plotPoint  xx+y,  yy-x                                      /*▒*/
          call plotPoint  xx+x,  yy-y                                      /*▒*/
          call plotPoint  xx-y,  yy+x                                      /*▒*/
          call plotPoint  xx-x,  yy+y                                      /*▒*/
          call plotPoint  xx-x,  yy-y                                      /*▒*/
          call plotPoint  xx-y,  yy-x                                      /*▒*/
          end   /*x*/         /* [↑]  place plot points ══► plot.▒▒▒▒▒▒▒▒▒▒▒▒▒*/
return
/*────────────────────────────────────────────────────────────────────────────*/
plotPoint: parse arg c,r; @.c.r=plotChar   /*assign a character to be plotted.*/
minX=min(minX,c);   maxX=max(maxX,c)       /*find the minimum and maximum  X. */
minY=min(minY,r);   maxY=max(maxY,r)       /*  "   "     "     "     "     Y. */
return
