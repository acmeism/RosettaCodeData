/*REXX program generates a Fibonacci word, then plots the fractal curve.*/
parse arg ord .                        /*obtain optional arg from the CL*/
if ord==''  then ord=23                /*Not specified? Then use default*/
s=fibWord(ord)                         /*obtain the   ORD   fib word.   */
x=0; y=0;  maxX=0; maxY=0;  dx=0; dy=1;  @.=' ';  xp=0;  yp=0;  @.0.0=.

  do n=1 for length(s); x=x+dx; y=y+dy /*advance the plot for next point*/
  maxX=max(maxX,x);  maxY=max(maxY,y)  /*set the maximums for displaying*/
  c='│';  if dx\==0  then c='─';       if n==1  then c='┌'   /*1st plot.*/
  @.x.y=c                              /*assign a plotting character.   */
  if @(xp-1,yp)\==' ' & @(xp,yp-1)\==' '  then call @ xp,yp,'┐'  /*fixup*/
  if @(xp-1,yp)\==' ' & @(xp,yp+1)\==' '  then call @ xp,yp,'┘'  /*  "  */
  if @(xp+1,yp)\==' ' & @(xp,yp+1)\==' '  then call @ xp,yp,'└'  /*  "  */
  if @(xp+1,yp)\==' ' & @(xp,yp-1)\==' '  then call @ xp,yp,'┌'  /*  "  */
  xp=x;  yp=y;  z=substr(s,n,1)        /*save old x,y;  assign plot char*/
  if z==1  then iterate                /*if Z is a "one",  then skip it.*/
  ox=dx;  oy=dy;    dx=0;  dy=0        /*save DX,DY as the old versions.*/
  d=-n//2;  if d==0  then d=1          /*determine sign for chirality.  */
  if oy\==0  then dx=-sign(oy)*d       /*Going north|south? Go east|west*/
  if ox\==0  then dy= sign(ox)*d       /*  "   east|west?  " south|north*/
  end   /*n*/

call @ x,y,'∙'                         /*signify the last point plotted.*/
      do r=maxY   to 0  by -1;  _=     /*show a row at a time,  top 1st.*/
        do c=0  to maxX;  _=_||@.c.r;  end  /*c*/
      if _\=''  then say strip(_,'T')  /*if not blank, then show a line.*/
      end   /*r*/                      /* [↑]  only show non-blank rows.*/
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────@ subroutine─────────────────────────*/
@: parse arg xx,yy,p; if arg(3)=='' then return @.xx.yy; @.xx.yy=p; return
/*─────────────────────────────────FIBWORD subroutine───────────────────*/
fibWord: procedure; arg x; !.=0; !.1=1 /*obtain the order of  fib word. */
          do k=3  to x; k1=k-1; k2=k-2 /*generate the Kth Fibonacci word*/
          !.k=!.k1 || !.k2             /*construct the next FIB word.   */
          end   /*k*/                  /* [↑]  generate Fibonacci words.*/
return !.x                             /*return the   Xth   fib word.   */
