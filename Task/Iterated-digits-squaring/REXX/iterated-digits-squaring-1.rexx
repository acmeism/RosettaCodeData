/*REXX program performs the squaring of iterated digits  (until the sum equals 1 or 89).*/
parse arg n .                                    /*obtain optional arguments from the CL*/
if n=='' | n==","  then n=10 * 1000000           /*Not specified?  Then use the default.*/
!.=0;   do m=1  for 9;  !.m=m**2;  end /*m*/     /*build a short─cut for the squares.   */
a.=.                                             /*intermediate counts of some numbers. */
#.=0                                             /*count of  1  and  89  results so far.*/
     do j=1  for n;                  x=j         /* [↓] process the numbers in the range*/
       do q=1  until s==89 | s==1;   s=0         /*add sum of the squared decimal digits*/
             do  until x==''                     /*process each of the dec. digits in X.*/
             parse var x _ +1 x;     s=s+!._     /*get a digit;  sum the fast square,   */
             end   /*until x== ... */            /* [↑]  S≡is sum of the squared digits.*/
       z.q=s                                     /*assign sum to a temporary auxiliary. */
       if a.s\==.  then do;  s=a.s;  leave;  end /*Found a previous sum?  Then use that.*/
       x=s                                       /*substitute the sum for the "new"  X. */
       end   /*until s== ... */                  /* [↑]  keep looping 'til   S= 1 or 89.*/

                 do f=1  for q                   /* [↓]   use the auxiliary array.      */
                 _=z.f;  a._=s                   /*assign auxiliaries for future look-up*/
                 end   /*f*/
     #.s=#.s+1                                   /*bump the counter for the 1's or 89's.*/
     end   /*j*/

  do k=1  by 88  for 2;      q='"'
  say 'count of' right(q||k||q,5) " chains for all natural numbers up to "  n  ' is:'  #.k
  end   /*k*/
                                                 /*stick a fork in it,  we're all done. */
