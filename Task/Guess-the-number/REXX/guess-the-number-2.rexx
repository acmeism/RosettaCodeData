/*REXX program  interactively plays   "guess my number"   with a human. */
?=random(1,10)                         /*generate a low random integer. */
say 'Try to guess my number between 1 ──► 10  (inclusive).'  /*directive*/

                       do j=1  until  g=?               /*keep at it ···*/
                       if j\==1  then say 'Try again.'  /*2nd-ary prompt*/
                       pull g                           /*obtain a guess*/
                       end   /*j*/
say 'Well guessed!'                    /*stick a fork in it, we're done.*/
