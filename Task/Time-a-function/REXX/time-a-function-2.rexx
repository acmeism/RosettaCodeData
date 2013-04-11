/*REXX program shows the CPU time used for a REXX pgm since it started. */
arg times .                            /*get the arg from command line. */
if times=='' then times=100000         /*any specified?  No, use default*/
junk = silly(times)                    /*invoke the  SILLY  function.   */
                                       /* CALL SILLY TIMES   also works.*/

                                       /*The    J   is for time used by */
             /*                                 │     the REXX program  */
             /*                        ┌────────┘     since it started, */
             /*                        │    this is a Regina extension. */
             /*                        ↓                                */
say 'function SILLY took' format(time("J"),,2) 'seconds for' times "iterations."
             /*                             ↑                           */
             /*                             │                           */
             /*            ┌────────────────┘                           */
             /*            │                                            */
             /* The above  2  for the FORMAT function displays the time */
             /* with 2 decimal digits (past the decimal point).   Using */
             /* a  0  (zero)   would round the  time  to whole seconds. */
exit
/*──────────────────────────────────SILLY subroutine────────────────────*/
silly: procedure         /*chew up some CPU time doing some silly stuff.*/
      do j=1 for arg(1)  /*wash,  apply,  lather,  rinse,  repeat.  ... */
      a.j=random() date() time() digits() fuzz() form() xrange() queued()
      end   /*j*/
return j-1
