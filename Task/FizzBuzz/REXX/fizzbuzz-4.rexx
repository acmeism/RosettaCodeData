/*REXX program displays numbers  1 ──► 100  for the  FizzBuzz  problem. */
                                       /* [↓]  concise & somewhat obtuse*/
  do n=1  for 100
  say right(word(word('Fizz',1+(n//3\==0))word('Buzz',1+(n//5\==0)) n,1),8)
  end   /*n*/
                                       /*stick a fork in it, we're done.*/
