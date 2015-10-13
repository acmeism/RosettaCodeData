/*REXX program generates a  Fibonacci word,  then displays the  fractal curve.*/
parse arg ord .                        /*obtain optional arguments from the CL*/
if ord==''  then ord=23                /*Not specified?   Then use the default*/
s=FibWord(ord)                         /*obtain the  order  of Fibonacci word.*/
                                x=0;   maxX=0;   dx=0;   b=' ';     @.=b;   xp=0
                                y=0;   maxY=0;   dy=1;           @.0.0=.;   yp=0
  do n=1 for length(s); x=x+dx; y=y+dy /*advance the plot for the next point. */
  maxX=max(maxX,x);  maxY=max(maxY,y)  /*set the maximums for displaying plot.*/
  c='│';  if dx\==0  then c='─';      if n==1  then c='┌'      /*The 1st plot?*/
  @.x.y=c                              /*assign a plotting character for curve*/
  if @(xp-1,yp)\==b  &  @(xp,yp-1)\==b  then call  @ xp,yp,'┐'   /*fix-up.*/
  if @(xp-1,yp)\==b  &  @(xp,yp+1)\==b  then call  @ xp,yp,'┘'   /*   "   */
  if @(xp+1,yp)\==b  &  @(xp,yp+1)\==b  then call  @ xp,yp,'└'   /*   "   */
  if @(xp+1,yp)\==b  &  @(xp,yp-1)\==b  then call  @ xp,yp,'┌'   /*   "   */
  xp=x;  yp=y;  z=substr(s,n,1)        /*save old x,y;  assign plot character.*/
  if z==1  then iterate                /*Is Z equal to unity?  Then ignore it.*/
  ox=dx;  oy=dy;     dx=0;  dy=0       /*save   DX,DY   as the old versions.  */
  d=-n//2;  if d==0  then d=1          /*determine the sign for the chirality.*/
  if oy\==0  then dx=-sign(oy)*d       /*Going  north|south?   Go  east|west  */
  if ox\==0  then dy= sign(ox)*d       /*  "     east|west?     " south|north */
  end   /*n*/

call @ x,y,'∙'                         /*set the last point that was plotted. */
      do r=maxY   to 0  by -1;  _=     /*show single row at a time, top first.*/
        do c=0  to maxX;        _=_ || @.c.r;     end  /*c*/
      if _\=''  then say strip(_,'T')  /*if not blank, then display a line.   */


      if _\=''  then call lineout 'FIBFRACT.OUT',strip(_,'T')  /*write to file*/


      end   /*r*/                      /* [↑]  only display the non-blank rows*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
@: parse arg xx,yy,p;   if arg(3)==''  then return @.xx.yy;  @.xx.yy=p;   return
/*────────────────────────────────────────────────────────────────────────────*/
FibWord: procedure; arg x; !.=0; !.1=1 /*obtain the order of  Fibonacci word. */
          do k=3  to x; k1=k-1; k2=k-2 /*generate the   Kth   Fibonacci word. */
          !.k=!.k1 || !.k2             /*construct the next   Fibonacci word. */
          end   /*k*/                  /* [↑]  generate a     Fibonacci word. */
return !.x                             /*return the    Xth    Fibonacci word. */
