/*REXX program detects a cycle in an iterated function  [F]  using a sequential search. */
x= 3;  $= x                                                /*initial couple of variables*/
                            do  until cycle\==0;   x= f(x) /*calculate another number.  */
                            cycle= wordpos(x, $)           /*This could be a repeat.    */
                            $= $  x                        /*append number to   $  list.*/
                            end   /*until*/
say '  original list='  $ ...                              /*display the sequence.      */
say 'numbers in list='  words($)                           /*display number of numbers. */
say '  cycle length ='  words($) - cycle                   /*display the cycle   to term*/
say '  start index  ='  cycle - 1     "  ◄─── zero based"  /*   "     "  index    "   " */
say 'cycle sequence ='  subword($, cycle, words($)-cycle)  /*   "     "  sequence "   " */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
f:   return ( arg(1) **2  +  1)   //   255       /*this defines/executes the function F.*/
