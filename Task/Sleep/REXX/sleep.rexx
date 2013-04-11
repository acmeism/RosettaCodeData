/*REXX program to sleep   x   seconds (base in the argument). */
parse arg secs .                       /*get a (possible) argument.     */
secs=word(secs 0,1)                    /*if not present, assume 0 (zero)*/
say 'Sleeping' secs "seconds."         /*tell 'em what's happening.     */
call delay(secs)                       /*snooze.  Hopefully, a short nap*/
say 'Awake!'                           /*and tell 'em we're running.    */
