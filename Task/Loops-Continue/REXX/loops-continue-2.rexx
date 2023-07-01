/*REXX program  illustrates  an example of a   DO   loop with an  ITERATE  (continue).  */
$=                                               /*nullify the variable used for display*/
    do j=1  for 10                               /*this is equivalent to:  DO J=1 TO 10 */
    $=$ || j', '                                 /*append the integer to a placeholder. */
    if j//5==0  then say left($, length($) - 2)  /*Is  J  a multiple of five?  Then SAY.*/
    if j==5     then $=                          /*start the display line over again.   */
    end   /*j*/
                                                 /*stick a fork in it,  we're all done. */
