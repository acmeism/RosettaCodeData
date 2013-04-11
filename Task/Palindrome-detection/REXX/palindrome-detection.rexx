/*REXX program checks to see if a phrase is palindromic.                */

y = 'In girum imus nocte et consumimur igni'

                     /*translation: We walk around in the night and     */
                     /*             we are burnt by the fire (of love). */
say 'string = ' y
say
if isPal(y)  then say 'The string is palindromic.'
             else say "The string isn't palindromic."
exit                                   /*stick a fork in it, we're done.*/

/*──────────────────────────────────ISPAL subroutine────────────────────*/
isPal:  procedure;  arg x              /*uppercases the value of arg X. */
x = space(x,0)                         /*removes all blanks (spaces).   */
return  x==reverse(x)                  /*returns  1  if exactly equal,  */
                                       /*   "     0  if not equal.      */
