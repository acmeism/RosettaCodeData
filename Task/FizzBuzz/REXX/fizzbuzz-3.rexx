/*REXX program displays numbers  1 ──► 100  (some transformed) for the FizzBuzz problem.*/

   do j=1  for 100;  _=
   if j//3 ==0  then _=_'Fizz'
   if j//5 ==0  then _=_'Buzz'
/* if j//7 ==0  then _=_'Jazz' */                /* ◄─── note that this is a comment.   */
   say right(word(_ j,1),8)
   end   /*j*/                                   /*stick a fork in it,  we're all done. */
