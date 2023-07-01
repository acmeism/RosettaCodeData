/*REXX program creates & draws an ASCII  Dragon Curve (or Harter-Heighway dragon curve).*/
d.= 1;   d.L= -d.;    @.= ' ';    x= 0;    x2= x;   y= 0;   y2= y;    z= d.;    @.x.y= "∙"
plot_pts = '123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZΘ' /*plot chars*/
loX= 0;     hiX= 0;     loY= 0;   hiY= 0         /*assign various constants & variables.*/
parse arg # p c .                                /*#:  number of iterations; P=init dir.*/
if #=='' | #==","  then #= 11                    /*Not specified?  Then use the default.*/
if p=='' | p==","  then p= 'north';     upper p  /* "      "         "   "   "     "    */
if c==''           then c= plot_pts              /* "      "         "   "   "     "    */
if length(c)==2    then c= x2c(c)                /*was a  hexadecimal  code specified?  */
if length(c)==3    then c= d2c(c)                /* "  "    decimal      "      "       */
p= translate( left(p, 1), 0123, 'NESW')          /*get the orientation for dragon curve.*/
$=                                               /*initialize the dragon curve to a null*/
    do #                                         /*create the start of a dragon curve.  */
    $= $'R'reverse( translate($, "RL", 'LR') )   /*append the rest of dragon curve.     */
    end   /*#*/                                  /* [↑]  append char, flip, and reverse.*/

  do j=1  for length($);     _= substr($, j, 1)  /*get next cardinal direction for curve*/
  p= (p + d._) // 4                              /*move dragon curve in a new direction.*/
  if p< 0  then p= p + 4                         /*Negative?  Then use a new direction. */
  if p==0  then do;  y= y + 1;  y2= y + 1;  end  /*curve is going  east  cartologically.*/
  if p==1  then do;  x= x + 1;  x2= x + 1;  end  /*  "    "       south         "       */
  if p==2  then do;  y= y - 1;  y2= y - 1;  end  /*  "    "        west         "       */
  if p==3  then do;  x= x - 1;  x2= x - 1;  end  /*  "    "       north         "       */
  if j>2**z  then z= z + 1                       /*identify a part of curve being built.*/
  != substr(c, z, 1)                             /*choose plot point character (glyph). */
  if !==' '  then != right(c, 1)                 /*Plot point a blank?  Then use a glyph*/
  @.x.y= !;            @.x2.y2= !                /*draw part of the  dragon curve.      */
  loX= min(loX,x,x2);  hiX= max(hiX,x,x2); x= x2 /*define the min & max  X  graph limits*/
  loY= min(loY,y,y2);  hiY= max(hiY,y,y2); y= y2 /*   "    "   "  "  "   Y    "     "   */
  end   /*j*/                                    /* [↑]  process all of  $  char string.*/
              do r=loX  to hiX;     a=           /*nullify the line that will be drawn. */
                do c=loY  to hiY;  a= a || @.r.c /*create a line (row) of curve points. */
                end   /*c*/                      /* [↑] append a single column of a row.*/
              if a\==''  then say strip(a, "T")  /*display a line (row) of curve points.*/
              end      /*r*/                     /*stick a fork in it,  we're all done. */
