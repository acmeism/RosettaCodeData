/*REXX program to  convert  several  decimal numbers  to  binary  (or base 2).          */
                            numeric digits 1000  /*ensure we can handle larger numbers. */
@.=;             @.1=    0
                 @.2=    5
                 @.3=   50
                 @.4= 9000

  do j=1  while  @.j\==''                        /*compute until a  NULL value is found.*/
  y=x2b( d2x(@.j) )     + 0                      /*force removal of extra leading zeroes*/
  say right(@.j,20) 'decimal, and in binary:' y  /*display the number to the terminal.  */
  end   /*j*/                                    /*stick a fork in it,  we're all done. */
