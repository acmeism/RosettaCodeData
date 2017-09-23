/*REXX program performs the squaring of iterated digits  (until the sum equals 1 or 89).*/
parse arg n .                                    /*obtain optional arguments from the CL*/
if n=='' | n==","  then n=10 * 1000000           /*Not specified?  Then use the default.*/
!.=0;   do m=1  for 9;  !.m=m**2;  end /*m*/     /*build a short─cut for the squares.   */
$.=.;  $.0=0;  $.00=0;  $.000=0;  $.0000=0; @.=. /*short-cuts for sub-group summations. */
#.=0                                             /*count of  1  and  89  results so far.*/
     do j=1  for n;  s=sumDs(j)                  /* [↓]  process each number in a range.*/
     #.s=#.s+1                                   /*bump the counter for  1's  or  89's. */
     end   /*j*/

  do k=1  by 88  for 2;   @=right('"'k'"', 5)    /*display two results; define a literal*/
  say 'count of'   @    " chains for all natural numbers up to "     n     ' is:'      #.k
  end   /*k*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sumDs: parse arg z;  chunk=3                     /*obtain the number (for adding digits)*/
p=0                                              /*set partial sum of the decimal digits*/
   do m=1  by chunk  to length(z)                /*process the number, in chunks of four*/
   y=substr(z, m, chunk)                         /*extract a 4─byte chunk of the number.*/
   if @.y==.  then do;   oy=y;  a=0              /*Not done before?  Then sum the number*/
                     do  until y==''             /*process each of the dec. digits in Y.*/
                     parse var y _ +1 y; a=a+!._ /*obtain a decimal digit; add it to  A.*/
                     end  /*until y ···*/        /* [↑]   A ≡ is the sum of squared digs*/
                   @.oy=a                        /*mark original  Y  as being summed.   */
                   end
              else a=@.y                         /*use the  pre─summed  digits of  Y.   */
   p=p+a                                         /*add all the parts of number together.*/
   end   /*m*/

if $.p\==.  then return $.p                      /*Computed before?  Then use the value.*/
y=p                                              /*use a new copy of  P.                */
        do  until s==1 | s==89;       s=0        /*add the squared decimal digits of  P.*/
           do  until y==''                       /*process each  decimal digits in    X.*/
           parse var y _ +1 y;        s=s+!._    /*get a dec. digit; sum the fast square*/
           end   /*until y=='' ···*/             /* [↑]  S ≡ is sum of the squared digs.*/
        y=s                                      /*substitute the sum for a  "new"  X.  */
        end      /*until s==1  ···*/             /* [↑]  keep looping 'til  S=1  or  89.*/
$.p=s                                            /*use this for memoization for the sum.*/
return s
