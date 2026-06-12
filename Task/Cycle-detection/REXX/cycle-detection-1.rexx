/*REXX program detects a cycle in an iterated function  [F]  using Brent's algorithm.   */
init= 3;   $= init
                                  do  until length($)>79;    $= $  f( word($, words($) ) )
                                  end   /*until*/
say '  original list='    $  ...                          /*display original number list*/
call Brent init                                           /*invoke Brent algorithm for F*/
parse var result cycle idx                                /*get 2 values returned from F*/
say 'numbers in list='    words($)                        /*display number of numbers.  */
say '  cycle length ='    cycle                           /*display the cycle    to term*/
say '  start index  ='     idx     "  ◄─── zero index"    /*   "     "  index     "   " */
say 'cycle sequence ='   subword($, idx+1, cycle)         /*   "     "  sequence  "   " */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Brent: procedure; parse arg x0 1 tort;   pow=1;     #=1   /*TORT  is set to value of X0.*/
       hare= f(x0)                                        /*get 1st value for the func. */
                   do  while tort\==hare
                   if pow==#  then do;  tort= hare        /*set value of TORT to HARE.  */
                                        pow = pow + pow   /*double the value of  POW.   */
                                        #   = 0           /*reset  #  to zero  (lambda).*/
                                   end
                   hare= f(hare)
                   #= # + 1                               /*bump the lambda count value.*/
                   end   /*while*/
       hare= x0
                   do #;          hare= f(hare)           /*generate number of F values.*/
                   end   /*j*/
       tort= x0                                           /*find position of the 1st rep*/
                   do mu=0  while tort \== hare           /*MU  is a  zero─based  index.*/
                                  tort= f(tort)
                                  hare= f(hare)
                   end   /*mu*/
       return # mu
/*──────────────────────────────────────────────────────────────────────────────────────*/
f:     return ( arg(1) **2  +  1)   //   255     /*this defines/executes the function F.*/
