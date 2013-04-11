/*REXX pgm gens primes via a  wheeled  sieve of Eratosthenes  algorithm.*/
parse arg H .;   if H==''  then H=200  /*high# can be specified on C.L. */
oH=H;     H=abs(H);        w=length(H) /*neg H suppresses prime listing.*/
if 2<=H & oH>0  then say right(1,w+20)'st prime   ───► '   right(2,w)
@.=1                                   /*assume all numbers are prime.  */
     do j=3  by 2    while  j*j <= H   /*odd integers up to √H inclusive*/
     if @.j then do m=j*j to H  by j+j /*Prime?   Then strike multiples.*/
                 @.m = 0               /*mark odd multiples of J ¬prime.*/
                 end   /*m*/
     end               /*j*/
#= H>1                                 /*count of primes found so far.  */
   do n=3  to H  by 2                  /*count primes & maybe show them.*/
   if @.n  then do; #=#+1; if oH>0  then say right(#,w+20)th(#)' prime   ───► ' right(n,w); end
   end   /*n*/
say;                        say  right(#,w+20+2)   'prime's(#)    "found."
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────S subroutine────────────────────────*/
s: if arg(1)==1  then return arg(3);  return word(arg(2) 's',1) /*plural*/
/*──────────────────────────────────TH subroutine───────────────────────*/
th: procedure;parse arg x;x=abs(x);return word('th st nd rd',1+x//10*(x//100%10\==1)*(x//10<4))
