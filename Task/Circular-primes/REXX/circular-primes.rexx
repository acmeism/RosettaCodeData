/*REXX program finds & displays circular primes (with a title & in a horizontal format).*/
parse arg N hp .                                 /*obtain optional arguments from the CL*/
if  N=='' |  N==","  then N=        19           /* "      "         "   "   "     "    */
if hp=='' | hp==","  then hip= 1000000           /* "      "         "   "   "     "    */
call genP                                        /*gen primes up to  hp      (200,000). */
q= 024568                                        /*digs that most circular P can't have.*/
found= 0;                           $=           /*found:  circular P count; $:  a list.*/
      do j=1  until found==N;       p= @.j       /* [↓]  traipse through all the primes.*/
      if p>9 & verify(p, q, 'M')>0  then iterate /*Does J contain forbidden digs?  Skip.*/
      if \circP(p)                  then iterate /*Not circular?  Then skip this number.*/
      found= found + 1                           /*bump the  count  of circular primes. */
      $= $  p                                    /*add this prime number  ──►  $  list. */
      end   /*j*/                                /*at this point, $ has a leading blank.*/

say center(' first '       found        " circular primes ",  79, '─')
say strip($)
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
circP: procedure expose @. !.;  parse arg x 1 ox /*obtain a prime number to be examined.*/
               do length(x)-1; parse var x f 2 y /*parse  X  number, rotating the digits*/
               x= y || f                         /*construct a new possible circular P. */
               if x<ox  then return 0            /*is number < the original?  ¬ circular*/
               if \!.x  then return 0            /* "    "   not prime?       ¬ circular*/
               end   /*length(x)···*/
       return 1                                  /*passed all tests,  X is a circular P.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
genP: @.1=2; @.2=3; @.3=5; @.4=7; @.5=11; @.6=13; @.7=17; @.8=19        /*assign Ps; #Ps*/
      !.= 0; !.2=1; !.3=1; !.5=1; !.7=1; !.11=1; !.13=1; !.17=1; !.19=1 /*   " primality*/
                           #= 8;  sq.#= @.# **2  /*number of primes so far; prime square*/
       do j=@.#+4  by 2  to hip;  parse var j  ''  -1  _ /*get last decimal digit of J. */
       if     _==5  then iterate;   if j// 3==0  then iterate;   if j// 7==0  then iterate
       if j//11==0  then iterate;   if j//13==0  then iterate;   if j//17==0  then iterate
           do k=8  while sq.k<=j                 /*divide by some generated odd primes. */
           if j // @.k==0  then iterate j        /*Is J divisible by  P?  Then not prime*/
           end   /*k*/                           /* [↓]  a prime  (J)  has been found.  */
       #= #+1;   !.j= 1;   sq.#= j*j;   @.#= j   /*bump P cnt;  assign P to @.  and  !. */
       end       /*j*/;                 return
