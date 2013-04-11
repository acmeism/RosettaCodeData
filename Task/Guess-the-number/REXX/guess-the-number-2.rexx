/*REXX program to (interactively) play  "guess my number".              */
?=random(1,10)
say 'Try to guess my number between 1 ──► 10  (inclusive).'

                           do j=1  while g\=?
                           if j\==1  then say 'Try again.'
                           pull g
                           end   /*j*/
say 'Well guessed!'
                                       /*stick a fork in it, we're done.*/
