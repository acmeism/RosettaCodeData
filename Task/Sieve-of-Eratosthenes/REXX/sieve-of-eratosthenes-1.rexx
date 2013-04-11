/*REXX program generates primes via the sieve of Eratosthenes algorithm.*/
parse arg H .;   if H==''  then H=200  /*let the highest # be specified.*/
w = length(H); prime=right('prime',20) /*W is used for formatting output*/
@.=1                                   /*assume all numbers are prime.  */
     do j=2  while  j*j <= H           /*all integers up to √H inclusive*/
     if @.j then  do m=j*j  to H by J  /*Prime?   Then strike mutliples.*/
                  @.m=0                /*mark all multiples of J ¬prime.*/
                  end   /*m*/
     end                /*j*/
#=0                                    /*count of primes listed so far. */
   do n=2  to H                        /* [↓] if prime, then display it.*/
   if @.n then do; # = #+1; say  prime right(#,w) " ───► " right(n,w); end
   end   /*n*/
                                       /*stick a fork in it, we're done.*/
