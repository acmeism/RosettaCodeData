/*REXX pgm generates & displays the Thue─Morse sequence up to the Nth term (inclusive). */
parse arg N .                                    /*obtain the optional argument from CL.*/
if N=='' | N==","  then N= 80                    /*Not specified?  Then use the default.*/
$=                                               /*the Thue─Morse sequence  (so far).   */
         do j=0  to N                            /*generate sequence up to the Nth item.*/
         $= $ || length( space( translate( x2b( d2x(j) ), , 0), 0)) // 2  /*append to $.*/
         end   /*j*/
say $                                            /*stick a fork in it,  we're all done. */
