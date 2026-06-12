/*REXX pgm reads a number (from the CL), reads that number of pairs, & writes their sum.*/
                                                 /*all input is from the  Command Line. */
     do  linein()                                /*read the number of pairs to be add*ed*/
     $=linein()                                  /*read a line (a record) from the C.L. */
     say word($, 1)   +   word($, 2)             /*display the sum of a pair of numbers.*/
     end   /*linein() */
                                                 /*stick a fork in it,  we're all done. */
