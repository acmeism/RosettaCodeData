/*REXX program calculates and displays the equilibrium index for a numeric array (list).*/
parse arg x                                      /*obtain the optional arguments from CL*/
if x=''  then x= copies(" 7 -7", 50)   7         /*Not specified?  Then use the default.*/
say '         array list: '     space(x)         /*echo the array list to the terminal. */
#= words(x)                                      /*the number of elements in the X list.*/
              do j=0  for #;   @.j= word(x, j+1) /*zero─start is for zero─based array.  */
              end   /*j*/                        /* [↑]  assign   @.0   @.1   @.3  ···  */
say                                              /*  ··· and also display a blank line. */
answer= equilibriumIDX();       w= words(answer) /*calculate the  equilibrium index.    */
say 'equilibrium'  word("(none) index: indices:",   1 + (w>0) + (w>1))        answer
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
equilibriumIDX: $=;     do i=0  for #;           sum= 0
                                do k=0  for #;   sum= sum  +  @.k * sign(k-i);   end /*k*/
                        if sum==0  then $= $ i
                        end   /*i*/              /* [↑] Zero? Found an equilibrium index*/
                return $                         /*return equilibrium list (may be null)*/
