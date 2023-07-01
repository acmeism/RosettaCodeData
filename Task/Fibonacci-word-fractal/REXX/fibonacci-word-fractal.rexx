/*REXX program generates a Fibonacci word,  then (normally) displays the  fractal curve.*/
parse arg order .                                /*obtain optional arguments from the CL*/
if order=='' | order==","  then order= 23        /*Not specified?   Then use the default*/
tell=  order>=0                                  /*Negative order?  Then don't display. */
s= FibWord( abs(order) )                         /*obtain the  order  of Fibonacci word.*/
                          x= 0;       maxX= 0;    dx= 0;    b= ' ';     @.   = b;    xp= 0
                          y= 0;       maxY= 0;    dy= 1;                @.0.0= .;    yp= 0
  do n=1  for length(s);  x= x + dx;  y= y + dy  /*advance the plot for the next point. */
  maxX= max(maxX, x);     maxY= max(maxY, y)     /*set the maximums for displaying plot.*/
                  c= '│'                         /*glyph (character) used for the plot. */
  if dx\==0  then c= "─"                         /*if  x+dx   isn't zero, use this char.*/
  if n==1    then c= '┌'                         /*is this the first part to be graphed?*/
  @.x.y= c                                       /*assign a plotting character for curve*/
  if @(xp-1, yp)\==b  then if  @(xp, yp-1)\==b  then call @ xp,yp,'┐'  /*fix─up a corner*/
  if @(xp-1, yp)\==b  then if  @(xp, yp+1)\==b  then call @ xp,yp,'┘'  /*   "   "    "  */
  if @(xp+1, yp)\==b  then if  @(xp, yp-1)\==b  then call @ xp,yp,'┌'  /*   "   "    "  */
  if @(xp+1, yp)\==b  then if  @(xp, yp+1)\==b  then call @ xp,yp,'└'  /*   "   "    "  */
  xp= x;     yp= y                               /*save the old   x  &  y   coördinates.*/
  z= substr(s, n, 1)                             /*assign a plot character for the graph*/
  if z==1    then iterate                        /*Is Z equal to unity?  Then ignore it.*/
  ox= dx;    oy= dy                              /*save    DX,DY   as the old versions. */
  dx= 0;     dy= 0                               /*define  DX,DY    "  "  new     "     */
  d= -n//2;         if d==0  then d= 1           /*determine the sign for the chirality.*/
  if oy\==0  then dx= -sign(oy) * d              /*Going  north│south?   Go  east|west  */
  if ox\==0  then dy=  sign(ox) * d              /*  "     east│west?     " south|north */
  end   /*n*/

call @  x, y, '∙'                                /*set the last point that was plotted. */

       do r=maxY   to 0  by -1;  _=              /*show single row at a time, top first.*/
          do c=0  for maxX+1;    _= _  ||  @.c.r /*add a plot character (glyph) to line.*/
          end   /*c*/                            /* [↑]  construct a line char by char. */
       _= strip(_, 'T')                          /*construct a line of the graph.       */
       if _==''  then iterate                    /*Is the line blank?   Then ignore it. */
       if tell  then say _                       /*Display the line to the terminal ?   */
       call lineout "FIBFRACT.OUT", _            /*write graph to disk  (FIBFRACT.OUT). */
       end      /*r*/                            /* [↑]  only display the non-blank rows*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
@: parse arg xx,yy,p;     if arg(3)==''  then return @.xx.yy;     @.xx.yy= p;       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
FibWord: procedure; parse arg x; !.= 0;   !.1= 1 /*obtain the order of  Fibonacci word. */
                    do k=3  to x                 /*generate the   Kth       "       "   */
                           k1= k-1;    k2= k - 2 /*calculate the  K-1  &  K-2  shortcut.*/
                    !.k= !.k1    ||  !.k2        /*construct the next   Fibonacci word. */
                    end   /*k*/                  /* [↑]  generate a         "       "   */
         return !.x                              /*return the    Xth        "       "   */
