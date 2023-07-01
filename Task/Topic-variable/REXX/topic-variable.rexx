/*REXX program shows something close to a  "topic variable" (for functions/subroutines).*/
parse arg N                                      /*obtain a variable from the cmd line. */
call  squareIt N                                 /*invoke a function to square da number*/
say   result       '  ◄───'                      /*display returned value from the func.*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
squareIt:  return  arg(1) ** 2                   /*return the square of passed argument.*/
