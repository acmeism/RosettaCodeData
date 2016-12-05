/*REXX program demonstrates a method to track history of assignments to a REXX variable.*/
varSet!.=0                                       /*initialize the all of the VARSET!'s. */
call varSet 'fluid',min(0,-5/2,-1)     ;    say 'fluid=' fluid
call varSet 'fluid',3.14159            ;    say 'fluid=' fluid
call varSet 'fluid',' Santa  Claus'    ;    say 'fluid=' fluid
call varSet 'fluid',,999
say 'There were' result "assignments (sets) for the FLUID variable."
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
varSet: arg ?x;  parse arg ?z, ?v, ?L            /*obtain varName, value, optional─List.*/
if ?L=='' then do                                /*not la ist,  so set the  X  variable.*/
               ?_=varSet!.0.?x+1                 /*bump the history count  (# of SETs). */
               varSet!.0.?x=?_                   /*   ... and store it in the "database"*/
               varSet!.?_.?x=?v                  /*   ... and store the  SET  value.    */
               call value(?x),?v                 /*now,  set the real  X  variable.     */
               return ?v                         /*also, return the value for function. */
               end
say                                              /*show a blank line for readability.   */
            do ?j=1 to ?L while ?j<=varSet!.0.?x /*display the list of  "set"  history. */
            say 'history entry' ?j "for var" ?z":" varSet!.?J.?x
            end   /*?j*/
return ?j-1                                      /*return the number of assignments.    */
