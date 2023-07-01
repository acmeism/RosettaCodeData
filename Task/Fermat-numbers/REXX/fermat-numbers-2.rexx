/*REXX program to find and display  Fermat  numbers, and show factors of Fermat numbers.*/
parse arg n .                                    /*obtain optional argument from the CL.*/
if n=='' | n==","  then n= 9                     /*Not specified?  Then use the default.*/
numeric digits 200                               /*ensure enough decimal digits, for n=9*/

       do j=0  to n;   f= 2** (2**j)   +  1      /*calculate a series of Fermat numbers.*/
       say right('F'j, length(n) + 1)': '     f  /*display a particular     "      "    */
       end   /*j*/
say
       do k=5  to n;   f= 2** (2**k)   +  1; say /*calculate a series of Fermat numbers.*/
       say center(' F'k": " f' ', 79, "═")       /*display a particular     "      "    */
       a= rho(f)                                 /*factor a Fermat number,  given time. */
       b= f % a
       if a==b  then say f ' is prime.'
                else say 'factors:  '   commas(a)     " "     commas(b)
       end   /*k*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas:  parse arg _;  do ?=length(_)-3  to 1  by -3; _=insert(',', _, ?); end;   return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
rho:  procedure;  parse arg n;    y= 2;  d= 1    /*initialize  X, Y,  and  D  variables.*/
        do x=2  until d==n                       /*try rho method with X=2 for 1st time.*/
          do    while d==1
          x= (x*x + 1) // n
          v= (y*y + 1) // n
          y= (v*v + 1) // n
          parse value  x-y   with  xy  1  sig  2 /*obtain sign of the  x-y  difference. */
          if sig=='-'  then parse var  xy  2  xy /*Negative?   Then use absolute value. */
          nn= n
                do  until nn==0
                parse value xy//nn nn with nn xy /*assign two variables:   NN  and  XY  */
                end   /*until*/                  /*this is an  in-line   GCD  function. */
          d= xy                                  /*assign variable   D   with a new  XY */
          end   /*while*/
        end     /*x*/
      return d                                   /*found a factor of  N.      Return it.*/
