/*REXX pgm shows something close to a "topic variable" (for funcs/subs).*/
parse arg N                            /*get an arg from CL, maybe a 3? */
say  mysub(N)   '  ◄───'               /*invoke a function to square it.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────MYSUB subroutine (function)─────────*/
mysub:  return arg(1)**2               /*return the square of passed arg*/
