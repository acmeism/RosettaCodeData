/*REXX program demonstrates reading a char at  specific screen location.*/
row = 6                                /*point to row six.              */
col = 3                                /*point to column three.         */
howMany = 1                            /*read one character.            */

stuff = scrRead(row, col, howMany)     /*this'll do it.                 */

other = scrRead(40, 6, 1)              /*same thing, but for row forty. */
                                       /*stick a fork in it, we're done.*/
