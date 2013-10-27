/*REXX program demonstrates converting  decimal  ───►  binary.          */
numeric digits 200
x.=
x.1=0
x.2=5
x.3=50
x.4=9000
x.5=423785674235000123456789
x.6=1e138                              /*one quinquaquadragintillion.   */

              do j=1  while  x.j\==''  /*compute until a  NULL is found.*/
              y = strip( x2b( d2x( x.j )), 'L', 0)
              if y==''  then y=0       /*handle special case of 0 (zero)*/
              say y
              end   /*j*/
                                       /*stick a fork in it, we're done.*/
