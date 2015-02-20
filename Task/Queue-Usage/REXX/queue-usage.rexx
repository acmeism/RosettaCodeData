/*REXX program demonstrates three queue operations:  push, pop, empty.  */
say '══════════════════════════════════ Pushing five values to the stack.'
        do j=1 for 4                   /*loop to PUSH four values.      */
        call push j*10                 /*PUSH  (aka enqueue to stack).  */
        say 'pushed value:' j*10       /*echo the pushed value.         */
        if j\==3 then iterate          /*also, insert a  "null"  entry. */
        call push                      /*PUSH   (aka enqueue to stack). */
        say 'pushed a "null" value.'   /*echo what was pushed.          */
        end   /*j*/
say '══════════════════════════════════ Popping all values from the stack.'
        do m=1 while \empty()          /*EMPTY (returns TRUE if empty). */
        call pop                       /*POP   (aka dequeue from stack).*/
        say m': popped value=' result  /*echo the popped value.         */
        end   /*m*/
say '══════════════════════════════════ The stack is now empty.'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────subroutines/functions/operators.    */
push:   queue arg(1);  return          /*REXX  QUEUE   is FIFO.         */
pop:    procedure;  pull x;  return x  /*REXX PULL  removes a stack item*/
empty:  return queued()==0             /*returns the status of the stack*/
