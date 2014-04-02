/*REXX pgm gens primes via a  wheeled  sieve of Eratosthenes  algorithm.*/
parse arg H .;   if H==''  then H=200  /*high# can be specified on C.L. */
tell=h>0;     H=abs(H);    w=length(H) /*neg H suppresses prime listing.*/
if 2<=H & tell  then say right(1,w+20)'st prime   ───► '   right(2,w)
skip=0                                 /*skips top part sieve striking. */
@.=1                                   /*assume all numbers are prime.  */
#=1                                    /*number of primes found so far. */
    do j=3  by 2  to H                 /*odd integers up to H inclusive.*/
    if @.j  then do;  #=#+1            /*Prime?  Then bump prime counter*/
                 if tell then say right(#,w+20)th(#) 'prime   ───► ' right(j,w)
                 if skip  then iterate /*should the top part be skipped?*/
                 if j*j>H  then skip=1 /*indicate skipping if  j > √ H. */
                   do m=j*j to H by j+j; @.m=0; end     /*odd multiples.*/
                 end   /*plain*/       /*[↑] strike odd multiples ¬prime*/
    end                /*j*/
say;             say  right(#,w+20+2)  'prime's(#)   "found."
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────S subroutine────────────────────────*/
s: if arg(1)==1  then return arg(3);  return word(arg(2) 's',1) /*plural*/
/*──────────────────────────────────TH subroutine───────────────────────*/
th: procedure;parse arg x;x=abs(x);return word('th st nd rd',1+x//10*(x//100%10\==1)*(x//10<4))
