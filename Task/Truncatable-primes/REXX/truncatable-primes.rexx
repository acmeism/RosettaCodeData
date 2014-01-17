/*REXX pgm finds largest left- and right-truncatable primes < 1 million.*/
parse arg high .;  if high=='' then high=1000000     /*assume 1 million.*/
!.=0;  Lp=0;  Rp=0;  w=length(high)    /*placeholders for primes, Lp, Rp*/
p.1=2; p.2=3; p.3=5; p.4=7; p.5=11; p.6=13; p.7=17    /*some low primes.*/
!.2=1; !.3=1; !.5=1; !.7=1; !.11=1; !.13=1; !.17=1    /*low prime flags.*/
n=7;  s.n=p.n**2                       /*number of primes so far.       */
/*───────────────────────────────────────generate more primes ≤ high.   */
    do j=p.n+2  by 2  to high          /*only find odd primes from here.*/
    if j//3      ==0  then iterate     /*is  J  divisible by three?     */
    if right(j,1)==5  then iterate     /*is the right-most digit a "5" ?*/
    if j//7      ==0  then iterate     /*is  J  divisible by seven?     */
    if j//11     ==0  then iterate     /*is  J  divisible by eleven?    */
    if j//13     ==0  then iterate     /*is  J  divisible by thirteen?  */
                                       /*[↑] above five lines saves time*/
          do k=7  while s.k<=j         /*divide by known odd primes.    */
          if j//p.k==0  then iterate j /*Is J divisible by X?   ¬ prime.*/
          end   /*k*/
    n=n+1                              /*bump number of primes found.   */
    p.n=j;      s.n=j*j                /*assign to sparse array; prime².*/
    !.j=1                              /*indicate that   J   is a prime.*/
    end         /*j*/
/*─────────────────────────────────────find largest left truncatable P. */
  do L=n  by -1  for n;                if pos(0,p.L)\==0  then iterate
           do k=1  for length(p.L)-1;  _=right(p.L,k)    /*L truncate #.*/
           if \!._  then iterate L     /*Truncated #  ¬prime?   Skip it.*/
           end   /*k*/
  leave                                /*leave the DO loop, we found one*/
  end            /*L*/
/*─────────────────────────────────────find largest right truncatable P.*/
  do R=n  by -1  for n;                if pos(0,p.R)\==0  then iterate
           do k=1  for length(p.R)-1;  _=left(p.R,k)     /*R truncate #.*/
           if \!._  then iterate R     /*Truncated #  ¬prime?   Skip it.*/
           end   /*k*/
  leave                                /*leave the DO loop, we found one*/
  end            /*R*/
/*───────────────────────────────────────show largest left/right trunc P*/
say 'The last prime found is ' p.n  " (there are"  n  'primes ≤'  high")."
say copies('─',70)                     /*show a separator line.         */
say 'The largest  left-truncatable prime ≤'  high    " is "   right(p.L,w)
say 'The largest right-truncatable prime ≤'  high    " is "   right(p.R,w)
                                       /*stick a fork in it, we're done.*/
