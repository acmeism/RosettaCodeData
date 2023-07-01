/*REXX pgm generates & displays the Thue─Morse sequence up to the Nth term (inclusive). */
parse arg N .                                    /*obtain the optional argument from CL.*/
if N=='' | N==","  then N= 6                     /*Not specified?  Then use the default.*/
$= 0                                             /*the Thue─Morse sequence  (so far).   */
         do j=1  for N                           /*generate sequence up to the Nth item.*/
         $= $ || translate($, 10, 01)            /*append $'s  complement to  $  string.*/
         end   /*j*/
say $                                            /*stick a fork in it,  we're all done. */
