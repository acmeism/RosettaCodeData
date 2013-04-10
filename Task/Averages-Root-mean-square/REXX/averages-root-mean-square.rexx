/*REXX program to compute the  root mean square  of a series of numbers.*/

parse arg n .                          /*get the argument (maybe).      */
if n=='' then n=10                     /*Not specified?  Then assume 10.*/
numeric digits 50                      /*let's go a little overboard.   */
sum=0                                  /*sum of numbers squared (so far)*/
                   do j=1 for n        /*step through   N   integers.   */
                   sum=sum+j**2        /*sum the squares of the integers*/
                   end   /*j*/
rms=sqrt(sum/n)                        /*divide by  N,  then get  SQRT. */
say 'root mean square for 1──►'n "is" rms                 /*show & tell.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SQRT subroutine─────────────────────────*/
sqrt: procedure; parse arg x;if x=0 then return 0;d=digits();numeric digits 11
g=.sqrtGuess();  do j=0 while p>9;  m.j=p; p=p%2+1; end;   do k=j+5 to 0 by -1
if m.k>11 then numeric digits m.k;g=.5*(g+x/g);end;numeric digits d;return g/1

.sqrtGuess:  if x<0 then say 'negative number' x;   numeric form;   m.=11
p=d+d%4+2; parse value format(x,2,1,,0) 'E0' with g 'E' _ .; return g*.5'E'_%2
