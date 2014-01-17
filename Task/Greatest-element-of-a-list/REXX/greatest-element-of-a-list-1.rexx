/*REXX program finds the  greatest element  in a list  (of numbers).    */
                             /* [↓] list of first twenty reversed primes*/
y = 2 3 5 7 11 31 71 91 32 92 13 73 14 34 74 35 95 16 76 17
big=word(y,1)                          /*choose a initial biggest number*/
              do j=2  to words(y)      /*traipse through the list.      */
              big=max(big, word(y,j))  /*use the MAX bif to find biggie.*/
              end   /*j*/

say 'the biggest value in a list of '    words(y)    " numbers is: "   big
                             /* [↓] list of first twenty reversed primes*/
                                       /*stick a fork in it, we're done.*/
