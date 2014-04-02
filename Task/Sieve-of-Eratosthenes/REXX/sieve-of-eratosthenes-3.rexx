/*REXX pgm gens primes via a  wheeled  sieve of Eratosthenes  algorithm.*/
parse arg H .;   if H==''  then H=200  /*high# can be specified on C.L. */
w=length(H);  prime=right('prime',20)  /*W is used for formatting output*/
if 2<=H  then  say  prime  right(1,w)    " ───► "    right(2,w)
skip=0                                 /*skips top part sieve striking. */
@.=1                                   /*assume all numbers are prime.  */
#=1                                    /*number of primes found so far. */
   do j=3  by 2  to H                  /*odd integers up to H inclusive.*/
   if @.j  then do;  #=#+1             /*Prime?  Then bump prime counter*/
                say  prime right(#,w)   " ───► "   right(j,w)    /*show.*/
                if skip   then iterate /*should the top part be skipped?*/
                if j*j>H  then skip=1  /*indicate skipping if  j > √ H. */
                  do m=j*j to H  by j+j;  @.m=0;  end   /*odd multiples.*/
                end   /*plain*/        /*[↑] strike odd multiples ¬prime*/
   end                /*j*/
                                       /*stick a fork in it, we're done.*/
