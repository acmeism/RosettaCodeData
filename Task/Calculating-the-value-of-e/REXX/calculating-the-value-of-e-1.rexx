/*REXX pgm calculates  e  to a # of decimal digits. If digs<0, a running value is shown.*/
parse arg digs .                                 /*get optional number of decimal digits*/
if digs=='' | digs==","  then digs= 101          /*Not specified?  Then use the default.*/
numeric digits abs(digs);     w=length(digits()) /*use the absolute value of  digs.     */
                    e= 1;     q= 1               /*1st value of  e    and     q.        */
      do #=1  until e==old;   old= e             /*start calculations at the second term*/
      q= q / #                                   /*calculate the divisor for this term. */
      e= e + q                                   /*add quotient to running   e   value. */
      if digs>0  then iterate                    /*DIGS>0?  Then don't show running digs*/
      $= compare(e, old)                         /*$  is first digit not compared equal.*/
      if $>0  then say right('with', 10)    right(#+1, w)     "terms,"      right($-1, w),
            "decimal digits were calculated for   e   (Napier's constant)"     /*   ↑   */
      end   /*#*/                                /* -1  is for the decimal point────┘   */
say                                              /*stick a fork in it,  we're all done. */
say '(with'    abs(digs)      "decimal digits)   the value of   e   is:";         say e
