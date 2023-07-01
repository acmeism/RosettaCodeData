/*REXX program displays a  "spinning rod"  (AKA:  trobbers  or  progress indicators).   */

if 4=='f4'x  then bs= "16"x                      /*EBCDIC?  Then use this backspace chr.*/
             else bs= "08"x                      /* ASCII?    "   "    "      "      "  */

signal on halt                                   /*jump to   HALT   when user halts pgm.*/
$= '│/─\'                                        /*the throbbing characters for display.*/
                  do j=1                         /*perform  until  halted by the user.  */
                  call charout ,  bs  ||  substr($, 1 + j//length($), 1)
                  call delay .25                 /*delays a quarter of a second.        */
                  if result==1  then leave       /*see if  HALT  was issued during DELAY*/
                  end   /*j*/

halt: say bs  ' '                                /*stick a fork in it,  we're all done. */
