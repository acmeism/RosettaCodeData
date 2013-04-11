/*REXX program maps a number from one range to another range.           */

rangeA = '0 10';    parse var rangeA a1 a2
rangeB = '-1 0';    parse var rangeB b1 b2

          do j=0  to 10
          say right(j,3)   ' maps to '   b1+(x-a1)*(b2-b1)/(a2-a1)
          end   /*j*/
                                       /*stick a fork in it, we're done.*/
