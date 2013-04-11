/*REXX pgm demonstrates how to achieve movement of the terminal cursor. */

parse value scrsize() with sd sw       /*find the display screen size.  */
parse value cursor() with row col      /*find where the cursor is now.  */

colL=col-1;  if colL==0 then colL=sw   /*prepare to move cursor to left.*/
call cursor row,colL                   /*move cursor to the left (wrap).*/

colR=col+1;  if colR>sw then colL=1    /*prepare to move cursor to right*/
call cursor row,colR                   /*move cursor to the right (wrap)*/

rowU=row-1;  if rowU==0 then rowU=sd   /*prepare to move cursor up.     */
call cursor rowU,col                   /*move cursor  up  (with wrap).  */

rowD=row+1;  if rowD>sd then rowD=1    /*prepare to move cursor down.   */
call cursor rowD,col                   /*move cursor down (with wrap).  */

call cursor row,1                      /*move cursor to beginning of row*/
call cursor row,sw                     /*move cursor to    end    of row*/
call cursor 1,1                        /*move cursor to top left corner.*/
call cursor sd,sw                      /*move cursor to bot right corner*/

                                       /*stick a fork in it, we're done.*/
