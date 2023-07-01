/*REXX program to  convert  several  decimal numbers  to  binary  (or base 2).          */
@.=;             @.1=    0
                 @.2=    5
                 @.3=   50
                 @.4= 9000

  do j=1  while  @.j\==''                        /*compute until a  NULL value is found.*/
  y=word( strip( x2b( d2x( @.j )), 'L', 0) 0, 1) /*elides all leading 0s, if null, use 0*/
  say right(@.j,20) 'decimal, and in binary:' y  /*display the number to the terminal.  */
  end   /*j*/                                    /*stick a fork in it,  we're all done. */
