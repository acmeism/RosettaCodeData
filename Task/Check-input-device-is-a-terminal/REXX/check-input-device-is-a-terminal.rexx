/*REXX program determines if input comes from terminal or standard input*/

if queued()  then say 'input comes from the terminal.'
             else say 'input comes from the (stacked) terminal queue.'

                                       /*stick a fork in it, we're done.*/
