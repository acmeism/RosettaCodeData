/*REXX program lists a  sequence of primes  by testing  primality  by  trial division.  */
parse arg N .                                    /*get optional number of primes to find*/
if N=='' | N==","  then N= 26                    /*Not specified?   Then assume default.*/
tell= (N>0);            N= abs(N)                /*N is negative?   Then don't display. */
@.1=2;   @.2=3;   @.3=5;   @.4=7;   @.5=11;   @.6=13;        #= 5;         s= @.# + 2
                                                 /*    [↑]  is the number of low primes.*/
      do p=1  for #   while  p<=N                /* [↓]  find primes, and maybe show 'em*/
      if tell  then say right(@.p, 9)            /*display some pre─defined low primes. */
      !.p= @.p**2                                /*also compute the squared value of P. */
      end   /*p*/                                /* [↑]  allows faster loop (below).    */
                                                 /* [↓]  N:  default lists up to 101 #s.*/
   do j=s  by 2  while  #<N                      /*continue on with the next odd prime. */
   parse var  j    ''  -1  _                     /*obtain the last digit of the  J  var.*/
   if _      ==5  then iterate                   /*is this integer a multiple of five?  */
   if j // 3 ==0  then iterate                   /* "   "     "    "     "     " three? */
   if j // 7 ==0  then iterate                   /* "   "     "    "     "     " seven? */
   if j //11 ==0  then iterate                   /* "   "     "    "     "     " eleven?*/
                                                 /* [↓]  divide by the primes.   ___    */
          do k=p  to #  while  !.k<=j            /*divide  J  by other primes ≤ √ J     */
          if j//@.k ==0   then iterate j         /*÷ by prev. prime?  ¬prime     ___    */
          end   /*k*/                            /* [↑]   only divide up to     √ J     */
   #= #+1                                        /*bump the count of number of primes.  */
   @.#= j;           !.#= j*j                    /*define this prime; define its square.*/
   if tell  then say right(j, 9)                 /*maybe display this prime ──► terminal*/
   end   /*j*/                                   /* [↑]  only display N number of primes*/
                                                 /* [↓]  display number of primes found.*/
say  #       ' primes found.'                    /*stick a fork in it,  we're all done. */
