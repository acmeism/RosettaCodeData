/*REXX program to create two exceptions & demonstrate how to handle them*/
call foo                               /*invoke the  FOO  function.     */
say 'mainline program is done.'        /*indicate that Elroy was here.  */
exit                                   /*stick a fork in it, we're done.*/

/*──────────────────────────────────FOO function────────────────────────*/
foo:   call bar;   call bar            /*invoke  BAR  function twice.   */
       return 0                        /*return a zero to invoker.      */
U0: say 'exception U0 caught in FOO'   /*handle the  U0  exception.     */
return -2                              /*return to the invoker.         */

/*──────────────────────────────────BAR function────────────────────────*/
bar:   call baz                        /*have BAR invoke BAZ function.  */
       return 0                        /*return a zero to invoker.      */

/*──────────────────────────────────BAZ function────────────────────────*/
baz:   if symbol('BAZ#')=='LIT' then baz#=0 /*initialize BAZ invocation#*/
       baz# = baz#+1                   /*bump the BAZ invocation # by 1.*/
       if baz#==1  then signal U0      /*if first  invocation, raise U0 */
       if baz#==2  then signal U1      /* " second      "        "   U1 */
       return 0                        /*return a zero to invoker.      */
U0: return -1                          /*handle exception if not caught.*/
U1: return -1                          /*   "       "      "  "     "   */
