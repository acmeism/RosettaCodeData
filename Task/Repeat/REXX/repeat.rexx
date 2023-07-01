/*REXX program   executes   a  named  procedure  a specified number of times.           */
parse arg pN # .                                 /*obtain optional arguments from the CL*/
if #=='' | #==","   then #= 1                    /*assume  once  if not specified.      */
if pN\==''          then call repeats pN, #      /*invoke the REPEATS procedure for  pN.*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
repeats: procedure;  parse arg x,n               /*obtain the procedureName & # of times*/
                do n;  interpret 'CALL' x;  end  /*repeat the invocation    N    times. */
         return                                  /*return to invoker of the REPEATS proc*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
yabba:   say 'Yabba, yabba do!';          return /*simple code;  no need for  PROCEDURE.*/
