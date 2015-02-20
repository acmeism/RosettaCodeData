/*REXX pgm plots 3 circles using midpoint/Bresenham's circle algorithm. */
@.  = '·'                              /*fill the array with middle-dots*/
minX=0;   maxX=0;    minY=0;   maxY=0  /*initialize minimums & maximums.*/
call drawCircle   0,   0,   8,   '#'   /*plot 1st circle with pound char*/
call drawCircle   0,   0,  11,   '$'   /*  "  2nd    "     "  dollar  " */
call drawCircle   0,   0,  19,   '@'   /*  "  3rd    "     "  commer. at*/
border=2                               /*BORDER:  shows N extra grid pts*/
minX=minX-border*2; maxX=maxX+border*2 /*adjust min&max X to show border*/
minY=minY-border  ; maxY=maxY+border   /*   "    "   "  Y  "   "     "  */
if @.0.0==@.  then @.0.0='┼'           /*maybe define plot's axis origin*/
                                       /* [↓]  define horizontal grid.  */
  do gx=minX  to maxX;    if @.gx.0==@.  then @.gx.0='─';    end  /*gx*/
  do gy=minY  to maxY;    if @.0.gy==@.  then @.0.gy='│';    end  /*gy*/
                                       /* [↑]  define the vertical grid.*/
     do y=maxY  by -1  to minY;  aRow= /* [↓] draw grid from top to bot.*/
                do x=minX  to maxX     /* [↓]   "    "    " left──►right*/
                aRow=aRow || @.x.y     /*build a grid row, char by char.*/
                end   /*x*/            /* [↑]  a grid row should be done*/
     say aRow                          /*display signal row of the grid.*/
     end              /*y*/
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────────DRAWCIRCLE subroutine──────────────*/
drawCircle: procedure expose @. minX maxX minY maxY
parse arg xx,yy,r,plotChar;          f=1-r;     fx=1;     fy=-2*r;     y=r

          do x=0  while  x<y  /*════════════════════════════════════════*/
          if f>=0  then  do;  y=y-1;  fy=fy+2;  f=f+fy;  end
                                      fx=fx+2;  f=f+fx
          call plotPoint  xx+x,  yy+y,   plotChar
          call plotPoint  xx+y,  yy+x,   plotChar
          call plotPoint  xx+y,  yy-x,   plotChar
          call plotPoint  xx+x,  yy-y,   plotChar
          call plotPoint  xx-y,  yy+x,   plotChar
          call plotPoint  xx-x,  yy+y,   plotChar
          call plotPoint  xx-x,  yy-y,   plotChar
          call plotPoint  xx-y,  yy-x,   plotChar
          end   /*x*/                  /* [↑] place plot points ══► plot*/
return
/*──────────────────────────────────PLOTPOINT subroutine────────────────*/
plotPoint: procedure expose @. minX maxX minY maxY
parse arg xx,yy,@.xx.yy;       minX=min(minX,xx);        maxX=max(maxX,xx)
                               minY=min(minY,yy);        maxY=max(maxY,yy)
return
