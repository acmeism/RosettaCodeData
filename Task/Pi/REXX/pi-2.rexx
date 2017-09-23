/*REXX program spits out decimal digits of pi  (one digit at a time)  until  Ctrl-Break.*/
signal on halt
parse arg digs oFID .                            /*obtain optional argument from the CL.*/
if digs=='' | digs==","  then digs= 300          /*Not specified?  Then use the default.*/
if oFID=='' | oFID==","  then oFID='PI_SPIT2.OUT' /*"      "         "   "   "      "   */
numeric digits digs                              /*with bigger digs, spitting is slower.*/
q=1;   r=0;   t=1;   k=1;   n=3;   L=3;   z=0    /*define some REXX variables.          */
dot=1                                            /*DOT≡a flag when a dot in pi is shown.*/
      do until z==digs;            qq= q+q       /*  qq     is a fast version of:  q*2  */
      tn= t*n                                    /*  t*n    is used twice  (below).     */
      if qq+qq+r-t < tn  then do;  z= z+1        /*  qq+qq  is faster than   qq*2       */
                                   call charout     , n
                                   call charout oFID, n
                                   if dot  then do;  dot=0;  call charout     , .
                                                             call charout oFID, .
                                                end
                                   nr= (r - tn) * 10
                                   n = ((( (qq+q+r) * 10) / t) - n*10)  %1
                                   q = q*10
                              end
                         else do;  nr= (qq+r) * L
                                   tL= t*L
                                   n = (q * (k*7 + 2)  +  r*L) / tL  %1
                                   q = q*k
                                   t = tL
                                   L = L+2
                                   k = k+1
                              end                /* %1≡fast way doing TRUNC of a number.*/
      r=nr
      end   /*forever*/
exit
halt: say;     say 'PI_SPIT2 halted via use of Ctrl-Break.';    exit
