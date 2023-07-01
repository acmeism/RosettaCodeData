/*REXX pgm calculates the (Mitchell) Feigenbaum bifurcation velocity, #digs can be given*/
parse arg digs maxi maxj .                       /*obtain optional argument from the CL.*/
if digs=='' | digs==","  then digs= 30           /*Not specified?  Then use the default.*/
if maxi=='' | maxi==","  then maxi= 20           /* "      "         "   "   "     "    */
if maxJ=='' | maxJ==","  then maxJ= 10           /* "      "         "   "   "     "    */
#= 4.669201609102990671853203820466201617258185577475768632745651343004134330211314737138,
                      || 68974402394801381716    /*◄──Feigenbaum's constant, true value.*/
numeric digits digs                              /*use the specified # of decimal digits*/
    a1=  1
    a2=  0
    d1=  3.2
say 'Using '    maxJ      " iterations for  maxJ,  with "      digs     ' decimal digits:'
say
say copies(' ', 9)             center("correct", 11)              copies(' ', digs+1)
say center('i', 9, "─")        center('digits' , 11, "─")         center('d', digs+1, "─")

    do i=2  for maxi-1
    a= a1  +  (a1 - a2) / d1
                               do maxJ
                               x= 0;   y= 0
                                                   do 2**i;       y= 1  -  2 * x * y
                                                                  x= a  -  x*x
                                                   end   /*2**i*/
                               a= a  -  x / y
                               end   /*maxj*/
    d= (a1 - a2)  /  (a - a1)                    /*compute the delta (D) of the function*/
    t= max(0, compare(d, #)  - 2)                /*# true digs so far, ignore dec. point*/
    say center(i, 9)     center(t, 11)     d     /*display values for  I & D ──►terminal*/
    parse value  d  a1  a    with    d1  a2  a1  /*assign 3 variables with 3 new values.*/
    end   /*i*/
                                                 /*stick a fork in it,  we're all done. */
say left('', 9 + 1 + 11 + 1 + t )"↑"             /*show position of greatest accuracy.  */
say '         true value= '    # / 1             /*true value of Feigenbaum's constant. */
