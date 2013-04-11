/*REXX pgm finds the recursion limit:  a subroutine that calls itself.  */
parse version x;     say x;     say
n=0
call SELF 2
exit                            /*this statement will never be executed.*/

/*───────────────────────────SELF subroutine────────────────────────────*/
self:  n=n+1
say n
call self
