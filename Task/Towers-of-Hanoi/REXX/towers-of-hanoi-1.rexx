/*REXX program  displays  the  moves  to solve  the  Tower of Hanoi  (with  N  disks).  */
parse arg N .                                    /*get optional number of disks from CL.*/
if N=='' | N==","  then N=3                      /*Not specified?  Then use the default.*/
#= 0                                             /*#:  the number of disk moves (so far)*/
z= 2**N  -  1                                    /*Z:   "     "    " minimum # of moves.*/
call mov  1, 3, N                                /*move the top disk,  then recurse ··· */
say                                              /* [↓]  Display the minimum # of moves.*/
say 'The minimum number of moves to solve a '      N"─disk  Tower of Hanoi is "     z
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
mov: procedure expose # z; parse arg  @1,@2,@3;          L= length(z)
     if @3==1  then do;  #= # + 1                /*bump the (disk) move counter by one. */
                         say 'step'   right(#, L)":  move disk on tower"   @1  '───►'   @2
                    end
               else do;  call mov @1,               6 -@1 -@2,         @3 -1
                         call mov @1,               @2,                  1
                         call mov 6 - @1 - @2,      @2,                @3 -1
                    end
     return                                      /* [↑]  this subroutine uses recursion.*/
