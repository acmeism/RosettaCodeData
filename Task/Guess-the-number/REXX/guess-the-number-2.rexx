/*REXX program interactively plays "guess my number" with a human, the range is 1──►10. */
?= random(1, 10)                                 /*generate a low random integer.       */
say 'Try to guess my number between 1 ──► 10  (inclusive).'  /*the directive to be used.*/

                     do j=1  until  g=?                      /*keep prompting 'til done.*/
                     if j\==1  then say 'Try again.'         /*issue secondary prompt.  */
                     pull g                                  /*obtain a guess from user.*/
                     end   /*j*/
say 'Well guessed!'                              /*stick a fork in it,  we're all done. */
