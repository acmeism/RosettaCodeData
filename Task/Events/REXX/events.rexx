/*REXX program shows a method of handling events (this is time-driven). */
signal on halt                         /*allow the user to HALT the pgm.*/
parse arg timeEvent                    /*allow "event" to be specified. */
if timeEvent=''  then timeEvent=5      /*if not specified, use default. */

event?:  do forever                    /*determine if an event occurred.*/
         theEvent=right(time(),1)      /*maybe it's an event, maybe not.*/
         if pos(theEvent,timeEvent)\==0  then  signal happening
         end   /*forever*/

say 'Control should never get here!'   /*This is a logic no-no occurance*/
halt: say 'program halted.';  exit     /*stick a fork in it, we're done.*/
/*───────────────────────────────────HAPPENING processing───────────────*/
happening:  say 'an event occurred at' time()", the event is:"   theEvent
  do  while theEvent==right(time(),1); /*process the event here.*/ nop;end
signal event?                          /*see if another event happened. */
