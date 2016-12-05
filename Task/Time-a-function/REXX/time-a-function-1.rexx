/*REXX program displays the elapsed time for a REXX function (or subroutine). */
arg reps .                             /*obtain an optional argument from C.L.*/
if reps==''  then reps=100000          /*Not specified?  No, then use default.*/
call time 'Reset'                      /*only the 1st character is examined.  */
junk = silly(reps)                     /*invoke the  SILLY  function (below). */
                                       /*───►   CALL SILLY REPS    also works.*/

             /*                          The    E   is for    elapsed    time.*/
             /*                                 │             ─               */
             /*                        ┌────◄───┘                             */
             /*                        │                                      */
             /*                        ↓                                      */
say 'function SILLY took' format(time("E"),,2)  'seconds for' reps "iterations."
             /*                             ↑                                 */
             /*                             │                                 */
             /*            ┌────────►───────┘                                 */
             /*            │                                                  */
             /* The above  2  for the  FORMAT  function displays the time with*/
             /* two decimal digits (rounded)  past the decimal point).  Using */
             /* a   0  (zero)    would round the  time  to whole seconds.     */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
silly: procedure               /*chew up some CPU time doing some silly stuff.*/
            do j=1  for arg(1) /*wash,  apply,  lather,  rinse,  repeat.  ··· */
            @.j=random() date() time() digits() fuzz() form() xrange() queued()
            end   /*j*/
 return j-1
