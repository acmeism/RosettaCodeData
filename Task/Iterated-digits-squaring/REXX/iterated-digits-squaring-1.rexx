/*REXX program performs the squaring of iterated digits  (until the sum equals 1 or 89).*/
parse arg n .                                    /*obtain optional arguments from the CL*/
if n=='' | n==","  then n=10 * 1000000           /*Not specified?  Then use the default.*/
!.=0;   do m=1  for 9;  !.m=m**2;  end  /*m*/    /*build a short-cut for the squares.   */
a.=.;                                #.=!.       /*intermediate counts of some numbers. */
     do j=1  for n;                  x=j         /* [?] process the numbers in the range*/
       do q=1  until s==89 | s==1;   s=0         /*add sum of the squared decimal digits*/
             do  until x==''                     /*process each of the dec. digits in X.*/
             parse var x _ +1 x;     s=s + !._   /*get a digit;  sum the fast square,   */
             end   /*until x ··· */              /* [?]  S=is sum of the squared digits.*/
       z.q=s                                     /*assign sum to a temporary auxiliary. */
       if a.s\==.  then do;  s=a.s;  leave;  end /*Found a previous sum?  Then use that.*/
       x=s                                       /*substitute the sum for the "new"  X. */
       end   /*q*/                               /* [?]  keep looping 'til   S= 1 or 89.*/
                   do f=1  for q;  _=a.f;  a._=s /*use the auxiliary arrays (for lookup)*/
                   end   /*f*/
     #.s=#.s + 1                                 /*bump the counter for the 1's or 89's.*/
     end   /*j*/

  do k=1  by 88  for 2;   @k=right('"'k'"', 5)   /*display two results; define a literal*/
  say 'count of'   @k   " chains for all natural numbers up to "     n     ' is:'      #.k
  end   /*k*/                                    /*stick a fork in it,  we're all done. */
