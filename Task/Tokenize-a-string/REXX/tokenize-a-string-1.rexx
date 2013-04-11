/*REXX program to seperate a string of comma-delimited words, and echo. */
sss = 'Hello,How,Are,You,Today'        /*words seperated by commas (,). */
say 'input string='sss                 /*display the original string.   */
new=sss                                /*make a copy of the string.     */

  do items=1  until new==''            /*keep going until SSS is empty. */
  parse var new a.items ',' new        /*parse words delinated by comma.*/
  end   /*items*/

say;   say 'Words in the string:'      /*display a header for the list. */

     do k=1  for items                 /*now, display all the words.    */
     say a.k'.'                        /*append a period to the word.   */
     end   /*k*/

say 'End-of-list.'                     /*display a trailer for the list.*/
                                       /*stick a fork in it, we're done.*/
