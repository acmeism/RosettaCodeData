/*REXX program performs division on positive integers using the Egyptian division method*/
numeric digits 1000                              /*support gihugic numbers & be gung-ho.*/
parse arg n d .                                  /*obtain optional arguments from the CL*/
if d=='' | d==","  then do;  n= 580;    d= 34    /*Not specified?  Then use the defaults*/
                        end
call EgyptDiv n, d                               /*invoke the Egyptian Division function*/
parse var result q r                             /*extract the quotient & the remainder.*/
say n   ' divided by '       d       " is "       q       ' with a remainder of '      r
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
EgyptDiv: procedure;  parse arg num,dem          /*obtain the numerator and denominator.*/
          p= 1;                       t= dem     /*initialize the double & power values.*/
                        do #=1  until t>num      /*construct the power & doubling lists.*/
                        pow.#= p;     p= p + p   /*build power  entry; bump power value.*/
                        dbl.#= t;     t= t + t   /*  "  doubling  "  ;   " doubling val.*/
                        end   /*#*/
          acc=0;  ans=0                          /*initialize accumulator & answer to 0 */
                        do s=#   by -1   for #   /* [↓]  process the table "backwards". */
                        sum= acc + dbl.s         /*compute the sum (to be used for test)*/
                        if sum>num  then iterate /*Is sum to big?  Then ignore this step*/
                        acc= sum                 /*use the "new" sum for the accumulator*/
                        ans= ans + pow.s         /*calculate the (newer) running answer.*/
                        end   /*s*/
          return ans  num-acc                    /*return the answer and the remainder. */
