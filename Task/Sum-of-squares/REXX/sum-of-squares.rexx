/*REXX program to  sum  the  squares  of a  vector  of fifteen numbers. */
numeric digits 50                      /*allow 50-digit # (default is 9)*/
v=-100 9 8 7 6 0 3 4 5 2 1 .5 10 11 12 /*define a vector with some #s.  */
sum=0                                  /*initialize   SUM   to zero.    */
                                       /*if vector is empty, sum = zero.*/
  do k=1  for words(v)                 /*process each number in the list*/
  sum=sum + word(v,k)**2               /*add squared element to the sum.*/
  end   /*k*/

say  'The sum of '   words(v)    " elements for the  V  vector is: "   sum
                                       /*stick a fork in it, we're done.*/
