/*REXX program generates primes via the sieve of Eratosthenes algorithm.*/
parse arg H .;   if H==''  then H=200  /*let the highest # be specified.*/
w = length(H); prime=right('prime',20) /*W is used for formatting output*/
@.=1                                   /*assume all numbers are prime.  */
#=0                                    /*number of primes found so far. */
    do j=2  to H                       /*all integers up to H inclusive.*/
    if @.j  then do;  #=#+1            /*Prime?  Then bump prime counter*/
                 say  prime right(#,w)   " ───► "   right(j,w)   /*show.*/
                   do m=j*j  to H  by j;   @.m=0;   end  /*odd multiples*/
                 end   /*plain*/       /*[↑] strike odd multiples ¬prime*/
  end                  /*j*/
                                       /*stick a fork in it, we're done.*/
