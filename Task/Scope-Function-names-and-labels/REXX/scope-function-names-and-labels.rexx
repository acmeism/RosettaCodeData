/*REXX program demonstrates use of    labels    and a  CALL  statement. */
zz=4
signal do_add                   /*transfer program control to a   label.*/
ttt=sinD(30)                    /*this REXX statement is never executed.*/
                                /* [↓]   Note the case doesn't matter.  */
do_Add:                         /*coming here from the SIGNAL statement.*/

say 'calling the sub:  add.2.args'
call add.2.args 1,7             /*pass two arguments:   1   and a   7   */
say 'sum =' result
exit                            /*stick a fork in it, 'cause we're done.*/
/*────────────────────────────────subroutines (or functions)────────────*/
add.2.args:  procedure;  parse arg x,y;   return x+y

add.2.args:  say 'Whoa Nelly!!  Has the universe run amok?'
                                          /* [↑]  dead code, never XEQed*/
add.2.args:  return  arg(1) + arg(2)      /*concise, but never executed.*/
