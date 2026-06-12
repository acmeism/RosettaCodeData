/*REXX program writes a number of lines from the default input file (C.L.).   */
#=linein()                             /*number of lines to be read from C.L. */

  do j=1  for #;   x.j=linein();  end  /*obtain input lines from stdin (C.L.).*/

call stuff                             /*call the STUFF subroutine for writes.*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
stuff:    do k=1  for #;   call lineout ,x.k;   end;          return
