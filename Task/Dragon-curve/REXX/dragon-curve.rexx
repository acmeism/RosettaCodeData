/*REXX program draws an ASCII  Dragon Curve  (or Harter-Heighway dragon curve)*/
z=1;   d.=1;   d.L=-d.;    @.=' ';    x=0;   x2=x;   y=0;    y2=y;     @.x.y='∙'
plot_pts = '123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZΘ'
minX=0;  maxX=0;   minY=0;  maxY=0     /*assign various constants & variables.*/
parse arg # p c .                      /*#:  number of iterations; P=init dir.*/
if #=='' | #==','  then #=11           /*Not specified?  Then use the default.*/
if p=='' | p==','  then p=0            /* "      "         "   "   "     "    */
if c==''           then c=plot_pts     /* "      "         "   "   "     "    */
if length(c)==2    then c=x2c(c)       /*was a hexadecimal code specified?    */
if length(c)==3    then c=d2c(c)       /* "  "   decimal     "      "    ?    */
$=                                     /*assign a null to dragon curve string.*/
        do  #                                     /* [↓]  create dragon curve.*/
        $=$'R'reverse(translate($, "RL", 'LR'))   /*append, flip, and reverse.*/
        end   /*#*/                               /* [↑]  TRANSLATE flips chrs*/
                                                  /* [↓]  create dragon curve.*/
  do j=1  for length($);     _=substr($, j, 1)    /*obtain the next direction.*/
     p=(p+d._)//4;   if p<0  then p=p+4           /*move curve in a direction.*/
  if p==0  then do;  y=y+1;  y2=y+1;  end         /*going  east cartologically*/
  if p==1  then do;  x=x+1;  x2=x+1;  end         /*  "   south       "       */
  if p==2  then do;  y=y-1;  y2=y-1;  end         /*  "    west       "       */
  if p==3  then do;  x=x-1;  x2=x-1;  end         /*  "   north       "       */
  if j>2**z  then z=z+1                           /*identify curve being built*/
  !=substr(c,z,1);   if !==' '  then !=right(c,1) /*choose the plot point char*/
  @.x.y=!;   @.x2.y2=!                            /*draw part of dragon curve.*/
  minX=min(minX,x,x2);  maxX=max(maxX,x,x2); x=x2 /*define the X graph limits.*/
  minY=min(minY,y,y2);  maxY=max(maxY,y,y2); y=y2 /*   "    "  Y   "     "    */
  end   /*j*/                                     /* [↑]  process all of $ str*/
                                       /* [↓]  display the dragon curve.      */
               do r=minX  to maxX;  a= /*nullify the line that will bee drawn.*/
                   do c=minY  to maxY  /*create a line (row) of curve points. */
                   a=a || @.r.c        /*add a single column of row at a time.*/
                   end   /*c*/
               a=strip(a, 'T')         /*be nice and strip any trailing blanks*/
               if a\==''  then say a   /*display a line (row) of curve points.*/
               end       /*r*/
                                       /*stick a fork in it,  we're all done. */
