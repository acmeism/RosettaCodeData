/*REXX program detects a cycle in an iterated function  [F]  using a  hash  table.      */
!.= .;    !.x= 1;                               x= 3;    $= x  /*assign initial value.  */
                         do #=1+words($);  x= f(x);   $= $  x  /*add the number to list.*/
                         if !.x\==.  then leave                /*A repeat?   Then leave.*/
                         !.x= #                                /*N:  numbers in  $ list.*/
                         end   /*#*/
say '  original list=' $   ...                                 /*maybe display the list.*/
say 'numbers in list=' #                                       /*display number of nums.*/
say '  cycle length =' # - !.x                                 /*   "      "    cycle.  */
say '  start index  =' !.x - 1      "  ◄───  zero based"       /*   "      "    index.  */
say 'cycle sequence =' subword($, !.x, # - !.x)                /*   "      "   sequence.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
f:   return ( arg(1) **2  +  1)   //   255       /*this defines/executes the function F.*/
