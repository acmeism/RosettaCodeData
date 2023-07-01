/*REXX pgm displays abundant odd numbers:  1st 25,  one─thousandth,  first > 1 billion. */
parse arg Nlow Nuno Novr .                       /*obtain optional arguments from the CL*/
if Nlow=='' | Nlow==","  then Nlow=          25  /*Not specified?  Then use the default.*/
if Nuno=='' | Nuno==","  then Nuno=        1000  /* "      "         "   "   "     "    */
if Novr=='' | Novr==","  then Novr=  1000000000  /* "      "         "   "   "     "    */
numeric digits max(9, length(Novr) )             /*ensure enough decimal digits for  // */
@= 'odd abundant number'                         /*variable for annotating the output.  */
#= 0                                             /*count of odd abundant numbers so far.*/
      do j=3  by 2  until #>=Nlow;   $= sigO(j)  /*get the  sigma  for an odd integer.  */
      if $<=j  then iterate                      /*sigma  ≤  J ?    Then ignore it.     */
      #= # + 1                                   /*bump the counter for abundant odd #'s*/
      say rt(th(#))     @      'is:'rt(commas(j), 8)     rt("sigma=")     rt(commas($), 9)
      end  /*j*/
say
#= 0                                             /*count of odd abundant numbers so far.*/
      do j=3  by 2;                  $= sigO(j)  /*get the  sigma  for an odd integer.  */
      if $<=j    then iterate                    /*sigma  ≤  J ?    Then ignore it.     */
      #= # + 1                                   /*bump the counter for abundant odd #'s*/
      if #<Nuno  then iterate                    /*Odd abundant# count<Nuno?  Then skip.*/
      say rt(th(#))     @      'is:'rt(commas(j), 8)     rt("sigma=")     rt(commas($), 9)
      leave                                      /*we're finished displaying NUNOth num.*/
      end  /*j*/
say
      do j=1+Novr%2*2  by 2;         $= sigO(j)  /*get sigma for an odd integer > Novr. */
      if $<=j    then iterate                    /*sigma  ≤  J ?    Then ignore it.     */
      say rt(th(1))   @  'over'  commas(Novr)  "is: "   commas(j)  rt('sigma=')  commas($)
      leave                                      /*we're finished displaying NOVRth num.*/
      end  /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas:parse arg _;  do c_=length(_)-3  to 1  by -3; _=insert(',', _, c_);  end;  return _
rt:    procedure;  parse arg #,len;     if len==''  then len= 20;     return right(#, len)
th:    parse arg th; return th||word('th st nd rd',1+(th//10)*(th//100%10\==1)*(th//10<4))
/*──────────────────────────────────────────────────────────────────────────────────────*/
sigO:  parse arg x;            s= 1              /*sigma for odd integers.           ___*/
             do k=3  by 2  while k*k<x           /*divide by all odd integers up to √ x */
             if x//k==0  then  s= s + k + x%k    /*add the two divisors to (sigma) sum. */
             end   /*k*/                         /*                                  ___*/
       if k*k==x  then  return s + k             /*Was  X  a square?    If so, add  √ x */
                        return s                 /*return (sigma) sum of the divisors.  */
