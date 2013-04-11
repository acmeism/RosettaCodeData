/*REXX program demonstrates cursor position and writing of text to same.*/

call cursor  3,6                       /*move the cursor to row 3, col 6*/
say 'Hello'                            /*write the text at that location*/

call scrwrite 30,50,'Hello.'           /*another method.       */

call scrwrite 40,60,'Hello.',,,14      /*another ... in yellow.*/
