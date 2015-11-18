/*REXX program to perform iterated digits squaring ('til sum=1 │ sum=89)*/
parse arg n .                          /*get optional  N  from the C.L. */
if n==''  then n=100 * 1000000         /*Was N given?   No, use default.*/
!.=0;   do m=1  to 9;  !.m=m**2;  end  /*build a short-cut for squares. */
$.=.; $.0=0; $.00=0; $.000=0; $.0000=0; @.=.  /*short-cuts for some sums*/
#.=0                                   /*count of 1 & 89 results so far.*/
     do j=1  for n;  s=sumDs(j)        /* [↓]  process each num in range*/
     #.s=#.s+1                         /*bump the counter for 1's │ 89's*/
     end   /*j*/

  do i=1  to 89  by 88;                _=right('"'i'"', 5)      ' chains'
  say 'count of'  _  'for all natural numbers up to '    n    " is "   #.i
  end      /*i*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SUMDS subroutine────────────────────*/
sumDs: parse arg z;  chunk=3           /*obtain number (for adding digs)*/
p=0                                    /*set the partial sum of the digs*/
   do m=1  by chunk  to length(z)      /*process the number, chunks of 4*/
   y=substr(z, m, chunk)               /*extract a 4─byte chunk of the #*/
   if @.y==.  then do;    oy=y;   a=0  /*Not done before?    Then sum #.*/
                      do  until y==''  /*process each of the digits in Y*/
                      parse var y _ +1 y; a=a+!._  /*get a dig; add to A*/
                      end  /*until y ···   [↑]  A≡is sum of squared digs*/
                   @.oy=a              /*mark original Y as being summed*/
                   end
              else a=@.y               /*use a pre─summed digits of  Y. */
   p=p+a                               /*add all the parts of # together*/
   end   /*m*/

if $.p\==.  then return $.p            /*Computed before?  Use the value*/
y=p                                    /*use a new copy of  P.          */
        do  until s==1 | s==89;  s=0   /*add the  squared digits  of  P.*/
           do  until y==''             /*process each of the digits in X*/
           parse var y _ +1 y; s=s+!._ /*get a dig; sum the fast square,*/
           end   /*until x ···*/       /* [↑]  S≡is sum of squared digs.*/
        y=s                            /*substitute the sum for "new" X.*/
        end      /*until*/             /* [↑]  keep looping 'til S=1│89.*/
$.p=s
return s
