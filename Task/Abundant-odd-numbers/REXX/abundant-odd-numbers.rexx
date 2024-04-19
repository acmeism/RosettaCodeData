/*REXX pgm displays abundant odd numbers:  1st 25, one-thousandth, first > 1 billion. */
parse arg Nlow Nuno Novr .                       /*obtain optional arguments from the CL*/
if Nlow=='' | Nlow==','  then Nlow=          25  /*Not specified?  Then use the default.*/
if Nuno=='' | Nuno==','  then Nuno=        1000  /* '      '         '   '   '     '    */
if Novr=='' | Novr==','  then Novr=  1000000000  /* '      '         '   '   '     '    */
numeric digits max(9,length(Novr))             /*ensure enough decimal digits for  // */
a= 'odd abundant number'                         /*variable for annotating the output.  */
n= 0                                             /*count of odd abundant numbers so far.*/
do j=3 by 2 until n>=Nlow;     /*get the  sigma  for an odd integer.  */
  d=sigO(j)
  if d>j then Do                          /*sigma  =  J ?    Then ignore it.     */
    n= n + 1                                   /*bump the counter for abundant odd n's*/
    say rt(th(n)) a 'is:'rt(commas(j),8) rt('sigma=') rt(commas(d),9)
    End
  end  /*j*/
say
n= 0                                             /*count of odd abundant numbers so far.*/
do j=3  by 2;                    /*get the  sigma  for an odd integer.  */
  d= sigO(j)
  if d>j    then do                    /*sigma  =  J ?    Then ignore it.     */

    n= n + 1                                   /*bump the counter for abundant odd n's*/
    if n>=Nuno  then do                         /*Odd abundantn count<Nuno?  Then skip.*/
      say rt(th(n)) a 'is:'rt(commas(j),8) rt('sigma=') rt(commas(d),9)
      leave                                      /*we're finished displaying NUNOth num.*/
      End
    End
  end  /*j*/
say
do j=1+Novr%2*2  by 2;           /*get sigma for an odd integer > Novr. */
  d= sigO(j)
  if d>j    then Do                     /*sigma  =  J ?    Then ignore it.     */
      say rt(th(1)) a 'over' commas(Novr) 'is: ' commas(j) rt('sigma=') commas(d)
  Leave                                      /*we're finished displaying NOVRth num.*/
    End
  end  /*j*/
exit
/*--------------------------------------------------------------------------------------*/
commas:parse arg _;  do c_=length(_)-3  to 1  by -3; _=insert(',',_,c_);  end;  return _
rt: procedure; parse arg n,len; if len=='' then len=20; return right(n,len)
th: parse arg th; return th||word('th st nd rd',1+(th//10)*(th//100%10\==1)*(th//10<4))
/*--------------------------------------------------------------------------------------*/
sigO: parse arg x;                          /*sigma for odd integers.           ___*/
  s=1
  do k=3 by 2 while k*k<x           /*divide by all odd integers up to v x */
    if x//k==0  then
      s= s + k + x%k    /*add the two divisors to (sigma) sum. */
    end   /*k*/                         /*                                  ___*/
  if k*k==x then
    return s + k             /*Was  X  a square?    If so,add  v x */
  return s                 /*return (sigma) sum of the divisors.  */
