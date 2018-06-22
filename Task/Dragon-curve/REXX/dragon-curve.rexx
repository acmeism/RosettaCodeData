/*REXX program creates & draws an ASCII  Dragon Curve (or Harter-Heighway dragon curve).*/
d.=1;    d.L=-d.;       @.=' ';   x=0;   x2=x;    y=0;   y2=y;      z=d.;        @.x.y="∙"
plot_pts = '123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZΘ' /*plot chars*/
minX=0;     maxX=0;     minY=0;   maxY=0         /*assign various constants & variables.*/
parse arg # p c .                                /*#:  number of iterations; P=init dir.*/
if #=='' | #==","  then #=11                     /*Not specified?  Then use the default.*/
if p=='' | p==","  then p= 'north';     upper p  /* "      "         "   "   "     "    */
if c==''           then c=plot_pts               /* "      "         "   "   "     "    */
if length(c)==2    then c=x2c(c)                 /*was a  hexadecimal  code specified?  */
if length(c)==3    then c=d2c(c)                 /* "  "    decimal      "      "       */
p=translate(left(p,1), 0123, 'NESW');   $=       /*get the orientation for dragon curve.*/
     do #; $=$'R'reverse(translate($,"RL",'LR')) /*create the start of a dragon curve.  */
     end   /*#*/                                 /*append char, flip,  and then reverse.*/
                                                 /* [↓]  create the rest of dragon curve*/
  do j=1  for length($);       _=substr($,j,1)   /*get next cardinal direction for curve*/
     p= (p+d._)//4;    if p<0  then p=p+4        /*move dragon curve in a new direction.*/
  if p==0  then do;    y=y+1;  y2=y+1;     end   /*curve is going  east  cartologically.*/
  if p==1  then do;    x=x+1;  x2=x+1;     end   /*  "    "       south         "       */
  if p==2  then do;    y=y-1;  y2=y-1;     end   /*  "    "        west         "       */
  if p==3  then do;    x=x-1;  x2=x-1;     end   /*  "    "       north         "       */
  if j>2**z  then z=z+1                          /*identify a part of curve being built.*/
  !=substr(c,z,1);  if !==' '  then !=right(c,1) /*choose plot point character (glyph). */
  @.x.y=!;   @.x2.y2=!                           /*draw part of the  dragon curve.      */
  minX=min(minX,x,x2); maxX=max(maxX,x,x2); x=x2 /*define the min & max  X  graph limits*/
  minY=min(minY,y,y2); maxY=max(maxY,y,y2); y=y2 /*   "    "   "  "  "   Y    "     "   */
  end  /*j*/                                     /* [↑]  process all of  $  char string.*/
             do r=minX  to maxX;    a=           /*nullify the line that will be drawn. */
                do c=minY  to maxY; a=a || @.r.c /*create a line (row) of curve points. */
                end   /*c*/                      /* [↑] append a single column of a row.*/
             if a\=''  then say strip(a, "T")    /*display a line (row) of curve points.*/
             end      /*r*/                      /*stick a fork in it,  we're all done. */
