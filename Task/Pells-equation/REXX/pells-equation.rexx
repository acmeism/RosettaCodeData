/*REXX program to solve Pell's equation for the smallest solution of positive integers. */
numeric digits 2200                              /*ensure enough decimal digs for answer*/
parse arg $                                      /*obtain optional arguments from the CL*/
if $=='' | $==","  then $= 61 109 181 277        /*Not specified?  Then use the defaults*/
d= 28                                            /*used for aligning the output numbers.*/
       do j=1  for words($);    #= word($, j)    /*process all the numbers in the list. */
       parse value   pells(#)   with   x  y      /*extract the two values of  X  and  Y.*/
       cx= comma(x);       Lcx= length(cx);           cy=  comma(y);       Lcy= length(cy)
       say 'x^2 -'right(#, max(4, length(#)))    "* y^2 == 1" ,
                    ' when x='right(cx, max(d, Lcx))     "  and y="right(cy, max(d, Lcy))
       end   /*j*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
comma: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?= insert(',', ?, jc); end;  return ?
floor: procedure; parse arg x;  _= x % 1;          return  _   -    (x < 0)   *   (x \= _)
/*──────────────────────────────────────────────────────────────────────────────────────*/
iSqrt: procedure; parse arg x;  r= 0;     q= 1;           do  while q<=x;  q= q * 4;   end
         do  while q>1; q= q%4; _= x-r-q; r= r%2; if _>=0  then do; x= _; r= r+q; end; end
       return r                                  /*R:  is the integer square root of X. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
pells: procedure; parse arg n; x= iSqrt(n);  y=x /*obtain arg;  obtain integer sqrt of N*/
       parse value  1 0   with   e1 e2  1  f2 f1 /*assign values for: E1, E2, and F2, F1*/
       z= 1;        r= x + x
                                         do  until ( (e2 + x*f2)**2  -  n*f2*f2)  ==  1
                                         y= r*z  -  y;     z= floor( (n - y*y) / z)
                                                           r= floor( (x + y  ) / z)
                                         parse value  e2   r*e2  +  e1     with     e1  e2
                                         parse value  f2   r*f2  +  f1     with     f1  f2
                                         end   /*until*/
       return e2  +  x * f2     f2
