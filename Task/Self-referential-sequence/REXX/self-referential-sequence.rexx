/*REXX program generates a  self─referential sequence  and displays the maximums.       */
parse arg LO HI .                                /*obtain optional arguments from the CL*/
if LO=='' | LO==","  then LO=      1             /*Not specified?  Then use the default.*/
if HI=='' | HI==","  then HI=1000000 - 1         /* "      "         "   "   "     "    */
max$=;      seeds=;    maxL=0                    /*inialize some defaults and counters. */

  do #=LO  to HI;      n=#;     @.=0;     @.#=1  /*loop thru seed; define some defaults.*/
  $=n
      do c=1  until x==n;       x=n              /*generate a self─referential sequence.*/
      n=;           do k=9  by -1  for 10        /*generate a new sequence (downwards). */
                    _=countstr(k, x)             /*obtain the number of sequence counts.*/
                    if _\==0  then n=n || _ || k /*is count > zero?  Then append it to N*/
                    end   /*k*/
      if @.n  then leave                         /*has sequence been generated before ? */
      $=$'-'n;     @.n=1                         /*add the number to sequence and roster*/
      end   /*c*/

  if c==maxL then do;  seeds=seeds #             /*is the sequence equal to max so far ?*/
                       max$=max$   $             /*append this self─referential # to  $ */
                  end
             else if c>maxL  then do;  seeds=#   /*use the new number as the new seed.  */
                                  maxL=c; max$=$ /*also, set the new maximum L; max seq.*/
                                  end            /* [↑]  have we found a new best seq ? */
  end   /*#*/

say  ' seeds that had the most iterations: '     seeds
say  'the maximum self─referential length: '     maxL

  do j=1  for words(max$) ;      say
  say copies('─',30)  "iteration sequence for: "   word(seeds,j)  '  ('maxL  "iterations)"
  q=translate( word( max$, j), ,'-')
                                     do k=1  for words(q);     say  word(q, k)
                                     end   /*k*/
  end   /*j*/                                    /*stick a fork in it,  we're all done. */
