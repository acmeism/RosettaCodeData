/*REXX program to perform iterated digits squaring ('til sum=1 │ sum=89)*/
parse arg n .                          /*get optional  N  from the C.L. */
if n==''  then n=10 * 1000000          /*Was N given?   No, use default.*/
!.=0;   do m=1  for 9;  !.m=m**2;  end /*build a short─cut for squares. */
a.=.                                   /*intermediate counts of some #s.*/
#.=0                                   /*count of 1 & 89 results so far.*/
     do j=1  for n;          x=j       /* [↓]  process each num in range*/
       do q=1  until s==89 | s==1; s=0 /*add the sum of squared digits. */
         do until x==''                /*process each of the digits in X*/
         parse var x _ +1 x;   s=s+!._ /*get a dig; sum the fast square,*/
         end   /*until x ···*/         /* [↑]  S≡is sum of squared digs.*/
       z.q=s                           /*assign sum to a temp auxiliary.*/
       if a.s\==.  then do; s=a.s; leave; end    /*found a previous sum.*/
       x=s                             /*substitute the sum for "new" X.*/
       end     /*until*/               /* [↑]  keep looping 'til S=1│89.*/

                 do f=1  for q         /* [↓]   use auxiliary array.    */
                 _=z.f;  a._=s         /*assign auxiliaries for future. */
                 end   /*f*/
     #.s=#.s+1                         /*bump the counter for 1's │ 89's*/
     end       /*j*/

  do i=1  to 89  by 88;                c=right('"'i'"',5)     ' chains'
  say 'count of'  c  'for all natural numbers up to '    n    " is "   #.i
  end   /*i*/
                                       /*stick a fork in it, we're done.*/
