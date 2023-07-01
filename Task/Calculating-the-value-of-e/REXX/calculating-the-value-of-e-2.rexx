/*REXX pgm calculates e to nn of decimal digits             */
Parse Arg dig             /* the desired precision          */
Numeric Digits (dig+3)    /* increase precision             */
dig2=dig+2                /* limit the loop                 */
e=1                       /* first element of the series    */
q=1                       /* next element of the series     */
Do n=1 By 1               /* start adding the elements      */
  old=e                   /* current sum                    */
  q=q/n                   /* new element                    */
  e=e+q                   /* add the new element to the sum */
  If left(e,dig2)=left(old,dig2) Then /* no change          */
    Leave                 /* we are done                    */
  End
Numeric Digits dig        /* the desired precision          */
e=e/1                     /* the desired approximation      */
Return left(e,dig+1) '('n 'iterations required)'
