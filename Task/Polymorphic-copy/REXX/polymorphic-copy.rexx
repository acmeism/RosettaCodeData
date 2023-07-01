/*REXX program to  copy  (polymorphically)  one variable's value into another variable. */
b= 'old value.'
a= 123.45
b= a                                             /*copy a variable's value into another.*/
if a==b  then say "copy did work."
         else say "copy didn't work."            /*didn't work, maybe ran out of storage*/
                                                 /*stick a fork in it,  we're all done. */
