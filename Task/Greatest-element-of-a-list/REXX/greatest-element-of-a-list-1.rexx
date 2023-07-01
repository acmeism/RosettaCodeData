/*REXX program finds the  greatest element  in a list (of the first 25 reversed primes).*/
$ = reverse(2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97)
say 'list of numbers = '  $                      /*show the original list of numbers.   */
big=word($, 1)                                   /*choose an initial biggest number.    */
# = words($);        do j=2  to #                /*traipse through the list,  find max. */
                     big=max(big, word($, j) )   /*use the  MAX  BIF to find the biggie.*/
                     end   /*j*/
say                                              /*stick a fork in it,  we're all done. */
say 'the biggest value in a list of '     #      " numbers is: "     big
