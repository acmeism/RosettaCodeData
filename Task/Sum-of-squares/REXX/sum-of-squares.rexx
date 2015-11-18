/*REXX program sums the squares of the numbers in a (numeric) vector of 15 #s.*/
numeric digits 100                     /*allow 100─digit numbers; default is 9*/
v=-100 9 8 7 6 0 3 4 5 2 1 .5 10 11 12 /*define a vector with fifteen numbers.*/
$=0                                    /*initialize the  sum  ($)  to zero.   */
       do k=1  for words(v)            /*process each number in the  V vector.*/
       $=$ + word(v,k)**2              /*add squared element (#) to the sum.  */
       end   /*k*/                     /* [↑]  if vector is empty, then sum=0.*/

say 'The sum of '    words(v)    " squared elements for the  V  vector is: "   $
                                       /*stick a fork in it,  we're all done. */
