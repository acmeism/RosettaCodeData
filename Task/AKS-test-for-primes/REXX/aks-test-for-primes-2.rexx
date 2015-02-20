/*REXX pgm calculates primes via the Agrawal-Kayal-Saxena primality test*/
parse arg top .; if top==''  then top=200  /*Not specified? Use default.*/
oTop=top;  tell=top<0;  top=abs(top)   /*TOP negative?  Show expression.*/
numeric digits max(9,top%3)            /*define a dynamic number of digs*/
@.=1;   big=1                          /*set all coefficients to unity. */
#=                                     /*define a list of prime numbers.*/
  do p=3  for top;    pm=p-1;  pp=p+1  /*PM & PP: used as a convenience.*/
      do m=2  to pp%2;         mm=m-1  /*calc. coefficients for a power.*/
      @.p.m=@.pm.mm + @.pm.m;  mh=pp-m /*calculate left  side of  coeff.*/
      @.p.mh=@.p.m                     /*    "     right   "   "    "   */
      if @.p.m>big  then big=@.p.m     /*This coefficient the biggest?  */
      end   /*m*/                      /* [↑]  The  M  DO loop does both*/
  end       /*p*/                      /*      sides in the same loop,  */
                                       /*      saving a bunch of time.  */
if tell  then say '(x-1)^0:  1'        /*maybe show the first expression*/
$.0='-';   $.1="+"                     /*$.x   is the  sign  to be used.*/
                                       /* [↓]  test for primality by ÷  */
  do n=2  for top;   nh=n%2;    nm=n-1 /*create expressions/find primes.*/
    do k=3  to nh  until @.n.k//nm\==0 /*coefficients divisible by N-1 ?*/
    end   /*k*/                        /* [↑]  skip the 1st & 2nd coeff.*/
                                       /* [↓]  search for a good coeff. */
  if k>nh & nm\==1 & n\==5 then #=# nm /*add a number to the prime list.*/
  if \tell  then iterate               /*¬tell?  Don't show expressions.*/
  s=1                                  /*S:     is the sign indicator.  */
  y='(x-1)^'nm": "                     /*define first part of expression*/
                                       /* [↓]  create higher powers 1st.*/
    do j=n  to 2  by -1;   jm=j-1      /*JM    is used as a convenience.*/
    if j==2  then exp='x'              /*if power=1, don't show the pow.*/
             else exp='x^'jm           /* ··· else show the power with ^*/
    if j==n  then y=y exp              /*no sign for the 1st expression.*/
             else y=y $.s @.n.j'∙'exp  /*build the expression with sign.*/
    s=\s                               /*flip the sign in the expression*/
    end   /*j*/                        /* [↑]  the sign (now) is  0 | 1,*/
                                       /*      and is shown as    - | + */
  say  y  $.s  1                       /*just show first N expressions, */
  end     /*n*/                        /* [↑]  ··· but only for neg TOP.*/
                           say         /* [↓]  Has TOP a leading +? Show*/
if left(oTop,1)=='+'  then say top  is  'prime.'       /*tell is/isn't. */
                      else say 'primes:'  #     /*display prime # list. */
say                                             /* [↓]  size of big 'un.*/
say 'Found '   words(#)    ' primes and the largest coefficient has' ,
    length(big)  "decimal digits."     /*stick a fork in it, we're done.*/
