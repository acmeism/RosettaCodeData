/*REXX program displays numbers  1 ──► 100  for the  FizzBuzz  problem. */

  do j=1  to 100;      z=j
  if j//3    ==0  then z='Fizz'
  if j//5    ==0  then z='Buzz'
  if j//(3*5)==0  then z='FizzBuzz'
  say right(z,8)
  end   /*j*/
                                       /*stick a fork in it, we're done.*/
