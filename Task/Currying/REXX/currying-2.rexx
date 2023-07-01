/*REXX program demonstrates a REXX    currying method    to perform addition.           */
say 'add 2 to 3:          '   add(2, 3)
say 'add 2 to 3 (curried):'   add2(3)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
add:  procedure;  $= 0;       do    j=1  for arg()
                                 do k=1  for words( arg(j) );      $= $ + word( arg(j), k)
                                 end   /*k*/
                              end      /*j*/
      return $
/*──────────────────────────────────────────────────────────────────────────────────────*/
add2: procedure;  return add( arg(1), 2)
