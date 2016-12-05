/*REXX program to  convert  several  decimal numbers  to  binary  (or base 2).          */
                            numeric digits 200   /*ensure we can handle larger numbers. */
@.=;             @.1=    0
                 @.2=    5
                 @.3=   50
                 @.4= 9000
                 @.5=423785674235000123456789
                 @.6=         1e138              /*one quinquaquadragintillion      ugh.*/

  do j=1  while  @.j\==''                        /*compute until a  NULL value is found.*/
  y=strip( x2b( d2x( @.j )), 'L', 0)             /*force removal of  all leading zeroes.*/
  if y==''  then y=0                             /*handle the special case of  0 (zero).*/
  say right(@.j,20) 'decimal, and in binary:' y  /*display the number to the terminal.  */
  end   /*j*/                                    /*stick a fork in it,  we're all done. */
