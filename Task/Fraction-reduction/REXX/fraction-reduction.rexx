/*REXX pgm reduces fractions by "crossing out" matching digits in nominator&denominator.*/
parse arg high show .                            /*obtain optional arguments from the CL*/
if high=='' | high==","  then high=  4           /*Not specified?  Then use the default.*/
if show=='' | show==","  then show= 12           /* "      "         "   "   "     "    */
say center(' some samples of reduced fractions by crossing out digits ', 79, "═")
$.=0                                             /*placeholder array for counts; init. 0*/
      do L=2  to high;      say                  /*do 2-dig fractions to HIGH-dig fract.*/
                            lim= 10**L - 1       /*calculate the upper limit just once. */
         do n=10**(L-1)  to lim                  /*generate some  N  digit  fractions.  */
         if pos(0, n) \==0  then iterate         /*Does  it  have a zero?  Then skip it.*/
         if hasDup(n)       then iterate         /*  "    "    "  " dup?     "    "   " */

            do d=n+1     to lim                           /*only process like-sized #'s */
            if pos(0, d)\==0         then iterate         /*Have a zero? Then skip it.  */
            if verify(d, n, 'M')==0  then iterate         /*No digs in common?  Skip it.*/
            if hasDup(d)             then iterate         /*Any digs are dups?    "   " */
            q= n/d                                        /*compute quotient just once. */
                  do e=1  for L;     xo= substr(n, e, 1)  /*try crossing out each digit.*/
                  nn= space( translate(n, , xo), 0)       /*elide from the numerator.   */
                  dd= space( translate(d, , xo), 0)       /*  "     "   "  denominator. */
                  if nn/dd \== q  then iterate            /*Not the same quotient? Skip.*/
                  $.L=    $.L    + 1                      /*Eureka!   We found one.     */
                  $.L.xo= $.L.xo + 1                      /*count the silly reduction.  */
                  if $.L>show  then iterate               /*Too many found?  Don't show.*/
                  say center(n'/'d   " = "   nn'/'dd  "  by crossing out the" xo"'s.", 79)
                  end   /*e*/
            end         /*d*/
         end            /*n*/
      end               /*L*/
say;                  @with= ' with crossed-out' /* [↓]  show counts for any reductions.*/
      do k=1  for 9                              /*traipse through each cross─out digit.*/
      if $.k==0  then iterate                    /*Is this a zero count?  Then skip it. */
      say;    say center('There are '     $.k     " "k'-digit fractions.', 79, "═")
                          @for= '          For ' /*literal for SAY indentation (below). */
         do #=1  for 9;   if $.k.#==0  then iterate
         say @for    k"-digit fractions, there are "    right($.k.#, k-1)   @with   #"'s."
         end   /*#*/
      end      /*k*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
hasDup: parse arg x;          /* if L<2  then return 0 */           /*L will never be 1.*/
           do i=1  for L-1;      if pos(substr(x,i,1), substr(x,i+1)) \== 0  then return 1
           end   /*i*/;                                                           return 0
