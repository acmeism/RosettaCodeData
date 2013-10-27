/*REXX program demonstrates converting  decimal  ───►  binary.          */
x.=
x.1 = 0
x.2 = 5
x.3 = 50
x.4 = 9000
              do j=1  while  x.j\==''   /*compute until a  NULL is found.*/
              y = strip( x2b( d2x( x.j )), 'L', 0)
              if y==''  then y=0        /*handle special case of 0 (zero)*/
              say  right(x.j,20)  'decimal, and in binary:'  y
              end   /*j*/
                                        /*stick a fork in it, we're done.*/
