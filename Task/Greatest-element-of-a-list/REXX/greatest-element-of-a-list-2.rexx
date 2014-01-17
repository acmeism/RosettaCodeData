/*REXX program finds the  greatest element  in an array (of numbers).   */
y.=                                    /*set all array elements to null.*/
y.1  =  2;      y.2  =  3;      y.3  =  5;      y.4  =  7;      y.5  = 11
y.6  = 31;      y.7  = 71;      y.8  = 91;      y.9  = 32;      y.10 = 92
y.11 = 13;      y.12 = 73;      y.13 = 14;      y.14 = 34;      y.15 = 74
y.16 = 35;      y.17 = 95;      y.18 = 16;      y.19 = 76;      y.20 = 17

big   = y.1                            /*choose a initial biggest number*/
                do j=2  while y.j\=='' /*traipse through the whole array*/
                big = max(big, y.j)    /*use a  BIF  to find the biggie.*/
                end   /*j*/

say 'the biggest value in an array of '    j-1     " elements is: "    big
                                       /*stick a fork in it, we're done.*/
