/*REXX program lists a  sequence of  SPDS  (Smarandache prime-digital sequence)  primes.*/
parse arg n q                                    /*get optional number of primes to find*/
if n=='' | n==","  then n=  25                   /*Not specified?  Then use the default.*/
if q=''            then q= 100  1000             /* "      "         "   "   "     "    */
say '═══listing the first'     n     "SPDS primes═══"
call spds n
             do i=1  for words(q)+1;     y=word(q, i);    if y=='' | y==","   then iterate
             say
             say '═══listing the last of '    y     "SPDS primes═══"
             call spds -y
             end   /*i*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
spds: parse arg x 1 ox;  x= abs(x)               /*obtain the limit to be used for list.*/
      c= 0                                       /*C  number of SPDS primes found so far*/
      #= 0                                       /*#  number of      primes found so far*/
            do j=1  by 2  while  c<x;    z= j    /*start: 1st even prime, then use odd. */
            if z==1  then z= 2                   /*handle the even prime (special case) */
                                                 /* [↓]  divide by the primes.   ___    */
                    do k=2  to #  while  k*k<=z  /*divide  Z  with all primes ≤ √ Z     */
                    if z//@.k==0  then iterate j /*÷ by prev. prime?  ¬prime     ___    */
                    end   /*j*/                  /* [↑]   only divide up to     √ Z     */
            #= # + 1;             @.#= z         /*bump the prime count;  assign prime #*/
            if verify(z, 2357)>0  then iterate j /*Digits ¬prime?  Then skip this prime.*/
            c= c + 1                             /*bump the number of SPDS primes found.*/
            if ox<0  then iterate                /*don't display it, display the last #.*/
            say right(z, 21)                     /*maybe display this prime ──► terminal*/
            end   /*j*/                          /* [↑]  only display N number of primes*/
      if ox<0  then say right(z, 21)             /*display one  (the last)  SPDS prime. */
      return
