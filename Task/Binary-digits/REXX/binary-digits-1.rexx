/*REXX program demonstrates converting  decimal  ───►  binary.          */
numeric digits 1000
x.=
x.1 = 0
x.2 = 5
x.3 = 50
x.4 = 9000
              do j=1  while  x.j\==''   /*compute until a  NULL is found.*/
              y = x2b(d2x(x.j)) + 0     /*force removal of leading zeroes*/
              say  right(x.j,20)  'decimal, and in binary:'  y
              end   /*j*/
                                        /*stick a fork in it, we're done.*/
