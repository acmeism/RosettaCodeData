/*REXX program demonstrates a REXX    currying method    to perform addition.           */
say 'add 2 to 3:          '   add(2, 3)
say 'add 2 to 3 (curried):'   add2(3)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
add:  procedure;  $= arg(1);       do j=2  to arg();   $= $ + arg(j);   end;      return $
add2: procedure;  return add( arg(1), 2)
