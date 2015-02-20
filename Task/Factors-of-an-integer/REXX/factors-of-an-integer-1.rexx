/*REXX pgm displays divisors of  any  (negative/zero/positive) integers.*/
@.=left('',7);   @.1='{unity}';   @.2='[prime]'    /*unity & prime tags.*/
parse arg low high inc .                           /*get optional args. */
high=word(high low 20,1);  low=word(low 1,1);  inc=word(inc 1,1)  /*opts*/
w=length(high)+1;  numeric digits max(9,w)         /*'nuff digs for  // */
say center('n',1+w)  '#divisors'  center('divisors',60)     /*header.   */
say copies('─',1+w)  '─────────'  copies('─'       ,60)     /*separator.*/

     do n=low  to high  by inc;   divs=divisors(n);  #=words(divs);  p=@.#
     if divs=='infinite'  then #='∞';  if n<1  then p=@..   /*handle N<1*/
     say  right(n,w)" "    center('['#"]",9)    "──► "    p    ' '    divs
     end   /*n*/                       /* [↑]   process a range of ints.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────DIVISORS subroutine─────────────────*/
divisors: procedure; parse arg x;  x=abs(x);  if x==1  then return 1;  b=x
if x==0  then return 'infinite';   odd=x//2
a=1                                    /* [↓] use only EVEN|ODD integers*/
   do j=2+odd  by 1+odd  while j*j<x   /*divide by all integers up to √x*/
   if x//j==0  then do; a=a j; b=x%j b; end /*add divs to α&ß lists if ÷*/
   end   /*j*/                         /* [↑]  %  is REXX integer divide*/
                                       /* [↓]  adjust for square.     _ */
if j*j==x  then  return  a j b         /*Was X a square?  If so, add √x.*/
                 return  a   b         /*return divisors  (both lists). */
