/*REXX pgm generates a self-referential sequence and lists the maximums.*/
parse arg low high .;      maxL=0;     seeds=;      max$$=
if  low==''  then  low=1               /*no low?    Then use the default*/
if high==''  then high=1000000         /* " high?     "   "   "     "   */
/*══════════════════════════════════════════════════traipse through #'s.*/
  do seed=low  to high;      n=seed;   $.=0;      $$=n;         $.n=1

         do j=1  until x==n            /*generate a self─referential seq*/
         x=n;    n=
                             do k=9  by -1  for 10    /*gen new sequence*/
                             _=countstr(k,x);     if _\==0  then n=n||_||k
                             end   /*k*/
         if $.n  then leave            /*sequence been generated before?*/
         $$=$$'-'n;   $.n=1            /*add number to sequence & roster*/
         end   /*j*/

  if j==maxL then do                   /*sequence equal to max so far ? */
                  seeds=seeds seed;    maxnums=maxnums n;   max$$=max$$ $$
                  end
             else if j>maxL  then do   /*have found a new best sequence.*/
                                  seeds=seed;  maxL=j; maxnums=n; max$$=$$
                                  end
  end   /*seed*/
/*═══════════════════════════════════════════════════display the output.*/
say 'seeds that had the most iterations =' seeds
hdr=copies('─',30);           say 'maximum sequence length =' maxL

  do j=1  for words(max$$);   say
  say hdr "iteration sequence for: " word(seeds,j) '  ('maxL "iterations)"
  q=translate(word(max$$,j),,'-')
                                     do k=1  for words(q);  say  word(q,k)
                                     end   /*k*/
  end   /*j*/
                                       /*stick a fork in it, we're done.*/
