...
signal on syntax
...
y=4 - 4
x=66
say x/y                  /*divide x by y.*/
say "yup, that's a divide by zero, by gum."
exit

syntax: say

/* We can now possibly do some repair work , but most people trap */
/* the condition, display where it happened, the REXX sourceline  */
/* (the actual REXX statement),  which condition was triggered,   */
/* display any other pertinent REXX variables, which line in the  */
/* REXX program, and then (usually) exit with some kind of error  */
/* message and error code indicator.                              */
/* Note:  the "name" of the REXX program isn't quite accurate,    */
/* rather, it is the name that was invoked (called by), which may */
/* be different name than the actual program being executed.      */

say '──────────────────────error!─────────────────────────'
say 'that division (above) will cause control to get here.'
parse source . . fid .
say;  say  'REXX raised a SYNTAX error in program:' fid
say;  say  'it occurred on line' sigl
say;  say  'the REXX statement is:'     /*put it on separate line.*/
      say  sourceline(sigl)
say;  say  'which code:' condition('C') "error"
say;  say  'error code:' condition('D')
say;  say  "Moral: don't do that."
exit 13
