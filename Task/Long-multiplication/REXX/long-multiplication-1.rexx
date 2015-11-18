/*REXX program performs long multiplication on two numbers  (without the "E").*/
numeric digits 3000                    /*be able to handle gihugeic input #s. */
parse arg x y .                        /*obtain the optional  one or two  #s. */
if x==''  then x=2**64                 /*Not specified?  Then use the default.*/
if y==''  then y=x                     /* "      "         "   "   "     "    */
if x<0  &&  y<0  then sign='-'         /*there only a single negative number? */
                 else sign=            /*no, then result sign must be positive*/
xx=x;   x=strip(x, 'T', .)             /*remove any trailing decimal points.  */
yy=y;   y=strip(y, 'T', .)             /*   "    "     "        "       ".    */
_=left(x,1);  if _=='-' | _=='+'  then x=substr(x,2)   /*elide leading ± signs*/
_=left(y,1);  if _=='-' | _=='+'  then y=substr(y,2)   /*  "      "    "   "  */
dp=0;   Lx=length(x);  Ly=length(y)    /*get the lengths of the new  X and Y. */
f=pos(., x); if f\==0  then dp=   Lx-f /*calculate size of decimal fraction.  */
f=pos(., y); if f\==0  then dp=dp+Ly-f /*    "       "   "    "        "      */
x=space(translate(x, , .), 0)          /*remove decimal point if there is any.*/
y=space(translate(y, , .), 0)          /*   "       "     "    "    "   "  "  */
Lx=length(x);  Ly=length(y)            /*get the lengths of the new  X and Y. */
numeric digits max(digits(), Lx+Ly)    /*use a new  decimal digits  precision.*/
$=0                                    /*P:  is the product  (so far).        */
               do j=Ly  by -1  for Ly  /*almost like REXX does it, ··· but no.*/
               $=$ + ((x*substr(y, j, 1))copies(0, Ly-j) )
               end   /*j*/
f=length($)-dp                         /*does product has enough decimal digs?*/
if f<0  then $=copies(0, abs(f)+1)$    /*Negative?  Add leading 0s for INSERT.*/
say ' built─in:'  xx  '*'  yy  '──►' xx*yy
say 'long mult:'  xx  '*'  yy  '──►' sign||strip(insert(.,$,length($)-dp),'T',.)
                                       /*stick a fork in it,  we're all done. */
