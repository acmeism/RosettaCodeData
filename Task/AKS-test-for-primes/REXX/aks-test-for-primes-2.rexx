/*REXX pgm calculates primes via the Agrawal-Kayal-Saxena (AKS) primality test*/
parse arg Z .;   if Z==''  then Z=200  /*Z  not specified?   Then use default.*/
OZ=Z;   tell=Z<0;   Z=abs(Z)           /*Is Z negative?  Then show expression.*/
numeric digits max(9,Z%3)              /*define a dynamic # of decimal digits.*/
$.0='-';      $.1="+";         @.=1    /*$.x: sign char; default coefficients.*/
#=                                     /*define list of prime numbers (so far)*/
  do p=3  for Z;      pm=p-1;  pp=p+1  /*PM & PP: used as a coding convenience*/
      do m=2  for pp%2-1;      mm=m-1  /*calculate coefficients for a power.  */
      @.p.m=@.pm.mm + @.pm.m;  h=pp-m  /*calculate left  side of  coefficients*/
      @.p.h=@.p.m                      /*    "     right   "   "       "      */
      end   /*m*/                      /* [↑]  The  M  DO loop creates both   */
  end       /*p*/                      /*      sides in the same loop, saving */
                                       /*      a bunch of execution time.     */
if tell  then say  '(x-1)^0:  1'       /*possibly display the first expression*/
                                       /* [↓]  test for primality by division.*/
  do n=2  for Z;     nh=n%2;    d=n-1  /*create expressions;  find the primes.*/
      do k=3  to nh  while @.n.k//d==0 /*are coefficients divisible by  N-1 ? */
      end   /*k*/                      /* [↑]  skip the 1st & 2nd coefficients*/
                                       /* [↓]  multiple THEN─IF faster than &s*/
  if d\==1  then if d\==4 then if k>nh then #=# d  /*add number to prime list.*/
  if \tell  then iterate               /*Don't tell?   Don't show expressions.*/
  y='(x-1)^'d": "                      /*define first part of the expression. */
  s=1                                  /*S:     is the sign indicator (-1│+1).*/
      do j=n  to 2  by -1              /*create the higher powers first.      */
      if j==2  then xp='x'             /*if power=1, then don't show the power*/
               else xp='x^' || (j-1)   /*        ··· else show power with  ^  */
      if j==n  then y=y xp             /*no sign (+│-) for the 1st expression.*/
               else y=y $.s @.n.j'∙'xp /*build the expression with sign (+|-).*/
      s=\s                             /*flip the sign for the next expression*/
      end   /*j*/                      /* [↑]  the sign (now) is either 0 │ 1,*/
                                       /*      and is displayed either  - │ + */
  say  y  $.s  1                       /*just show the first  N  expressions, */
  end       /*n*/                      /* [↑]  ··· but only for  negative  Z. */
                           say         /* [↓]  Has Z a leading + ?  Then show.*/
is="isn't";  if Z==word(. #,words(#)+1)  then is='is' /*is  or  isn't a prime.*/
if left(OZ,1)=='+'  then say  Z  is  'prime.'         /*tell if  OZ  has a +. */
                    else say 'primes:'  #             /*display prime # list. */
say                                                   /* [↓]  size of big 'un.*/
say 'Found '     words(#)      ' primes and the largest coefficient has' ,
    length(@.pm.h)  "decimal digits."  /*stick a fork in it,  we're all done. */
