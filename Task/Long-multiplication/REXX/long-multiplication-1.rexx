/*REXX program performs long multiplication on two numbers (without 'E')*/
numeric digits 100;   d='.'            /*be able to handle input numbers*/
parse arg x y .                        /*accept the (possible) two nums.*/
if x==''  then x=2**64                 /*Not specified?  Use the default*/
if y==''  then y=x                     /* "      "        "   "     "   */
if x<0  &&  y<0  then sgn='-'          /*only one argument is negative? */
                 else sgn=             /*no, then the sign is positive. */
xx=x;   x=strip(x,'T',d)               /*remove any trailing decimal pt.*/
yy=y;   y=strip(y,'T',d)               /*   "    "     "        "     ".*/
_=left(x,1);  if _=='-' | _=='+'  then x=substr(x,2)  /*remove leading ±*/
_=left(y,1);  if _=='-' | _=='+'  then y=substr(y,2)  /*   "      "    "*/
                                       /*[↑] above code for a Regina bug*/
                                       /*otherwise: x=abs(x)  will do it*/
dp=0;  Lx=length(x);  Ly=length(y)     /*get the lengths of new X and Y.*/
f=pos(d,x); if f\==0  then dp=   Lx-f  /*calculate size of dec fraction.*/
f=pos(d,y); if f\==0  then dp=dp+Ly-f  /*    "       "   "  "      "    */
x=space(translate(x,,d),0)             /*remove decimal point, if any.  */
y=space(translate(y,,d),0)             /*   "       "     "     "  "    */
Lx=length(x);  Ly=length(y)            /*get the lengths of new X and Y.*/
numeric digits max(digits(),Lx+Ly)
p=0                                    /*the product so far.            */
          do j=Ly  by -1  for Ly       /*almost like REXX does it,but no*/
          p=p+((x*substr(y,j,1))copies(0,Ly-j))
          end   /*j*/
say
f=length(p)-dp                         /*does product has enough digits?*/
if f<0  then p=copies(0,abs(f)+1)p     /*Neg?  Add leading 0s for INSERT*/
say ' built-in:' xx '*' yy '=' xx*yy
say 'long mult:' xx '*' yy '=' sgn ||strip(insert(d,p,length(p)-dp),'T',d)
                                       /*stick a fork in it, we're done.*/
