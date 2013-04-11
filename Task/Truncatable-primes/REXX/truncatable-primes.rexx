/*REXX pgm finds largest left- and right-truncatable primes < 1 million.*/
!.=0                                   /*placeholders for primes.       */
p.1=2; p.2=3; p.3=5; p.4=7; p.5=11; p.6=13; p.7=17    /*some low primes.*/
!.2=1; !.3=1; !.4=1; !.7=1; !.11=1; !.13=1; !.17=1    /*low prime flags.*/
n=7                                    /*number of primes so far.       */
     do j=p.n+2  by 2  to 1000000      /*find all primes < 1,000,000.   */
     if j//3      ==0 then iterate     /*divisible by three?            */
     if right(j,1)==5 then iterate     /*right-most digit a five?       */
     if j//7      ==0 then iterate     /*divisible by seven?            */
     if j//11     ==0 then iterate     /*divisible by eleven?           */
                                       /*the above 4 lines saves time.  */
           do k=6  while p.k**2<=j     /*divide by known odd primes.    */
           if j//p.k==0 then iterate j /*Is divisible by X?   Not prime.*/
           end   /*k*/
     n=n+1                             /*bump number of primes found.   */
     p.n=j                             /*assign to sparse array.        */
     !.j=1                             /*indicate that   J   is a prime.*/
     end         /*j*/

say 'The last prime is'  p.n  " (there are "n 'primes under one million).'
say copies('─',70)                     /*show a separator line.         */
lp=0;   rp=0

  do L=n  by -1  until lp\==0;         if pos(0,p.L)\==0  then iterate
           do k=1  for length(p.L)-1;  _=right(p.L,k)    /*truncate a #.*/
           if \!._  then iterate L     /*Truncated #  ¬prime?   Skip it.*/
           end   /*k*/
  lp=p.L
  end            /*L*/

  do R=n  by -1  until rp\==0;         if pos(0,p.R)\==0  then iterate
           do k=1  for length(p.R)-1;  _=left(p.R,k)     /*truncate a #.*/
           if \!._  then iterate R     /*Truncated #  ¬prime?   Skip it.*/
           end   /*k*/
  rp=p.R
  end            /*R*/

say 'The largest  left-truncatable prime under one million is '    lp
say 'The largest right-truncatable prime under one million is '    rp
                                       /*stick a fork in it, we're done.*/
