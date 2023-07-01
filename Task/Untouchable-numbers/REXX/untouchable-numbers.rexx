/*REXX pgm finds N untouchable numbers (numbers that can't be equal to any aliquot sum).*/
parse arg n cols tens over .                     /*obtain optional arguments from the CL*/
if    n='' |    n==","            then    n=2000 /*Not specified?  Then use the default.*/
if cols='' | cols=="," | cols==0  then cols=  10 /* "       "        "   "   "      "   */
if tens='' | tens==","            then tens=   0 /* "       "        "   "   "      "   */
if over='' | over==","            then over=  20 /* "       "        "   "   "      "   */
tell= n>0;                             n= abs(n) /*N>0?  Then display the untouchable #s*/
call genP  n * over                              /*call routine to generate some primes.*/
u.= 0                                            /*define all possible aliquot sums ≡ 0.*/
          do p=1  for #;   _= @.p + 1;   u._= 1  /*any prime+1  is  not  an untouchable.*/
                           _= @.p + 3;   u._= 1  /* "  prime+3   "   "    "      "      */
          end   /*p*/                            /* [↑]  this will also rule out  5.    */
u.5= 0                                           /*special case as prime 2 + 3 sum to 5.*/
          do j=2  for lim;  if !.j  then iterate /*Is  J  a prime?   Yes, then skip it. */
          y= sigmaP()                            /*compute:  aliquot sum (sigma P) of J.*/
          if y<=n  then u.y= 1                   /*mark  Y  as a touchable if in range. */
          end  /*j*/
call show                                        /*maybe show untouchable #s and a count*/
if tens>0  then call powers                      /*Any "tens" specified?  Calculate 'em.*/
exit cnt                                         /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
genSq:    do _=1  until _*_>lim;  q._= _*_;  end;  q._= _*_;  _= _+1;  q._= _*_;  return
grid:   $= $ right( commas(t), w);  if cnt//cols==0  then do;  say $;  $=;  end;  return
powers:   do pr=1  for tens;   call 'UNTOUCHA' -(10**pr);   end  /*recurse*/;     return
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP: #= 9;  @.1=2; @.2=3; @.3=5; @.4=7; @.5=11; @.6=13; @.7=17; @.8=19; @.9=23 /*a list*/
      !.=0;  !.2=1; !.3=1; !.5=1; !.7=1; !.11=1; !.13=1; !.17=1; !.19=1  !.23=1 /*primes*/
      parse arg lim;   call genSq                /*define the (high) limit for searching*/
                                     qq.10= 100  /*define square of the 10th prime index*/
        do j=@.#+6  by 2  to lim                 /*find odd primes from here on forward.*/
        parse var  j    ''  -1  _;   if     _==5  then iterate;  if j// 3==0  then iterate
        if j// 7==0  then iterate;   if j//11==0  then iterate;  if j//13==0  then iterate
        if j//17==0  then iterate;   if j//19==0  then iterate;  if j//23==0  then iterate
                                                 /*start dividing by the tenth prime: 29*/
                  do k=10  while qq.k <= j       /* [↓]  divide  J  by known odd primes.*/
                  if j//@.k==0  then iterate j   /*J ÷ by a prime?  Then ¬prime.   ___  */
                  end   /*k*/                    /* [↑]  only process numbers  ≤  √ J   */
        #= #+1;                     @.#= j       /*bump prime count; assign a new prime.*/
        !.j= 1;                    qq.#= j*j     /*mark prime;  compute square of prime.*/
        end             /*j*/;        return     /*#:  is the number of primes generated*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: w=7; $= right(2, w+1)  right(5, w)         /*start the list of an even prime and 5*/
                             cnt= 2              /*count of the only two primes in list.*/
        do t=6  by 2  to n;  if u.t then iterate /*Is  T  touchable?    Then skip it.   */
        cnt= cnt + 1;     if tell then call grid /*bump count;  maybe show a grid line. */
        end   /*t*/
                    if tell & $\==''  then say $ /*display a residual grid line, if any.*/
                    if tell           then say   /*show a spacing blank line for output.*/
      if n>0  then say right( commas(cnt), 20)  ,             /*indent the output a bit.*/
                     ' untouchable numbers were found  ≤ '    commas(n);            return
/*──────────────────────────────────────────────────────────────────────────────────────*/
sigmaP: s= 1                                     /*set initial sigma sum (S) to 1.   ___*/
        if j//2  then do m=3  by 2  while q.m<j  /*divide by odd integers up to the √ J */
                      if j//m==0  then s=s+m+j%m /*add the two divisors to the sum.     */
                      end   /*m*/                /* [↑]  process an odd integer.     ___*/
                 else do m=2        while q.m<j  /*divide by all integers up to the √ J */
                      if j//m==0  then s=s+m+j%m /*add the two divisors to the sum.     */
                      end   /*m*/                /* [↑]  process an even integer.    ___*/
        if q.m==j  then return s + m             /*Was  J  a square?   If so, add   √ J */
                        return s                 /*                    No, just return. */
