/*REXX program to perform iterated digits squaring ('til sum=1 | sum=89)*/
parse arg n .                          /*get optional  N  from the C.L. */
if n==''  then n=1000000               /*Was N given?   No, use default.*/
!.=0;   do m=1  to 9;  !.m=m**2;  end  /*build a short-cut for squares. */
#.=0                                   /*count of 1 & 89 results so far.*/
     do j=1  for n                     /* [↓]  process each num in range*/
     x=j                               /*use X for a proxy for the J var*/
         do  until s==1 | s==89        /*add the  squared digits  of  X.*/
         s=0                           /*set the sum to zero initially. */
             do k=1  for length(x)     /*process each of the digits in X*/
             _=substr(x,k,1)           /*pick off a particular  X  digit*/
             s=s+!._                   /*do a fast squaring of it & sum.*/
             end   /*k*/               /* [↑]  S≡is sum of squared digs.*/
         x=s                           /*subsitute the sum for "new" X. */
         end       /*until*/           /* [↑]  keep looping 'til S=1|89.*/
     #.s=#.s+1                         /*bump the counter for 1's | 89's*/
     end           /*j*/

  do i=1  by 89-1  for 2;              c=' 'right('"'i'"',4)' chains '
  say 'count of'  c  'for all natural numbers up to '    n    " is "  #.i
  end   /*i*/
                                       /*stick a fork in it, we're done.*/
