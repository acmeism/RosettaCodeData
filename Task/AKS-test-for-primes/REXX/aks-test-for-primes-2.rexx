/*REXX program calculates  primes  via the  Agrawal─Kayal─Saxena  (AKS)  primality test.*/
parse arg Z .; if Z=='' | Z=="," then Z=200      /*Z  not specified?   Then use default.*/
OZ=Z;             tell= Z<0;          Z=abs(Z)   /*Is Z negative?  Then show expression.*/
numeric digits  max(9,  Z % 3)                   /*define a dynamic # of decimal digits.*/
call AKS                                         /*invoke the AKS funtion for coef. bld.*/
if left(OZ,1)=='+' then do; say Z isAksp(); exit /*display if  Z  is  or isn't  a prime.*/
                        end                      /* [↑]  call isAKSp if Z has leading +.*/
say;    say "primes found:"   #                  /*display the  prime number  list.     */
say;    if \datatype(#, 'W')  then exit          /* [↓]  the digit length of a big coef.*/
say 'Found '   words(#)   " primes and the largest coefficient has "   length(@.pm.h)  @dd
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isAKSp: if z==word(#,words(#))  then return ' is a prime.';  else return " isn't a prime."
/*──────────────────────────────────────────────────────────────────────────────────────*/
AKS: $.0= '-';      $.1= "+";           @.=1     /*$.x: sign char; default coefficients.*/
     q.=1;          q.1=0;              q.4=0    /*sparse array for faster comparisons. */
     #=;            L= length(Z)                 /*define list of prime numbers (so far)*/
        do p=3  for Z;      pm=p - 1;   pp=p + 1 /*PM & PP: used as a coding convenience*/
            do m=2  for pp % 2   - 1;   mm=m - 1 /*calculate coefficients for a power.  */
            @.p.m= @.pm.mm + @.pm.m;    h=pp - m /*calculate left  side of  coefficients*/
            @.p.h= @.p.m                         /*    "     right   "   "       "      */
            end   /*m*/                          /* [↑]  The  M   DO  loop creates both */
        end       /*p*/                          /*      sides in the same loop.        */
     if tell  then say '(x-1)^'right(0, L)":  1" /*possibly display the first expression*/
     @dd= 'decimal digits.'                      /* [↓]  test for primality by division.*/
        do n=2  for Z;     nh=n % 2;    d=n - 1  /*create expressions;  find the primes.*/
            do k=3  to nh  while @.n.k//d==0     /*are coefficients divisible by  N-1 ? */
            end   /*k*/                          /* [↑]  skip the 1st & 2nd coefficients*/
        if k>nh   then if q.d  then #=# d        /*add a number to the prime list.      */
        if \tell  then iterate                   /*Don't tell?   Don't show expressions.*/
        y='(x-1)^'right(d, L)": "                /*define the 1st part of the expression*/
        s=1                                      /*S:     is the sign indicator (-1│+1).*/
            do j=n  for n-1  by -1               /*create the higher powers first.      */
            if j==2  then xp= 'x'                /*if power=1, then don't show the power*/
                     else xp= 'x^' || (j-1)      /*        ··· else show power with  ^  */
            if j==n  then y=y  xp                /*no sign (+│-) for the 1st expression.*/
                     else y=y  $.s || @.n.j'∙'xp /*build the expression with sign (+|-).*/
            s= \s                                /*flip the sign for the next expression*/
            end   /*j*/                          /* [↑]  the sign (now) is either 0 │ 1,*/
        say  y  $.s'1'                           /*just show the first  N  expressions, */
        end       /*n*/                          /* [↑]  ··· but only for  negative  Z. */
     if #==''  then #='none';      return #      /*if null, return "none"; else return #*/
