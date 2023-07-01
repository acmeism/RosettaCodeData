/*REXX program demonstrates moving the cursor position and writing of text to same place*/

call cursor  3,6                                 /*move the cursor to  row 3, column 6. */
say 'Hello'                                      /*write the text at that location.     */



call scrwrite 30,50,'Hello.'                     /*another method,  different location. */

call scrwrite 40,60,'Hello.',,,14                /*another method  ...  in yellow.      */
exit 0                                           /*stick a fork in it,  we're all done. */
