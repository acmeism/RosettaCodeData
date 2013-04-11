/*REXX pgm finds the recursion limit:  a subroutine that calls itself.  */
parse version x;     say x;     say
n=0
call SELF  1
exit                            /*this statement will never be executed.*/
/*───────────────────────────SELF procedure─────────────────────────────*/
self: procedure expose n
n=n+1
say n
call self
