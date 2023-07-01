/*REXX program demonstrates the showing of  reverse  video  to the display terminal.    */
@day   = 'day'
@night = 'night'

call scrwrite , 1, @day, , , 7                   /*display to terminal:  white on black.*/
call scrwrite , 1+length(@day), @night, , , 112  /*   "     "     "      black  " white.*/

exit 0                                           /*stick a fork in it,  we're all done. */
