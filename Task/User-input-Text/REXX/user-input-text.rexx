/*REXX program gets a  string  and the  number 75000  from the console. */

say 'Please enter a text string:'      /*show prompt for a text string. */
parse pull userString                  /*get the user text and store it.*/

       do until userNumber=75000                 /*repeat until correct.*/
       say                                       /*display a blank line.*/
       say 'Please enter the number 75000'       /*show the nice prompt.*/
       parse pull userNumber                     /*get the user text.   */
       end   /*until*/                           /*now, check if it's OK*/

                                       /*stick a fork in it, we're done.*/
