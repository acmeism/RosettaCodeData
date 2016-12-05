/*REXX program sleeps  X  seconds  (the number of seconds is supplied via the argument).*/
parse arg secs .                                 /*obtain optional argument from the CL.*/
if secs=='' | secs==","  then secs=0             /*Not specified?  Then assume 0 (zero).*/
say 'Sleeping'    secs    "seconds."             /*inform the invoker what's happening. */
call delay secs                                  /*Snooze.  Hopefully, just a short nap.*/
say 'Awake!'                                     /*and now inform invoker we're running.*/
                                                 /*stick a fork in it,  we're all done. */
