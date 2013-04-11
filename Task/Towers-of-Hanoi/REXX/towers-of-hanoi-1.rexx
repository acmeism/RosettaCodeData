/*REXX program to show the moves to solve the Tower of Hanoi (3 disks). */
arg z .                                /*get possible specification of Z*/
if z=='' then z=3                      /*Not given? Use default 3 towers*/
move=0                                 /*number of ring moves so far.   */
call mov 1,3,z                         /*move top ring, then recurse... */
say
say 'The minimum number of moves to solve a' z "ring Tower of Hanoi is" 2**z-1
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────MOV subroutine───────────────────────────*/
mov:  procedure expose move;      arg #1, #2, #3
if #3==1 then call dsk #1, #2
         else do
              call mov #1,        6-#1-#2,   #3-1
              call mov #1,        #2,        1
              call mov 6-#1-#2,   #2,        #3-1
              end
return
/*─────────────────────────────DSK subroutine───────────────────────────*/
dsk:  move=move+1
say 'step' right(move,length(moves))":  move disk " arg(1) '──►' arg(2)
return
