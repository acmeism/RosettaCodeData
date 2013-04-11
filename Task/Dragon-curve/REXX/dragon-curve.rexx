/*REXX program to draw an ASCII Dragon Curve (or Harter-Heighway dragon)*/
d.=1;   d.L=-1;   @.=' ';   x=0;   x2=x;   y=0;   y2=y;   @.x.y='∙';   z=1
plot_pts='123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZΘ'
minx=0; maxx=0; miny=0; maxy=0         /*assign various constants & vars*/
parse arg # p c .                      /*#  is # iterations, P=init dir.*/
if #=='' | #==','  then #=11           /*Not specified?  Use the default*/
if p=='' | p==','  then p=0            /*Not specified?  Use the default*/
if c==''           then c=plot_pts     /*Not specified?  Use the default*/
if length(c)==2    then c=x2c(c)       /*hexadecimal code was specified?*/
if length(c)==3    then c=d2c(c)       /*    decimal   "   "      "    ?*/
$=                                     /*nullify the dragon curve string*/
        do  #                          /*create the dragon curve string.*/
        $=$'R'reverse(translate($,'RL','LR'))     /*append,flip,reverse.*/
        end   /*#*/
                                                  /*create dragon curve.*/
  do j=1  for length($);   _=substr($,j,1)        /*get  next direction.*/
  p=(p+d._)//4;    if p<0  then p=p+4             /*move in a direction.*/
  if p==0 then do; y=y+1;  y2=y+1; end            /*going east map-wise.*/
  if p==1 then do; x=x+1;  x2=x+1; end            /*  "  south    "     */
  if p==2 then do; y=y-1;  y2=y-1; end            /*  "   west    "     */
  if p==3 then do; x=x-1;  x2=x-1; end            /*  "  north    "     */
  if j>2**z  then z=z+1                           /*the curve being done*/
  !=substr(c,z,1);   if !==' '  then !=right(c,1) /*choose plot pt char.*/
  @.x.y=!;  @.x2.y2=!                             /*draw part of dragon.*/
  minx=min(minx,x,x2);  maxx=max(maxx,x,x2); x=x2 /*define graph limits.*/
  miny=min(miny,y,y2);  maxy=max(maxy,y,y2); y=y2 /*   "     "      "   */
  end   /*j*/
                                       /*display dragon curve on screen.*/
                do r=minx  to maxx; a= /*nullify the line to be drawn.  */
                    do c=miny  to maxy /*create a line (row) of points. */
                    a=a || @.r.c       /*build one column at a time.    */
                    end   /*c*/
                a=strip(a,'T')         /*be nice & strip trailing blanks*/
                if a\==''  then say a  /*display a line (row) of points.*/
                end       /*r*/
                                       /*stick a fork in it, we're done.*/
