/*REXX program  performs  long multiplication  on  two numbers  (without the "E").      */
numeric digits 300                               /*be able to handle gihugeic input #s. */
parse arg x y .                                  /*obtain optional arguments from the CL*/
if x=='' | x==","  then x=2**64                  /*Not specified?  Then use the default.*/
if y=='' | y==","  then y=x                      /* "      "         "   "   "     "    */
if x<0  &&  y<0    then sign= '-'                /*there only a single negative number? */
                   else sign=                    /*no, then result sign must be positive*/
xx=x;    x=strip(x, 'T', .);      x1=left(x, 1)  /*remove any trailing decimal points.  */
yy=y;    y=strip(y, 'T', .);      y1=left(y, 1)  /*   "    "     "        "       "     */
if x1=='-' | x1=="+"  then x=substr(x, 2)        /*remove a leading  ±  sign.           */
if y1=='-' | y1=="+"  then y=substr(y, 2)        /*   "   "    "     "    "             */
parse var x '.' xf;   parse var y "." yf         /*obtain the fractional part of X and Y*/
#=length(xf || yf)                               /*#: digits past the decimal points (.)*/
x=space( translate( x, , .),  0)                 /*remove decimal point if there is any.*/
y=space( translate( y, , .),  0)                 /*   "       "     "    "    "   "  "  */
Lx=length(x);  Ly=length(y)                      /*get the lengths of the new  X and Y. */
numeric digits max(digits(), Lx + Ly)            /*use a new  decimal digits  precision.*/
$=0                                              /*$:  is the product  (so far).        */
                  do j=Ly  by -1  for Ly         /*almost like REXX does it, ··· but no.*/
                  $=$ + ((x*substr(y, j, 1))copies(0, Ly-j) )
                  end   /*j*/
f=length($) - #                                  /*does product has enough decimal digs?*/
if f<0  then $=copies(0, abs(f) + 1)$            /*Negative?  Add leading 0s for INSERT.*/
say 'long mult:'  xx  "*"  yy  '──►'   sign || strip( insert(., $, length($) - #), 'T', .)
say ' built─in:'  xx  "*"  yy  '──►'   xx*yy     /*stick a fork in it,  we're all done. */
