/*REXX program to perform iterated digits squaring ('til sum=1 | sum=89)*/
parse arg n .                          /*get optional  N  from the C.L. */
if n==''  then n=100000000             /*Was N given?   No, use default.*/
!.=0;   do m=1  to 9;  !.m=m**2;  end  /*build a short-cut for squares. */
$.=.; $.0=0; $.00=0; $.000=0; $.0000=0; @.=.  /*short-cuts for some sums*/
@.=.                                   /*placeholder for computed sums. */
#.=0                                   /*count of 1 & 89 results so far.*/
     do j=1  for n                     /* [↓]  process each num in range*/
     s=sumds(j)                        /*get the sum of squared digits. */
     #.s=#.s+1                         /*bump the counter for 1's | 89's*/
     end   /*j*/

  do i=1  by 89-1  for 2;              c=' 'right('"'i'"',4)' chains '
  say 'count of'  c  'for all natural numbers up to '    n    " is "  #.i
  end   /*i*/

exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SUMDS subroutine────────────────────*/
sumds: parse arg z;  p=0
                            do m=1  by 4  to length(z)
                            p=p + summer(substr(z,m,4))
                            end  /*m*/
if $.p\==.  then return $.p            /*if computed before, use the val*/
y=p
         do  until s==1 | s==89        /*add the  squared digits  of  P.*/
         s=0                           /*set the sum to zero initially. */
             do k=1  for length(y)     /*process each of the digits in X*/
             _=substr(y,k,1)           /*pick off a particular  X  digit*/
             s=s+!._                   /*do a fast squaring of it & sum.*/
             end   /*k*/               /* [↑]  S≡is sum of squared digs.*/
         y=s                           /*subsitute the sum for "new" X. */
         end       /*until*/           /* [↑]  keep looping 'til S=1|89.*/
$.p=s
return s
/*──────────────────────────────────SUMMER subroutine───────────────────*/
summer: parse arg y . 1 oy .; if @.y\==.  then return @.y  /*use old val*/
a=0
             do k=1  for length(y)     /*process each of the digits in X*/
             _=substr(y,k,1)           /*pick off a particular  X  digit*/
             a=a+!._                   /*do a fast squaring of it & sum.*/
             end   /*k*/               /* [↑]  S≡is sum of squared digs.*/
@.oy=a
return a
