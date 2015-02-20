/*REXX pgm shows the moves to solve the Tower of Hanoi  (with 3 disks). */
parse arg N .                          /*get optional # towers from C.L.*/
if N==''  then N=3                     /*Not given? Use default 3 towers*/
#=0;      z=2**N - 1                   /*number of ring moves so far.   */
call mov 1, 3, N                       /*move top ring, then recurse··· */
say
say 'The minimum number of moves to solve a '  N  " Tower of Hanoi is "  z
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────DSK subroutine───────────────────────────*/
dsk:  #=#+1                            /*bump the move counter by one.  */
say 'step' right(#,length(z))":  move disk on tower"  arg(1) '───►' arg(2)
return
/*─────────────────────────────MOV subroutine───────────────────────────*/
mov:  procedure expose # z;        parse arg  @1,  @2,  @3
if @3==1  then call dsk @1,  @2
          else do
               call mov @1,        6-@1-@2,   @3-1
               call mov @1,        @2,        1
               call mov 6-@1-@2,   @2,        @3-1
               end
return
