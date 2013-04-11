/*REXX program demonstrates use of labels and a CALL. */
zz=4
signal do_add
ttt=sinD(30)   /*this REXX statement is never executed.*/

do_add:        /*coming here from the SIGNAL statement.*/

say 'calling the sub add.2.args'
call add.2.args 1,7
say 'sum=' result
exit           /*stick a fork in it, 'cause we're done.*/

add.2.args: procedure; parse arg x,y;    return x+y
