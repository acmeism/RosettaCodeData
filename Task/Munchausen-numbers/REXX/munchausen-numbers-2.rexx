/*REXX program finds and displays Münchhausen numbers from one to a specified number (Z)*/
@.= 0;         do i=1  for 9;  @.i= i**i;  end   /*precompute powers for non-zero digits*/
parse arg z .                                    /*obtain optional argument from the CL.*/
if z=='' | z==","  then z= 5000                  /*Not specified?  Then use the default.*/
@is='is a Münchhausen number.';   do j=1  for z  /* [↓]  traipse through all the numbers*/
                                  if isMunch(j)  then say  right(j, 11)    @is
                                  end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isMunch: parse arg x 1 ox;  $= 0;   do  until  x==''  |  $>ox       /*stop if too large.*/
                                    parse var x _ +1 x;  $= $ + @._ /*add the next power*/
                                    end   /*while*/                 /* [↑]  get a digit.*/
         return $==ox                                               /*it is or it ain't.*/
