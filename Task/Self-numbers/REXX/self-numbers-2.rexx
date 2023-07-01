/*REXX pgm displays the  Nth  self number, aka Colombian or Devlali numbers. OEIS A3052.*/
numeric digits 20                                /*ensure enough decimal digits for #.  */
parse arg high .                                 /*obtain optional argument from the CL.*/
if high=='' | high==","  then high= 10000000     /*Not specified?  Then use 10M default.*/
i= 1;   pow= 10;   digs= 1;    offset= 9;   $= 0 /*$:  the last self number found.      */
#= 0                                             /*count of self numbers  (so far).     */
     do while #<high;          isSelf= 1         /*assume a self number   (so far).     */
     start= max(i-offset, 0)                     /*find start #;  must be non-negative. */
     sum= sumDigs(start)                         /*obtain the sum of the decimal digits.*/

        do j=start  to i-1
        if j+sum==i  then do;  isSelf= 0         /*found a   non  self number.          */
                               iterate           /*keep looking for more self numbers.  */
                          end
        if (j+1)//10==0   then sum= sumDigs(j+1) /*obtain the sum of the decimal digits.*/
                          else sum= sum + 1      /*bump    "   "   "  "     "      "    */
        end   /*j*/

     if isSelf  then do;  #= # + 1               /*bump the count of self numbers.      */
                          $= i                   /*save the last self number found.     */
                     end
     i= i + 1                                    /*bump the self number by unity.       */
     if i//pow==0  then do;    digs= digs + 1    /*  "   "  number of decimal digits.   */
                                pow= pow * 10    /*  "   "  power   " a factor of ten.  */
                             offset= digs * 9    /*  "   "  offset  " "    "    " nine. */
                        end
     end   /*while*/
say
say 'the '   commas(high)th(high)     " self number is: "     commas($)
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sumDigs: parse arg s 2 x;   do k=1  for length(x)   /*get 1st dig,  & also get the rest.*/
                            s= s + substr(x, k, 1)  /*add a particular digit to the sum.*/
                            end  /*k*/;  return s
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas:  parse arg _;  do c=length(_)-3  to 1  by -3; _=insert(',', _, c); end;   return _
th:      parse arg th; return word('th st nd rd', 1 +(th//10)*(th//100%10\==1)*(th//10<4))
