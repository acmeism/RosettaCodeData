/*REXX program finds the recursion limit:   a subroutine that repeatably calls itself.  */
parse version x;     say x;     say             /*display which REXX is being used.     */
#=0                                             /*initialize the numbers of invokes to 0*/
call self                                       /*invoke the  SELF  subroutine.         */
                                                /* [↓]  this will never be executed.    */
exit                                            /*stick a fork in it,  we're all done.  */
/*──────────────────────────────────────────────────────────────────────────────────────*/
self:  #=#+1                                    /*bump number of times SELF is invoked. */
       say #                                    /*display the number of invocations.    */
       call self                                /*invoke ourselves recursively.         */
