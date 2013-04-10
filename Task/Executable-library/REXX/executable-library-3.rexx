/*REXX pgm finds the most common (popular) hailstone sequence length.   */
parse arg z .;  if z=='' then z=99999  /*get the optional first argument*/
!.=0
w=0;          do j=1  for z            /*═════════════task 4════════════*/
              #=words(hailstone(j))    /*obtain hailstone sequence count*/
              !.# = !.# + 1            /*add unity to popularity count. */
              end   /*j*/
occ=0;  p=0
              do k=1  for z
              if !.k>occ  then do;  occ=!.k;  p=k;  end
              end   /*p*/

say '(between 1──►'z") "  p,
' is the most common hailstone sequence length  (with' occ "occurrences)."
                                       /*stick a fork in it, we're done.*/
