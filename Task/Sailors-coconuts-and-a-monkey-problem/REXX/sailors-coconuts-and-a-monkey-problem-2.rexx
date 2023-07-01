/*REXX program  solves  a  riddle of 5 sailors, a pile of coconuts, and a monkey.       */

  do n=2  to 9                                   /*traipse through number of sailors.   */
     do $=0;                   nuts= $           /*perform while not valid # coconuts.  */
        do k=n  by -1  for n                     /*step through the possibilities.      */
        if nuts//n\==1  then iterate $           /*Not one coconut left?    No solution.*/
        nuts= nuts    -  (1  +  nuts % n)        /*subtract number of coconuts from pile*/
        end   /*k*/
      if (nuts\==0) & \(nuts//n\==0)  then leave /*is this a solution to the riddle ?   */
      end     /*$*/
  say 'sailors='n         "  coconuts="$         /*display number of sailors & coconuts.*/
  end         /*n*/                              /*stick a fork in it,  we're all done. */
