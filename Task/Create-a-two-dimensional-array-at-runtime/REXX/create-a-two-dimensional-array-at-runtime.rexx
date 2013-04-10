/*REXX program to  allocate/populate/display  a two-dimensional array.  */
call bloat
                               /*no more array named  A.  at this point.*/
exit                           /*stick a fork in it, we're all done.    */
/*─────────────────────────BLOAT subroutine─────────────────────────────*/
bloat: procedure;  say
say 'Enter two positive integers (a 2-dimensional array will be created).'
pull n m .                   /*there is no way to pre-allocate an array,*/
                             /*REXX will allocate each element when it's*/
                             /*assigned.                                */

a.='~'                       /*default value for all elements so far.   */
                             /*this ensures every element has a value.  */
  do j    =1  for n
      do k=1  for m
      if random()//7==0  then a.j.k=j'_'k    /*populate every 7th random*/
      end  /*k*/
  end      /*j*/

  do r=1  for n              /*display array to the console  (row,col). */
  _=
        do c=1  for m
        _=_ right(a.r.c,4)   /*display one row at a time, align the vals*/
        end   /*kk*/
  say _
  end        /*jj*/
                             /*when the RETURN is executed (from a      */
                             /*PROCEDURE in this case), the array  A. is*/
                             /*"de-allocated", that is, it's no longer  */
                             /*defined, and the memory that the array   */
                             /*has is now free for other REXX variables.*/

                             /*If the   BLOAT   subroutine didn't have  */
                             /*a  "PROCEDURE"  on that statement,  the  */
                             /*array     "a."     would be left intact. */

                             /*The same effect is performed by a DROP.  */
drop a.                      /*because of the  PROCEDURE  statement,    */
return                       /*      the DROP statement is superfluous. */
