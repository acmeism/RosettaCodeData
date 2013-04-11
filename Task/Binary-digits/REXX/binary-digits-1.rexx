/*REXX program demonstrates converting  decimal  ───►  binary.          */
numeric digits 1000

x.1 = 0
x.2 = 5
x.3 = 50
x.4 = 9000

              do j=1  for 4
              y = x2b(d2x(x.j)) + 0
              say  right(x.j,20)  'decimal, and in binary:'  y
              end   /*j*/
                                        /*stick a fork in it, we're done.*/
