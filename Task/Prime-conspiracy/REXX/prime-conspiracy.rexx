/*REXX pgm shows a table of what last digit follows the previous last digit for N primes*/
parse arg N .                                    /*N:  the number of primes to be genned*/
if N=='' | N==","  then N= 1000000               /*Not specified?  Then use the default.*/
Np= N+1;                w= length(N-1)           /*W:  width used for formatting output.*/
H= N* (2**max(4, (w%2+1) ) )                     /*used as a rough limit for the sieve. */
@.= .                                            /*assume all numbers are prime (so far)*/
#= 1                                             /*primes found so far {assume prime 2}.*/
     do j=3  by 2;     if @.j==''  then iterate  /*Is composite?  Then skip this number.*/
     #= #+1                                      /*bump the prime number counter.       */
             do m=j*j  to H  by j+j;    @.m=     /*strike odd multiples as composite.   */
             end   /*m*/
     if #==Np  then leave                        /*Enough primes?   Then done with gen. */
     end   /*j*/                                 /* [↑]  gen using Eratosthenes' sieve. */
!.= 0                                            /*initialize all the frequency counters*/
say 'For '   N   " primes used in this study:"   /*show hdr information about this run. */
r= 2                                             /*the last digit of the very 1st prime.*/
#= 1                                             /*the number of primes looked at so far*/
     do i=3  by 2;     if @.i==''  then iterate  /*This number composite? Then ignore it*/
     #= # + 1;         parse var  i   ''  -1  x  /*bump prime counter; get its last dig.*/
     !.r.x= !.r.x +1;  r= x                      /*bump the last digit counter for prev.*/
     if #==Np  then leave                        /*Done?   Then leave this  DO  loop.   */
     end   /*i*/                                 /* [↑]  examine almost all odd numbers.*/
say                                              /* [↓]  display the results to the term*/
     do    d=1  for 9; if d//2 | d==2  then say  /*display a blank line (if appropriate)*/
        do f=1  for 9; if !.d.f==0  then iterate /*don't show if the count is zero.     */
        say 'digit '      d      "──►"       f        ' has a count of: ',
             right(!.d.f, w)",  frequency of:"   right(format(!.d.f / N*100, , 4)'%.', 10)
        end   /*f*/
     end      /*d*/                              /*stick a fork in it,  we're all done. */
