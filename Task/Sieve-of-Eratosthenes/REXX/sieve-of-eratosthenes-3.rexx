/*REXX pgm gens primes via a  wheeled  sieve of Eratosthenes  algorithm.*/
parse arg H .;   if H==''  then H=200  /*high# can be specified on C.L. */
w = length(H); prime=right('prime',20) /*W is used for formatting output*/
if 2 <= H  then  say  prime  right(1,w)   " ───► "   right(2,w)
@.=1                                   /*assume all numbers are prime.  */
     do j=3  by 2    while  j*j <= H   /*odd integers up to √H inclusive*/
     if @.j then do m=j*j to H  by j+j /*Prime?   Then strike multiples.*/
                 @.m = 0               /*mark odd multiples of J ¬prime.*/
                 end   /*m*/
     end               /*j*/
#=1                                    /*display a  list  of odd primes.*/
   do n=3  to H  by 2                  /* [↓] if prime, then display it.*/
   if @.n then do;  #=#+1;  say  prime right(#,w) " ───► " right(n,w); end
   end   /*n*/
                                       /*stick a fork in it, we're done.*/
